import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hcm_3/service/api_config.dart';
import '../../../../components/text_style.dart';
import '/components/primary_container.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dialog_modal_submit_ovt.dart';

class ContentSubmitOvt extends StatefulWidget {
  final Function(int id) onSelectId;

  const ContentSubmitOvt({super.key, required this.onSelectId});

  @override
  State<ContentSubmitOvt> createState() => _ContentSubmitOvtState();
}

class _ContentSubmitOvtState extends State<ContentSubmitOvt> {
  List<Map<String, dynamic>> _historyData = [];
  bool _isLoading = true;
  bool _hasError = false;
  int? _employeeId;
  int? _selectedId;

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
    final String apiUrl = ApiEndpoints.fetchHistoryData3(_employeeId);
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
                'id': item['id'], // ID untuk seleksi
                'reason':
                    item['reason_id'] != null && item['reason_id'].isNotEmpty
                        ? item['reason_id'][0]['name']
                        : 'Unknown Reason',
                'rule': item['rule_id'] != null && item['rule_id'].isNotEmpty
                    ? item['rule_id'][0]['name']
                    : 'Unknown Rule',
                'date': _formatDateRange(item['req_start'], item['req_end']),
                'create_date': _formatDate(item['create_date'] ?? 'unknown'),
                'state': item['state'] ?? 'unknown',
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

  void _showDetailModal(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => DialogModalSubmitOvt(data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
                                        widget.onSelectId(_selectedId!);
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
                                                Text(
                                                  data['reason'],
                                                  style:
                                                      AppTextStyles.heading2_1,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  child: Text(
                                                    data['date'],
                                                    style: AppTextStyles
                                                        .heading3_3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
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
