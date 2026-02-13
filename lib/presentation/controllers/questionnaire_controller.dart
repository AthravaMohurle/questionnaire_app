import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/mock_api_service.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/models/questionnaire_model.dart';

class QuestionnaireController extends GetxController {
  final MockApiService _apiService = MockApiService();
  final LocalStorageService _localStorage = LocalStorageService();

  // Reactive Variables
  var questionnaires = <QuestionnaireModel>[].obs;
  var isLoading = false.obs;
  var selectedAnswers = <String, String>{}.obs;
  var currentQuestionnaire = Rxn<QuestionnaireModel>();
  var currentQuestionIndex = 0.obs;
  var isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuestionnaires();
  }

  Future<void> fetchQuestionnaires() async {
    isLoading.value = true;
    try {
      final data = await _apiService.getQuestionnaires();
      questionnaires.value = data;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load questionnaires',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectAnswer(String questionId, String answer) {
    selectedAnswers[questionId] = answer;
    selectedAnswers.refresh();
    update();
  }

  void setCurrentQuestionnaire(QuestionnaireModel questionnaire) {
    currentQuestionnaire.value = questionnaire;
    selectedAnswers.clear();
    selectedAnswers.refresh();
    currentQuestionIndex.value = 0;
    update();
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < (currentQuestionnaire.value?.questions.length ?? 0) - 1) {
      currentQuestionIndex.value++;
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  bool isQuestionAnswered(String questionId) {
    return selectedAnswers.containsKey(questionId);
  }

  double getProgressPercentage() {
    if (currentQuestionnaire.value == null) return 0;
    if (currentQuestionnaire.value!.questions.isEmpty) return 0;
    return selectedAnswers.length / currentQuestionnaire.value!.questions.length;
  }

  bool validateAllQuestionsAnswered() {
    if (currentQuestionnaire.value == null) return false;
    if (currentQuestionnaire.value!.questions.isEmpty) return false;
    return currentQuestionnaire.value!.questions.length == selectedAnswers.length;
  }

  Future<void> submitAnswers() async {
    if (!validateAllQuestionsAnswered()) {
      Get.snackbar(
        'Error',
        'Please answer all questions before submitting',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }

    isSubmitting.value = true;

    try {
      final session = await _localStorage.getUserSession();
      final userEmail = session['userEmail'];

      if (userEmail == null || userEmail.isEmpty) {
        throw Exception('User not logged in');
      }

      // Simulate network delay for testing (remove in production)
      await Future.delayed(const Duration(seconds: 1));

      final submission = await _localStorage.createSubmission(
        questionnaireId: currentQuestionnaire.value!.id,
        questionnaireTitle: currentQuestionnaire.value!.title,
        userEmail: userEmail,
        answers: Map.from(selectedAnswers),
      );

      // Save offline first
      await _localStorage.saveSubmission(submission);

      // Try to sync with mock API (optional)
      // await _apiService.submitResponse(submission);

      // Clear answers
      selectedAnswers.clear();
      selectedAnswers.refresh();
      currentQuestionIndex.value = 0;

      // Close the questionnaire screen first
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close any open dialog
      }

      // Navigate back to home screen
      Get.offAllNamed('/home'); // Make sure this matches your home route

      // Show success message after navigation
      Get.snackbar(
        'Success',
        'Questionnaire submitted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );

    } catch (e) {
      print('Submission error: $e');
      Get.snackbar(
        'Error',
        'Failed to submit answers. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void clearSelection() {
    selectedAnswers.clear();
    selectedAnswers.refresh();
    currentQuestionIndex.value = 0;
    update();
  }

  String getAnswerForQuestion(String questionId) {
    return selectedAnswers[questionId] ?? '';
  }
}