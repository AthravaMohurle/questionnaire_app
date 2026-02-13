import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Get.find with tag or ensure unique instance
    final authController = Get.find<AuthController>();

    // Reset form key when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.loginFormKey.currentState?.reset();
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Logo and Header
              Container(
                height: 120,
                width: 120,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 30,
                      left: 30,
                      child: Icon(
                        Icons.assignment_ind,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Login to continue',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Login Form - Using unique key from controller
              Form(
                key: authController.loginFormKey,
                child: Column(
                  children: [
                    // Email Field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: authController.emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.blue.shade700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Password Field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Obx(() => TextFormField(
                        controller: authController.passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.blue.shade700),
                          suffixIcon: IconButton(
                            icon: Icon(
                              authController.obscurePassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: authController.togglePasswordVisibility,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        validator: Validators.validatePassword,
                        obscureText: authController.obscurePassword.value,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => authController.login(),
                      )),
                    ),
                    const SizedBox(height: 16),
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.snackbar(
                            'Info',
                            'Please contact support to reset your password',
                            backgroundColor: Colors.blue.shade100,
                            colorText: Colors.blue.shade900,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Login Button
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : authController.login,
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: authController.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Clear any existing data before navigating
                      authController.clearFields();
                      Get.toNamed('/register');
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}