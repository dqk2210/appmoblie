class ApiEndpoints {
  // Thay đổi IP này thành IP LAN của máy nếu bạn cắm Device thật test API (Vd: 192.168.1.x)
  // Máy ảo Android dùng 10.0.2.2 để gọi tới Web Server localhost
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static const String categories = '/categories';
  static const String transactions = '/transactions';
}
