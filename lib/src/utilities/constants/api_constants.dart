class ApiConstants {
  static const String baseUrl = 'http://192.168.139.98:7000/api'; // Base URL
  static const String authEndpoint = '$baseUrl/auth'; // Full endpoint for auth
  static const String userEndpoint =
      '$baseUrl/users'; // Full endpoint for users
  static const String profileEndpoint =
      '$userEndpoint/all-users'; // Updated Profile endpoint

  static const String postEndpoint =
      '$baseUrl/posts'; // Full endpoint for posts
}
