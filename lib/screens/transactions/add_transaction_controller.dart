import 'package:get/get.dart';
import '../../data/services/api_service.dart';
import '../../data/models/category_model.dart';
import '../dashboard/home_controller.dart';
import 'package:intl/intl.dart';

class AddTransactionController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var categories = <CategoryModel>[].obs;
  
  // Dữ liệu Form
  var selectedCategory = Rxn<CategoryModel>();
  var amount = ''.obs;
  var note = ''.obs;
  var title = ''.obs;
  var transactionDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    // Lấy danh sách Categories từ API hoặc copy từ HomeController nếu có sẵn
    if (Get.isRegistered<HomeController>()) {
      categories.value = Get.find<HomeController>().categories;
    } else {
      _loadCategories();
    }
  }

  Future<void> _loadCategories() async {
    categories.value = await _apiService.getCategories();
  }

  Future<void> submitTransaction() async {
    if (title.value.isEmpty || amount.value.isEmpty || selectedCategory.value == null) {
      Get.snackbar('Lỗi', 'Vui lòng nhập đầy đủ Số tiền, Tiêu đề và chọn Danh mục!');
      return;
    }

    double? parsedAmount = double.tryParse(amount.value.replaceAll(',', ''));
    if (parsedAmount == null || parsedAmount <= 0) {
      Get.snackbar('Lỗi', 'Số tiền phải là số hợp lệ lớn hơn 0!');
      return;
    }

    isLoading(true);
    // Format ngày chuẩn YYYY-MM-DD gửi lên MYSQL
    String formattedDate = DateFormat('yyyy-MM-dd').format(transactionDate.value);

    bool success = await _apiService.createTransaction(
      title: title.value,
      amount: parsedAmount,
      categoryId: selectedCategory.value!.id!,
      transactionDate: formattedDate,
      note: note.value,
    );

    isLoading(false);

    if (success) {
      Get.back(); // Đóng form
      Get.snackbar('Thành công', 'Đã lưu giao dịch!');
      
      // Gọi HomeController load lại data để lấy List mới
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchData();
      }
    } else {
      Get.snackbar('Thất bại', 'Không thể lưu giao dịch. Vui lòng thử lại.');
    }
  }
}
