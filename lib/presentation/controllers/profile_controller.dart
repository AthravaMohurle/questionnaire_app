import 'package:get/get.dart';
import '../../data/repositories/submission_model.dart';
import '../../data/services/local_storage_service.dart';

import 'auth_controller.dart';

class ProfileController extends GetxController {
  final LocalStorageService _localStorage = LocalStorageService();
  final AuthController _authController = Get.find<AuthController>();

  // Reactive Variables
  var submissions = <SubmissionModel>[].obs;
  var totalCount = 0.obs;
  var isLoading = false.obs;
  var expandedCard = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onReady() {
    super.onReady();
    loadUserData();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    try {
      final userEmail = _authController.currentUserEmail.value;
      if (userEmail.isNotEmpty) {
        final userSubmissions = await _localStorage.getUserSubmissions(userEmail);
        submissions.value = userSubmissions;
        totalCount.value = await _localStorage.getUserSubmissionCount(userEmail);
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadUserData();
  }

  void toggleExpanded(String id) {
    if (expandedCard.value == id) {
      expandedCard.value = null;
    } else {
      expandedCard.value = id;
    }
  }

  bool isExpanded(String id) {
    return expandedCard.value == id;
  }

  String formatDateTime(DateTime dateTime) {
    return _localStorage.formatDateTime(dateTime);
  }

  Map<String, String> getAnswersMap(String answersJson) {
    return _localStorage.parseAnswers(answersJson);
  }

  int getAnswerCount(String answersJson) {
    return getAnswersMap(answersJson).length;
  }

  String getLocationString(double? latitude, double? longitude) {
    if (latitude != null && longitude != null) {
      return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    }
    return 'Location not available';
  }
}