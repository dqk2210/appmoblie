import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/colors.dart';
import '../../core/utils/currency_format.dart';
import '../transactions/add_transaction_screen.dart';
import '../statistics/statistics_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Đăng ký Controller vào GetX Pipeline
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () {
              Get.to(() => const StatisticsScreen());
            },
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.fetchData, // Vuốt xuống để load lại trang
          child: Column(
            children: [
              _buildDashboardCard(controller),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Giao dịch gần đây',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(child: _buildTransactionList(controller)),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddTransactionScreen());
        },
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDashboardCard(HomeController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Tổng số dư',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormat.formatVND(controller.totalBalance.value),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIncomeExpenseItem(
                'Tổng thu',
                controller.totalIncome.value,
                Icons.arrow_downward,
                Colors.greenAccent,
              ),
              _buildIncomeExpenseItem(
                'Tổng chi',
                controller.totalExpense.value,
                Icons.arrow_upward,
                Colors.orangeAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseItem(String title, double amount, IconData icon, Color iconColor) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white24,
          radius: 16,
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            Text(
              CurrencyFormat.formatVND(amount),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionList(HomeController controller) {
    if (controller.transactions.isEmpty) {
      return const Center(child: Text('Chưa có giao dịch nào!'));
    }

    return ListView.builder(
      itemCount: controller.transactions.length,
      itemBuilder: (context, index) {
        final t = controller.transactions[index];
        final isIncome = t.categoryType == 'INCOME';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isIncome ? AppColors.income.withOpacity(0.2) : AppColors.expense.withOpacity(0.2),
              child: Icon(
                isIncome ? Icons.account_balance_wallet : Icons.shopping_cart,
                color: isIncome ? AppColors.income : AppColors.expense,
              ),
            ),
            title: Text(t.title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('\${t.categoryName} • \${CurrencyFormat.formatDate(t.transactionDate ?? '')}'),
            trailing: Text(
              '\${isIncome ? '+' : '-'}\${CurrencyFormat.formatVND(t.amount ?? 0)}',
              style: TextStyle(
                color: isIncome ? AppColors.income : AppColors.expense,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}
