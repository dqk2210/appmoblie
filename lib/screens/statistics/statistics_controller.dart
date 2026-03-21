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

    // Tính tất cả các khoản Thu và Chi để vẽ dạng tóm tắt dòng tiền
    for (var t in rawTransactions) {
      double amount = t.amount ?? 0;
      if (amount > 0) {
        String categoryName = t.categoryName ?? 'Khác';
        String displayName = '$categoryName (${t.categoryType == 'INCOME' ? 'Thu' : 'Chi'})';
        
        if (groupedData.containsKey(displayName)) {
          groupedData[displayName] = groupedData[displayName]! + amount;
        } else {
           groupedData[displayName] = amount;
        }
      }
    }

    pieChartData.value = groupedData;
    isLoading(false);
  }

  // Tiện ích lấy màu sắc ngẫu nhiên hoặc cố định cho từng section
  Color getColorForCategory(String title) {
    if (title.contains('(Thu)')) return Colors.green; // Tô màu xanh cho mảng Thu
    if (title.contains('Ăn uống')) return Colors.orange;
    if (title.contains('Mua sắm')) return Colors.blue;
    if (title.contains('Di chuyển')) return Colors.purple;
    if (title.contains('Hóa đơn')) return Colors.redAccent;
    return Colors.grey;
  }
}
