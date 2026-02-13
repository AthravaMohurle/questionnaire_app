import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/questionnaire_model.dart';
import '../repositories/submission_model.dart';

class MockApiService {
  final String _baseUrl = AppConstants.baseUrl;

  Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<UserModel?> register(String email, String password) async {
    try {
      if (!await isConnected()) {
        throw Exception('No internet connection');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl${AppConstants.registerEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
          'createdAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        return UserModel.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      if (!await isConnected()) {
        throw Exception('No internet connection');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl${AppConstants.loginEndpoint}?email=$email&password=$password'),
      );

      if (response.statusCode == 200) {
        List<dynamic> users = json.decode(response.body);
        if (users.isNotEmpty) {
          var user = users.first;
          user['token'] = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
          return UserModel.fromJson(user);
        }
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<List<QuestionnaireModel>> getQuestionnaires() async {
    try {
      if (!await isConnected()) {
        return _getMockQuestionnaires();
      }

      final response = await http.get(
        Uri.parse('$_baseUrl${AppConstants.questionnairesEndpoint}'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((q) => QuestionnaireModel.fromJson(q)).toList();
      }
      return _getMockQuestionnaires();
    } catch (e) {
      print('Get questionnaires error: $e');
      return _getMockQuestionnaires();
    }
  }

  Future<bool> submitResponse(SubmissionModel submission) async {
    try {
      if (!await isConnected()) {
        return false; // Will be synced later
      }

      final response = await http.post(
        Uri.parse('$_baseUrl${AppConstants.submissionsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(submission.toJson()),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Submit error: $e');
      return false;
    }
  }

  List<QuestionnaireModel> _getMockQuestionnaires() {
    return [
      QuestionnaireModel(
        id: '1',
        title: 'Customer Satisfaction Survey',
        description: 'Help us improve our services by sharing your experience',
        questions: [
          QuestionModel(
            id: 'q1',
            text: 'How satisfied are you with our service?',
            options: ['Very Satisfied', 'Satisfied', 'Neutral', 'Dissatisfied', 'Very Dissatisfied'],
          ),
          QuestionModel(
            id: 'q2',
            text: 'How likely are you to recommend us?',
            options: ['Very Likely', 'Likely', 'Neutral', 'Unlikely', 'Very Unlikely'],
          ),
          QuestionModel(
            id: 'q3',
            text: 'How would you rate our response time?',
            options: ['Excellent', 'Good', 'Average', 'Poor', 'Very Poor'],
          ),
          QuestionModel(
            id: 'q4',
            text: 'Was your issue resolved?',
            options: ['Yes, completely', 'Partially', 'No', 'Not applicable'],
          ),
          QuestionModel(
            id: 'q5',
            text: 'How was your experience with our staff?',
            options: ['Excellent', 'Good', 'Fair', 'Poor', 'Very Poor'],
          ),
        ],
      ),
      QuestionnaireModel(
        id: '2',
        title: 'Site Visit Feedback',
        description: 'Share your experience during the site visit',
        questions: [
          QuestionModel(
            id: 'q1',
            text: 'Was the site clean and organized?',
            options: ['Very Clean', 'Clean', 'Average', 'Dirty', 'Very Dirty'],
          ),
          QuestionModel(
            id: 'q2',
            text: 'Were safety protocols followed?',
            options: ['Always', 'Mostly', 'Sometimes', 'Rarely', 'Never'],
          ),
          QuestionModel(
            id: 'q3',
            text: 'How was the equipment condition?',
            options: ['Excellent', 'Good', 'Fair', 'Poor', 'Very Poor'],
          ),
          QuestionModel(
            id: 'q4',
            text: 'Was the staff helpful?',
            options: ['Very Helpful', 'Helpful', 'Neutral', 'Unhelpful', 'Very Unhelpful'],
          ),
          QuestionModel(
            id: 'q5',
            text: 'Overall site rating',
            options: ['5 Stars', '4 Stars', '3 Stars', '2 Stars', '1 Star'],
          ),
        ],
      ),
      QuestionnaireModel(
        id: '3',
        title: 'Product Feedback',
        description: 'Tell us what you think about our product',
        questions: [
          QuestionModel(
            id: 'q1',
            text: 'How would you rate the product quality?',
            options: ['Excellent', 'Good', 'Average', 'Poor', 'Very Poor'],
          ),
          QuestionModel(
            id: 'q2',
            text: 'How satisfied are you with the features?',
            options: ['Very Satisfied', 'Satisfied', 'Neutral', 'Dissatisfied', 'Very Dissatisfied'],
          ),
          QuestionModel(
            id: 'q3',
            text: 'How easy is the product to use?',
            options: ['Very Easy', 'Easy', 'Neutral', 'Difficult', 'Very Difficult'],
          ),
          QuestionModel(
            id: 'q4',
            text: 'Would you purchase this product again?',
            options: ['Definitely', 'Probably', 'Not Sure', 'Probably Not', 'Definitely Not'],
          ),
          QuestionModel(
            id: 'q5',
            text: 'How does it compare to competitors?',
            options: ['Much Better', 'Better', 'Similar', 'Worse', 'Much Worse'],
          ),
        ],
      ),
    ];
  }
}