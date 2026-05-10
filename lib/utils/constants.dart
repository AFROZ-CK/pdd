/// App-wide constants for DataMind

class AppConstants {
  // App info
  static const String appName = 'DataMind';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Intelligent Predictive Analytics Platform';
  static const String projectTitle =
      'Design and Development of DataMind: An Intelligent Predictive Analytics Platform '
      'for Bridging Data Gaps and Enabling Real-Time Decision-Making';

  // API
  static const String defaultApiEndpoint = 'https://api.datamind.ai/v1';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Pagination
  static const int pageSize = 20;

  // Chart colors (hex strings)
  static const List<String> chartColorHex = [
    '#6C63FF',
    '#00D4FF',
    '#00E676',
    '#FFAB00',
    '#FF5252',
    '#448AFF',
    '#9C27B0',
    '#FF6D00',
  ];

  // Model list
  static const List<String> mlModels = [
    'Linear Regression',
    'Random Forest',
    'XGBoost',
    'Neural Network',
    'LSTM (Time Series)',
    'K-Means Clustering',
    'ARIMA',
    'Prophet',
  ];

  // User roles
  static const List<String> userRoles = [
    'Data Scientist',
    'Data Analyst',
    'Business Analyst',
    'ML Engineer',
    'Data Engineer',
    'Product Manager',
  ];

  // Prefs keys
  static const String prefIsLoggedIn = 'isLoggedIn';
  static const String prefIsDark = 'isDark';
  static const String prefUserId = 'userId';
  static const String prefUserName = 'userName';
  static const String prefUserEmail = 'userEmail';
  static const String prefUserRole = 'userRole';
  static const String prefApiEndpoint = 'apiEndpoint';
  static const String prefRefreshInterval = 'refreshInterval';

  // Refresh intervals
  static const List<String> refreshIntervals = [
    '1 minute',
    '5 minutes',
    '15 minutes',
    '30 minutes',
    '1 hour',
  ];
}
