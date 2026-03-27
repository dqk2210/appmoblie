import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  ApiService() {
    // Để tiện debug lỗi API sau này ném thẳng vào log
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, handler) {
        debugPrint('API Error: ${e.message}');
        // Hiển thị thông báo Snackbar
        Get.snackbar(
          'Lỗi kết nối',
          e.response?.data['message'] ?? 'Không thể kết nối đến máy chủ',
          snackPosition: SnackPosition.BOTTOM,
        );
        return handler.next(e);
      },
    ));
  }

  // ============== CATEGORIES ==============

  Future<List<CategoryModel>> getCategories({String? type}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.categories,
        queryParameters: type != null ? {'type': type} : null,
      );
      if (response.data['success'] == true) {
        List data = response.data['data'];
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> createCategory({required String name, required String type}) async {
    try {
      final response = await _dio.post(ApiEndpoints.categories, data: {
        'name': name,
        'type': type,
      });
      return response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    try {
      final response = await _dio.delete('${ApiEndpoints.categories}/$id');
      return response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  // ============== TRANSACTIONS ==============

  Future<List<TransactionModel>> getTransactions({int? month, int? year}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (month != null) queryParams['month'] = month;
      if (year != null) queryParams['year'] = year;

      final response = await _dio.get(
        ApiEndpoints.transactions,
        queryParameters: queryParams,
      );
      if (response.data['success'] == true) {
        List data = response.data['data'];
        return data.map((json) => TransactionModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> createTransaction({
    required String title,
    required double amount,
    required int categoryId,
    required String transactionDate,
    String? note,
  }) async {
    try {
      final response = await _dio.post(ApiEndpoints.transactions, data: {
        'title': title,
        'amount': amount,
        'category_id': categoryId,
        'transaction_date': transactionDate,
        'note': note,
      });
      return response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteTransaction(int id) async {
    try {
      final response = await _dio.delete('${ApiEndpoints.transactions}/$id');
      return response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
