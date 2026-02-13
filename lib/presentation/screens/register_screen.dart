import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Get.find with tag or ensure unique instance
    final authController = Get.find<AuthController>();

    // Reset form key when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.registerFormKey.currentState?.reset();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            authController.clearFields();
            Get.offNamed('/login');
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Header
              Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 15,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 25,
                      left: 25,
                      child: Icon(
                        Icons.person_add,
                        size: 30,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign up to get started',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Registration Form - Using unique key from controller
              Form(
                key: authController.registerFormKey,
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
                        textInputAction: TextInputAction.next,
                      )),
                    ),
                    const SizedBox(height: 16),
                    // Confirm Password Field
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
                        controller: authController.confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Confirm your password',
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.blue.shade700),
                          suffixIcon: IconButton(
                            icon: Icon(
                              authController.obscureConfirmPassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: authController.toggleConfirmPasswordVisibility,
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
                        validator: (value) => Validators.validateConfirmPassword(
                          value,
                          authController.passwordController.text,
                        ),
                        obscureText: authController.obscureConfirmPassword.value,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => authController.register(),
                      )),
                    ),
                    const SizedBox(height: 16),
                    // Password Requirements
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password Requirements:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildRequirement('At least 6 characters'),
                          _buildRequirement('At least one letter'),
                          _buildRequirement('At least one number'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Register Button
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : authController.register,
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
                          'Register',
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
              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      authController.clearFields();
                      Get.offNamed('/login');
                    },
                    child: Text(
                      'Login',
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

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.green.shade700,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}