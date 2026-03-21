import 'package:get/get.dart';
import '../../data/services/api_service.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/category_model.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();

  // Dữ liệu dùng .obs để UI tự động update khi giá trị thay đổi
  var isLoading = true.obs;
  var transactions = <TransactionModel>[].obs;
  var categories = <CategoryModel>[].obs;

  var totalBalance = 0.0.obs;
  var totalIncome = 0.0.obs;
  var totalExpense = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData(); // Vừa vào Home là gọi hàm lấy cục DB liền
  }

  Future<void> fetchData() async {
    isLoading(true);
    
    // Gọi API Node.js
    final catList = await _apiService.getCategories();
    final transList = await _apiService.getTransactions();

    categories.value = catList;
    transactions.value = transList;

    _calculateTotals();
    isLoading(false);
  }

  void _calculateTotals() {
    double income = 0;
    double expense = 0;

    for (var t in transactions) {
      if (t.categoryType == 'INCOME') {
        income += t.amount ?? 0;
      } else {
        expense += t.amount ?? 0;
      }
    }

    totalIncome.value = income;
    totalExpense.value = expense;
    totalBalance.value = income - expense;
  }
}
