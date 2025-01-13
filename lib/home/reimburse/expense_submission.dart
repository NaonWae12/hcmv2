// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/api_config.dart';
import 'dialog_utils.dart';

class ExpenseSubmission {
  final BuildContext context;

  ExpenseSubmission(this.context);

  Future<int?> _getEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    final employeeId = prefs.getInt('employee_id');
    print(
        'Employee ID from SharedPreferences: $employeeId'); // Tambahkan log ini
    return employeeId;
  }

  /// Fungsi utama untuk menambahkan Expense, membuat Report, dan langsung Submit
  Future<void> addExpenseAndSubmit({
    required String description,
    required int productId,
    required int totalAmount,
    required String date,
    VoidCallback? onSuccess, // Tambahkan parameter callback
  }) async {
    final employeeId = await _getEmployeeId();
    if (employeeId == null) {
      DialogUtils.showErrorDialog(context, 'Employee ID not found.');
      return;
    }

    final success = await _submitExpense(
      description: description,
      productId: productId,
      totalAmount: totalAmount,
      date: date,
      employeeId: employeeId,
    );

    if (!success) {
      DialogUtils.showErrorDialog(context, 'Failed to create expense.');
      return;
    }

    final expenseId = await _fetchExpenseId(employeeId);
    if (expenseId == null) {
      DialogUtils.showErrorDialog(context, 'Failed to fetch expense ID.');
      return;
    }

    final reportSuccess = await _createReportAndSubmit(expenseId);
    if (reportSuccess) {
      DialogUtils.showSuccessDialog(context, 'Expense submitted successfully.');
      onSuccess?.call(); // Panggil callback di sini
    } else {
      DialogUtils.showErrorDialog(context, 'Failed to submit expense.');
    }
  }

  /// Fungsi untuk membuat Expense
  Future<bool> _submitExpense({
    required String description,
    required int productId,
    required int totalAmount,
    required String date,
    required int employeeId,
  }) async {
    final body = {
      "name": description,
      "product_id": productId,
      "total_amount_currency": totalAmount,
      "employee_id": employeeId,
      "payment_mode": "own_account",
      "date": date,
    };

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.submitRequest()),
        headers: {
          'Content-Type': 'application/json',
          'api-key': ApiConfig.apiKey,
        },
        body: json.encode(body),
      );
      // print('Response body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error creating expense: $e');
      return false;
    }
  }

  /// Fungsi untuk mengambil Expense ID berdasarkan Employee ID
  Future<int?> _fetchExpenseId(int employeeId) async {
    print('emplye id untuk buat expense: $employeeId');
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.fetchExpenseData5(employeeId)),
        headers: {
          'Content-Type': 'application/json',
          'api-key': ApiConfig.apiKey,
        },
      );

      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        // print('Fetched Expense Data: $jsonResponse');

        // Mengambil data dari array 'data'
        final data = jsonResponse['data'];

        // Cek apakah array 'data' tidak kosong dan memiliki id
        if (data != null && data.isNotEmpty) {
          final expenseId = data[0]['id']; // Mengambil 'id' dari objek pertama
          // print('Expense ID found: $expenseId');
          return expenseId;
        } else {
          print('No expense data found.');
        }
      } else {
        print('Failed to fetch data with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching expense ID: $e');
    }
    return null;
  }

  /// Fungsi untuk membuat Report dan langsung Submit
  Future<bool> _createReportAndSubmit(int expenseId) async {
    final createReportSuccess = await _createReport(expenseId);
    if (!createReportSuccess) return false;

    return await _submitReport(expenseId);
  }

  /// Fungsi untuk membuat Report
  Future<bool> _createReport(int expenseId) async {
    final body = {
      "method": "action_submit_expenses",
      "args": [
        [expenseId]
      ],
      "kw": {}
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/hr.expense/execute_kw'),
        headers: {
          'Content-Type': 'application/json',
          'api-key': ApiConfig.apiKey,
        },
        body: jsonEncode(body),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error creating report: $e');
      return false;
    }
  }

  /// Fungsi untuk Submit Report

  Future<bool> _submitReport(int employeeId) async {
    // Ambil expenseId dari API menggunakan _employeeId
    final expenseId = await _fetchExpenseIdForReport();
    if (expenseId == null) {
      print('Failed to fetch expense ID for report.');
      return false;
    }

    final body = {
      "method": "action_submit_sheet",
      "args": [
        [expenseId]
      ],
      "kw": {}
    };

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.submitData2()),
        headers: {
          'Content-Type': 'application/json',
          'api-key': ApiConfig.apiKey,
        },
        body: jsonEncode(body),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error submitting report: $e');
      return false;
    }
  }

  /// Fungsi untuk mengambil Expense ID untuk Report berdasarkan Employee ID
  Future<int?> _fetchExpenseIdForReport() async {
    // Ambil employeeId dari SharedPreferences
    final employeeId = await _getEmployeeId();

    // Validasi apakah employeeId berhasil diperoleh
    if (employeeId == null) {
      print('Failed to retrieve employee ID from SharedPreferences.');
      return null;
    }

    print('Employee id untuk ngambil id expense : $employeeId');
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.fetchExpenseData4(employeeId)),
        headers: {
          'Content-Type': 'application/json',
          'api-key': ApiConfig.apiKey,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Memastikan response berhasil dan ada data
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> data = jsonData['data'];

          // Cari data yang sesuai dengan employeeId
          final employeeExpenseData = data.firstWhere(
            (item) => item['employee_id'][0]['id'] == employeeId,
            orElse: () => null,
          );

          if (employeeExpenseData != null) {
            final expenseId = employeeExpenseData[
                'id']; // Mengambil 'id' dari data yang sesuai
            print('Expense ID found for employee $employeeId: $expenseId');
            return expenseId;
          } else {
            print('No expense data found for employee with ID: $employeeId');
          }
        } else {
          print('API response not successful or data is null.');
        }
      } else {
        print('Failed to fetch data with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching expense ID for report: $e');
    }
    return null;
  }
}
