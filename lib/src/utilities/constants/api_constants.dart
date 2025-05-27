class ApiConstants {
  static const String baseUrl = 'http://192.168.1.15:6000/api'; // Base URL
  static const String authEndpoint = '$baseUrl/auth'; // Full endpoint for auth
  static const String userEndpoint =
      '$baseUrl/users'; // Full endpoint for users
  static const String profileEndpoint =
      '$userEndpoint/all-users'; // Updated Profile endpoint
}
