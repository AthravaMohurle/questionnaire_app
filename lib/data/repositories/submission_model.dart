import 'dart:convert';

class SubmissionModel {
  final String id;
  final String questionnaireId;
  final String questionnaireTitle;
  final String userEmail;
  final String answers; // Store as JSON string
  final DateTime submissionDate;
  final double? latitude;
  final double? longitude;

  SubmissionModel({
    required this.id,
    required this.questionnaireId,
    required this.questionnaireTitle,
    required this.userEmail,
    required this.answers,
    required this.submissionDate,
    this.latitude,
    this.longitude,
  });

  // Convert SubmissionModel to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionnaireId': questionnaireId,
      'questionnaireTitle': questionnaireTitle,
      'userEmail': userEmail,
      'answers': answers,
      'submissionDate': submissionDate.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Create SubmissionModel from Map (SQLite)
  factory SubmissionModel.fromMap(Map<String, dynamic> map) {
    return SubmissionModel(
      id: map['id'],
      questionnaireId: map['questionnaireId'],
      questionnaireTitle: map['questionnaireTitle'],
      userEmail: map['userEmail'],
      answers: map['answers'],
      submissionDate: DateTime.parse(map['submissionDate']),
      latitude: map['latitude'] != null
          ? (map['latitude'] is int
          ? (map['latitude'] as int).toDouble()
          : map['latitude'] as double)
          : null,
      longitude: map['longitude'] != null
          ? (map['longitude'] is int
          ? (map['longitude'] as int).toDouble()
          : map['longitude'] as double)
          : null,
    );
  }

  // Parse answers from JSON string to Map
  Map<String, String> getAnswersMap() {
    try {
      final Map<String, dynamic> decoded = json.decode(answers);
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      return {};
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionnaireId': questionnaireId,
      'questionnaireTitle': questionnaireTitle,
      'userEmail': userEmail,
      'answers': answers,
      'submissionDate': submissionDate.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}