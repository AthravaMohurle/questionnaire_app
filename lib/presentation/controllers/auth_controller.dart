import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/mock_api_service.dart';
import '../../data/services/local_storage_service.dart';
import '../../core/utils/validators.dart';

class AuthController extends GetxController {
  final MockApiService _apiService = MockApiService();
  final LocalStorageService _localStorage = LocalStorageService();

  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form Keys
  final registerFormKey = GlobalKey<FormState>();
  final loginFormKey = GlobalKey<FormState>();

  // Reactive Variables
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var currentUserEmail = ''.obs;
  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> checkLoginStatus() async {
    final session = await _localStorage.getUserSession();
    isLoggedIn.value = session['isLoggedIn'];
    currentUserEmail.value = session['userEmail'];
  }

  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.toggle();
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final user = await _apiService.register(
        emailController.text.trim(),
        passwordController.text,
      );

      if (user != null) {
        Get.snackbar(
          'Success',
          'Registration successful! Please login.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
        clearFields();
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Error',
          'Registration failed. Email might already exist.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final user = await _apiService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (user != null) {
        await _localStorage.saveUserSession(user.email, user.token ?? '');
        currentUserEmail.value = user.email;
        isLoggedIn.value = true;
        clearFields();
        Get.offAllNamed('/home');

        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      } else {
        Get.snackbar(
          'Error',
          'Invalid email or password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _localStorage.clearUserSession();
    isLoggedIn.value = false;
    currentUserEmail.value = '';
    Get.offAllNamed('/login');

    Get.snackbar(
      'Success',
      'Logged out successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}