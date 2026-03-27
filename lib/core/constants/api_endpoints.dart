class ApiEndpoints {
  // Máy ảo Android dùng 10.0.2.2 để gọi tới Web Server localhost
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static const String categories = '$baseUrl/categories';
  static const String transactions = '$baseUrl/transactions';
}
