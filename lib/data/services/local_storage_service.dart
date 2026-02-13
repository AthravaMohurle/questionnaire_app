import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import '../repositories/submission_model.dart';
import 'database_service.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  final DatabaseService _databaseService = DatabaseService();

  // User Session Methods
  Future<void> saveUserSession(String email, String token) async {
    await _databaseService.saveUserSession(email, token);
  }

  Future<Map<String, dynamic>> getUserSession() async {
    return await _databaseService.getUserSession();
  }

  Future<void> clearUserSession() async {
    await _databaseService.clearUserSession();
  }

  // Submission Methods
  Future<void> saveSubmission(SubmissionModel submission) async {
    await _databaseService.saveSubmission(submission);
  }

  Future<List<SubmissionModel>> getUserSubmissions(String userEmail) async {
    return await _databaseService.getUserSubmissions(userEmail);
  }

  Future<int> getUserSubmissionCount(String userEmail) async {
    return await _databaseService.getUserSubmissionCount(userEmail);
  }

  // Location Methods
  Future<Position?> getCurrentLocation() async {
    return await _databaseService.getCurrentLocation();
  }

  Future<SubmissionModel> createSubmission({
    required String questionnaireId,
    required String questionnaireTitle,
    required String userEmail,
    required Map<String, String> answers,
  }) async {
    return await _databaseService.createSubmission(
      questionnaireId: questionnaireId,
      questionnaireTitle: questionnaireTitle,
      userEmail: userEmail,
      answers: answers,
    );
  }

  // Helper Methods
  Map<String, String> parseAnswers(String answersJson) {
    try {
      final Map<String, dynamic> decoded = json.decode(answersJson);
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      return {};
    }
  }

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}