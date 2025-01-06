// page_history.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../components/text_style.dart';
import '../../../../custom_loading.dart';
import '../../history_reimburse/detail_modal.dart';
import '/components/primary_container.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContentSubmitReport extends StatefulWidget {
  final Function(int id) onSelectId;

  const ContentSubmitReport({super.key, required this.onSelectId});

  @override
  State<ContentSubmitReport> createState() => _ContentSubmitReportState();
}

class _ContentSubmitReportState extends State<ContentSubmitReport> {
  List<Map<String, dynamic>> _historyData = [];
  bool _isLoading = true;
  bool _hasError = false;
  int? _employeeId;
  int? _selectedId; // Untuk menyimpan ID yang dipilih

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
    final String apiUrl =
        "https://jt-hcm.simise.id/api/hr.expense.sheet/search?domain=[('employee_id','=',$_employeeId),('state','=','draft')]";
    const Map<String, String> headers = {
      'Content-Type': 'application/json',
      'api-key': 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08',
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
                'id': item['id'], // Ambil ID dari data
                'name': item['name'] ?? 'Unknown Name',
                'state': item['state'] ?? 'unknown',
                'create_date': _formatDate(item['create_date']),
                'expense_line_ids': item['expense_line_ids'],
              };
            }).toList();
            _isLoading = false;
          });

          if (_historyData.isEmpty) {
            setState(() {
              _hasError = true;
            });
          }
        } else {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'Unknown Date';
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  void _showDetailModal(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => DetailModal(data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: _isLoading
          ? const Center(child: CustomLoading(imagePath: 'assets/3.png'))
          : _hasError
              ? const Center(child: Text('No data available.'))
              : SingleChildScrollView(
                  child: Column(
                    children: _historyData
                        .map(
                          (data) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _selectedId == data['id'],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        _selectedId = data['id'];
                                        widget.onSelectId(
                                            _selectedId!); // Kirim ID ke parent
                                      } else {
                                        _selectedId = null;
                                      }
                                    });
                                  },
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        _showDetailModal(context, data),
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
                                                Text(data['name'],
                                                    style: AppTextStyles
                                                        .heading2_1),
                                                Text(data['create_date'],
                                                    style: AppTextStyles
                                                        .heading3_3),
                                              ],
                                            ),
                                            SvgPicture.asset(
                                              data['state'] == 'done'
                                                  ? 'assets/icons/done.svg'
                                                  : 'assets/icons/doc_rev.svg',
                                              width: 48.0,
                                              height: 48.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
    );
  }
}
