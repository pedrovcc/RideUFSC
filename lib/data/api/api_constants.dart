class ApiConstants {
  static const _baseUrl = 'https://api-staging.jungle.rocks';
  // Login -> email: " dev@jungledevs.com ", password: " developer123"
  static String login() {
    return '$_baseUrl/api/v1/login/';
  }

  static List<String> errorIds = ['non_field_errors'];
}
