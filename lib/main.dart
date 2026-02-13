import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:questionnaire_app/presentation/screens/login_screen.dart';
import 'package:questionnaire_app/presentation/screens/register_screen.dart';
import 'package:questionnaire_app/presentation/screens/splash_screen.dart';

import 'presentation/screens/home_screen.dart';
import 'presentation/screens/questionnaire_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/questionnaire_controller.dart';
import 'data/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Database
  try {
    final databaseService = DatabaseService();
    await databaseService.database;
  } catch (e) {
    print('Database initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Questionnaire App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade700),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: Colors.blue.shade700,
        ),
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController(), permanent: true);
        Get.put(QuestionnaireController(), permanent: true);
      }),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/questionnaire', page: () => const QuestionnaireScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
      ],
    );
  }
}