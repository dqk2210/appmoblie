import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

import '../../core/constants/colors.dart';
import '../../core/utils/currency_format.dart';
import 'statistics_controller.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StatisticsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo Cáo Thống Kê'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.pieChartData.isEmpty) {
          return const Center(child: Text('Chưa có dữ liệu chi tiêu nào!'));
        }

        return Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'Cơ cấu chi tiêu',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 50,
                  sections: controller.pieChartData.entries.map((entry) {
                    return PieChartSectionData(
                      color: controller.getColorForCategory(entry.key),
                      value: entry.value,
                      title:
                          '\${((entry.value / controller.pieChartData.values.reduce((a, b) => a + b)) * 100).toStringAsFixed(1)}%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: controller.pieChartData.entries.map((entry) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: controller.getColorForCategory(
                        entry.key,
                      ),
                      radius: 12,
                    ),
                    title: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      CurrencyFormat.formatVND(entry.value),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }),
    );
  }
}
