import 'package:flutter/material.dart';
import 'package:hcm_3/service/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../components/primary_container.dart';
import '../../../components/text_style.dart';
import '../../../custom_loading.dart';
import 'klik_detail_payslip.dart';

class ContentHistory extends StatefulWidget {
  const ContentHistory({super.key});

  @override
  State<ContentHistory> createState() => _ContentHistoryState();
}

class _ContentHistoryState extends State<ContentHistory> {
  List<dynamic> _slipData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPayslipData();
  }

  Future<void> _fetchPayslipData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final employeeId = prefs.getInt('employee_id') ?? 0;

      if (employeeId == 0) {
        throw Exception("Employee ID tidak ditemukan.");
      }

      // Encode domain as JSON
      final domain = Uri.encodeComponent(json.encode([
        ['employee_id', '=', employeeId]
      ]));
      final url = ApiEndpoints.fetchPayslipData(domain);
      final headers = {
        'Content-Type': 'application/json',
        'api-key': ApiConfig.apiKey
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          setState(() {
            _slipData = responseData['data'];
            _isLoading = false;
          });
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception("Gagal mengambil data dari server.");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("Error: ${e.toString()}"),
      // ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? const CustomLoading(imagePath: 'assets/3.png')
          : _slipData.isEmpty
              ? Text(
                  "Tidak ada data slip gaji tersedia.",
                  style: AppTextStyles.heading2,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _slipData.length,
                  itemBuilder: (context, index) {
                    final slip = _slipData[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to KlikDetailPayslip and pass data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KlikDetailPayslip(
                                slipData: slip,
                              ),
                            ),
                          );
                        },
                        child: PrimaryContainer(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  slip['name'] ?? "Nama Slip Tidak Diketahui",
                                  style: AppTextStyles.heading2,
                                ),
                                Text(
                                  slip['payslip_date'] ??
                                      "Tanggal Tidak Tersedia",
                                  style: AppTextStyles.heading3_1,
                                ),
                                Text(
                                  slip['number'] ?? "Nomor Slip Tidak Tersedia",
                                  style: AppTextStyles.heading3_1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
