import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    Future.delayed(const Duration(seconds: 2), () {
      if (authController.isLoggedIn.value) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade600,
              Colors.blue.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.assignment_turned_in,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              // App Name
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Column(
                      children: [
                        Text(
                          'Questionnaire',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'App',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 48),
              // Loading Indicator
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}