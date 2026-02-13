import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';
import '../repositories/submission_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), AppConstants.databaseName);
    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table for session
    await db.execute('''
      CREATE TABLE ${AppConstants.usersTable}(
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        token TEXT,
        isLoggedIn INTEGER DEFAULT 0,
        createdAt TEXT
      )
    ''');

    // Create submissions table
    await db.execute('''
      CREATE TABLE ${AppConstants.submissionsTable}(
        id TEXT PRIMARY KEY,
        questionnaireId TEXT NOT NULL,
        questionnaireTitle TEXT NOT NULL,
        userEmail TEXT NOT NULL,
        answers TEXT NOT NULL,
        submissionDate TEXT NOT NULL,
        latitude REAL,
        longitude REAL
      )
    ''');

    // Create index on userEmail for faster queries
    await db.execute('''
      CREATE INDEX idx_user_email ON ${AppConstants.submissionsTable}(userEmail)
    ''');

    // Create index on submissionDate for sorting
    await db.execute('''
      CREATE INDEX idx_submission_date ON ${AppConstants.submissionsTable}(submissionDate)
    ''');
  }

  // User Session Methods
  Future<void> saveUserSession(String email, String token) async {
    final db = await database;

    // Clear previous session
    await db.delete(AppConstants.usersTable);

    await db.insert(
      AppConstants.usersTable,
      UserModel(
        id: const Uuid().v4(),
        email: email,
        token: token,
        isLoggedIn: true,
        createdAt: DateTime.now(),
      ).toMap(),
    );
  }

  Future<Map<String, dynamic>> getUserSession() async {
    final db = await database;
    final List<Map<String, dynamic>> users = await db.query(AppConstants.usersTable);

    if (users.isNotEmpty) {
      final user = UserModel.fromMap(users.first);
      return {
        'isLoggedIn': user.isLoggedIn,
        'userEmail': user.email,
        'sessionToken': user.token ?? '',
      };
    }

    return {
      'isLoggedIn': false,
      'userEmail': '',
      'sessionToken': '',
    };
  }

  Future<void> clearUserSession() async {
    final db = await database;
    await db.delete(AppConstants.usersTable);
  }

  // Submission Methods
  Future<void> saveSubmission(SubmissionModel submission) async {
    final db = await database;
    await db.insert(
      AppConstants.submissionsTable,
      submission.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SubmissionModel>> getUserSubmissions(String userEmail) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.submissionsTable,
      where: 'userEmail = ?',
      whereArgs: [userEmail],
      orderBy: 'submissionDate DESC',
    );

    return List.generate(maps.length, (i) {
      return SubmissionModel.fromMap(maps[i]);
    });
  }

  Future<int> getUserSubmissionCount(String userEmail) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${AppConstants.submissionsTable} WHERE userEmail = ?',
      [userEmail],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Location Methods
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
  }

  Future<SubmissionModel> createSubmission({
    required String questionnaireId,
    required String questionnaireTitle,
    required String userEmail,
    required Map<String, String> answers,
  }) async {
    Position? position = await getCurrentLocation();

    return SubmissionModel(
      id: const Uuid().v4(),
      questionnaireId: questionnaireId,
      questionnaireTitle: questionnaireTitle,
      userEmail: userEmail,
      answers: json.encode(answers),
      submissionDate: DateTime.now(),
      latitude: position?.latitude,
      longitude: position?.longitude,
    );
  }

  // Delete old submissions (optional cleanup)
  Future<void> deleteOldSubmissions({int daysOld = 30}) async {
    final db = await database;
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));

    await db.delete(
      AppConstants.submissionsTable,
      where: 'submissionDate < ?',
      whereArgs: [cutoffDate.toIso8601String()],
    );
  }

  // Close database
  Future<void> close() async {
    final db = await _database;
    if (db != null && db.isOpen) {
      await db.close();
      _database = null;
    }
  }
}