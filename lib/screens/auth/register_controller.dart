import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/api_service.dart';

class RegisterController extends GetxController {
  final ApiService _apiService = ApiService();
  var isLoading = false.obs;

  Future<void> register(
    String username,
    String email,
    String password,
    String confirmPass,
  ) async {
    // 1. Kiểm tra rỗng
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Lỗi",
        "Vui lòng nhập đầy đủ thông tin",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 2. Kiểm tra khớp mật khẩu
    if (password != confirmPass) {
      Get.snackbar(
        "Lỗi",
        "Mật khẩu nhập lại không khớp",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      // Gọi sang ApiService
      final result = await _apiService.register(username, password, email);

      if (result['success']) {
        Get.snackbar(
          "Thành công",
          "Đăng ký tài khoản thành công!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offNamed('/login'); // Đăng ký xong thì quay về trang đăng nhập
      } else {
        Get.snackbar(
          "Thất bại",
          result['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Lỗi",
        "Không thể kết nối đến máy chủ",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
