/// Application-wide constants
///
/// This file contains all the constant values used throughout the application
/// including API endpoints, configuration values, and other static data.
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // API Configuration
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey =
      'YOUR_NEWS_API_KEY'; // Replace with actual API key

  // Agora Configuration
  static const String agoraAppId =
      '28a1636492f647bf839ba6aff58e92c5'; // Agora App ID
  static const String agoraAppCertificate =
      '113764fe95e04502b1ad6a43cd231699'; // Agora App Certificate
  static const String agoraToken =
      'YOUR_AGORA_TOKEN'; // Replace with actual token
  static const String agoraTempToken =
      'YOUR_VALID_TEMP_TOKEN'; // Replace with actual temp token for testing

  // App Configuration
  static const String appName = 'Fusion News';
  static const String appVersion = '1.0.0';

  // Network Configuration
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Configuration
  static const int cacheExpirationMinutes = 30;

  // Live Stream Configuration
  static const String defaultChannelName = 'fusion_news_live';
  static const int defaultUid = 0;

  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
