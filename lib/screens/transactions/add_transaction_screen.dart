import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/constants/colors.dart';
import '../../data/models/category_model.dart';
import 'add_transaction_controller.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddTransactionController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Giao Dịch'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Loại Giao dịch (Dropdown)
              const Text('Danh mục', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CategoryModel>(
                    isExpanded: true,
                    hint: const Text('Chọn một danh mục'),
                    value: controller.selectedCategory.value,
                    items: controller.categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text('${cat.name} (${cat.type == "INCOME" ? "Thu" : "Chi"})'),
                      );
                    }).toList(),
                    onChanged: (cat) {
                      controller.selectedCategory.value = cat;
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _showAddCategoryDialog(context, controller),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Thêm danh mục mới'),
                ),
              ),
              const SizedBox(height: 8),

              // Title
              const Text('Tiêu đề', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Ví dụ: Ăn trưa phở Cồ',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => controller.title.value = value,
              ),
              const SizedBox(height: 16),

              // Số tiền
              const Text('Số tiền (VNĐ)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Ví dụ: 50000',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => controller.amount.value = value,
              ),
              const SizedBox(height: 16),

              // Ngày tháng
              const Text('Ngày giao dịch', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: controller.transactionDate.value,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    controller.transactionDate.value = pickedDate;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(controller.transactionDate.value),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Ghi chú
              const Text('Ghi chú (Tùy chọn)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Chi tiết thêm về khoản này...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => controller.note.value = value,
              ),
              const SizedBox(height: 32),

              // Nút Submit
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                     // Ẩn keyboard
                     FocusScope.of(context).unfocus();
                     controller.submitTransaction();
                  },
                  child: const Text('Lưu Giao Dịch', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showAddCategoryDialog(BuildContext context, AddTransactionController controller) {
    final TextEditingController nameController = TextEditingController();
    String selectedType = 'EXPENSE';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Thêm Danh mục Mới'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Tên danh mục'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: const InputDecoration(labelText: 'Loại (Thu/Chi)'),
                    items: const [
                      DropdownMenuItem(value: 'EXPENSE', child: Text('Chi tiêu (EXPENSE)')),
                      DropdownMenuItem(value: 'INCOME', child: Text('Thu nhập (INCOME)')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        if (val != null) selectedType = val;
                      });
                    },
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    controller.addCategory(nameController.text, selectedType);
                  },
                  child: const Text('Thêm'),
                ),
              ],
            );
          }
        );
      },
    );
  }
}
