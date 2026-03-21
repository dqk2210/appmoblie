import 'package:get/get.dart';
import '../../data/models/transaction_model.dart';
import '../dashboard/home_controller.dart';
import 'package:flutter/material.dart';

class StatisticsController extends GetxController {
  var pieChartData = <String, double>{}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    generateChartData();
  }

  void generateChartData() {
    // Lấy dữ liệu giao dịch từ HomeController đã fetch sẵn để tái sử dụng
    if (!Get.isRegistered<HomeController>()) {
      return;
    }
    
    List<TransactionModel> rawTransactions = Get.find<HomeController>().transactions;
    Map<String, double> groupedData = {};

    // Chỉ tính các khoản CHI TIÊU (EXPENSE) để vẽ biểu đồ tròn
    for (var t in rawTransactions) {
      if (t.categoryType == 'EXPENSE') {
        String categoryName = t.categoryName ?? 'Khác';
        if (groupedData.containsKey(categoryName)) {
          groupedData[categoryName] = groupedData[categoryName]! + (t.amount ?? 0);
        } else {
          groupedData[categoryName] = t.amount ?? 0;
        }
      }
    }

    pieChartData.value = groupedData;
    isLoading(false);
  }

  // Tiện ích lấy màu sắc ngẫu nhiên hoặc cố định cho từng section
  Color getColorForCategory(String title) {
    switch (title) {
      case 'Ăn uống':
        return Colors.orange;
      case 'Mua sắm':
        return Colors.blue;
      case 'Di chuyển':
        return Colors.purple;
      case 'Hóa đơn':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
