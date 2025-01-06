import 'package:flutter/material.dart';
import 'package:hcm_3/service/api_config.dart';
import '../../../custom_loading.dart';
import '/components/primary_container.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/text_style.dart';
import 'package:intl/intl.dart';
import 'detail_dialog.dart'; // Tambahkan impor file modal dialog

class PageHistory extends StatefulWidget {
  const PageHistory({super.key});

  @override
  State<PageHistory> createState() => _PageHistoryState();
}

class _PageHistoryState extends State<PageHistory> {
  List<Map<String, dynamic>> _historyData = [];
  bool _isLoading = true;
  bool _hasError = false;
  int? _employeeId;

  @override
  void initState() {
    super.initState();
    _loadEmployeeId();
  }

  Future<void> _loadEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _employeeId = prefs.getInt('employee_id');
    });
    if (_employeeId != null) {
      _fetchHistoryData();
    } else {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _fetchHistoryData() async {
    final String apiUrl = ApiEndpoints.fetchHistoryData4(_employeeId);
    const Map<String, String> headers = {
      'Content-Type': 'application/json',
      'api-key': ApiConfig.apiKey
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> data = jsonData['data'];
          setState(() {
            _historyData = data.map((item) {
              return {
                'reason':
                    item['reason_id'] != null && item['reason_id'].isNotEmpty
                        ? item['reason_id'][0]['name']
                        : 'Unknown Reason',
                'rule': item['rule_id'] != null && item['rule_id'].isNotEmpty
                    ? item['rule_id'][0]['name']
                    : 'Unknown Reason',
                'date': _formatDateRange(item['req_start'], item['req_end']),
                'createDate': _formatDate(item['create_date'] ?? 'unknown'),
                'state': item['state'] ?? 'unknown',
              };
            }).toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _historyData = [];
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  String _formatDateRange(String start, String end) {
    final DateTime startDate = DateTime.parse("${start}Z").toUtc().toLocal();
    final DateTime endDate = DateTime.parse("${end}Z").toUtc().toLocal();
    final String formattedStart =
        "${DateFormat('yyyy-MM-dd').format(startDate)} : ${DateFormat('HH.mm').format(startDate)}";
    final String formattedEnd =
        "${DateFormat('yyyy-MM-dd').format(endDate)} : ${DateFormat('HH.mm').format(endDate)}";

    return "$formattedStart → $formattedEnd";
  }

  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse("${date}Z").toUtc().toLocal();
      return "${DateFormat('yyyy-MM-dd').format(parsedDate)} : ${DateFormat('HH.mm').format(parsedDate)}";
    } catch (e) {
      return 'Invalid Date';
    }
  }

  void _showDetailModal(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => DetailDialog(data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: _isLoading
          ? const Center(child: CustomLoading(imagePath: 'assets/3.png'))
          : _hasError
              ? const Center(child: Text('Failed to load data.'))
              : _historyData.isEmpty
                  ? const Center(child: Text('No data available to display.'))
                  : SingleChildScrollView(
                      child: Column(
                        children: _historyData
                            .map(
                              (data) => GestureDetector(
                                onTap: () => _showDetailModal(data),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: PrimaryContainer(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  data['reason'] ??
                                                      'Unknown Reason',
                                                  style:
                                                      AppTextStyles.heading2_1),
                                              Text(data['date'] ?? '',
                                                  style:
                                                      AppTextStyles.heading3_3),
                                            ],
                                          ),
                                          Image.asset(
                                            data['state'] == 'approved'
                                                ? 'assets/image_done.png'
                                                : 'assets/resign_check.png',
                                            width: 40.0,
                                            height: 40.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
    );
  }
}
