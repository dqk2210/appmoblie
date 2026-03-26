import 'package:get/get.dart';
import '../../data/services/api_service.dart';
import '../dashboard/home_screen.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập đầy đủ thông tin");
      return;
    }

    isLoading(true);
    final result = await _apiService.login(username, password);
    isLoading(false);

    if (result['message'] == "Đăng nhập thành công!") {
      Get.offAll(
        () => const HomeScreen(),
      ); // Đăng nhập xong thì xóa lịch sử trang cũ, vào Home luôn
    } else {
      Get.snackbar("Thất bại", result['message'] ?? "Sai tài khoản");
    }
  }
}
