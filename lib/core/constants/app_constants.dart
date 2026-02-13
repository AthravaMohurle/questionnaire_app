class AppConstants {
  // Database Constants
  static const String databaseName = 'questionnaire_app.db';
  static const int databaseVersion = 1;

  // Table Names
  static const String usersTable = 'users';
  static const String submissionsTable = 'submissions';

  // Mock API Endpoints
  static const String baseUrl = 'https://698de6b0b79d1c928ed6f0ed.mockapi.io/api/v1';
  static const String registerEndpoint = '/users';
  static const String loginEndpoint = '/users';
  static const String questionnairesEndpoint = '/questionnaires';
  static const String submissionsEndpoint = '/submissions';

  // Session Keys
  static const String sessionTokenKey = 'session_token';
  static const String userEmailKey = 'user_email';

  // Shared Preferences Keys
  static const String isLoggedInKey = 'is_logged_in';

  // Error Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String locationError = 'Unable to get location. Please enable location services.';

  // Success Messages
  static const String registerSuccess = 'Registration successful! Please login.';
  static const String loginSuccess = 'Login successful!';
  static const String logoutSuccess = 'Logged out successfully';
  static const String submitSuccess = 'Questionnaire submitted successfully!';
}