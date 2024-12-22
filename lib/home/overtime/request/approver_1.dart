import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../components/primary_container.dart';
import '../../../components/text_style.dart';

class Approver1 extends StatefulWidget {
  const Approver1({super.key});

  @override
  State<Approver1> createState() => Approver1State();
}

class Approver1State extends State<Approver1> {
  List<Map<String, dynamic>> _approvers1 = [];
  String? _selectedApprover1;

  String? get selectedApprover => _selectedApprover1;

  @override
  void initState() {
    super.initState();
    _fetchApprovers();
  }

  Future<void> _fetchApprovers() async {
    const String apiUrl = "https://jt-hcm.simise.id/api/getApprover/overtime";
    const Map<String, String> headers = {
      "Content-Type": "application/json",
      'api-key': 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData.containsKey('data') && jsonData['data'] is List) {
          setState(() {
            _approvers1 = (jsonData['data'] as List)
                .map((item) => {'id': item['id'], 'name': item['name']})
                .toList();
          });
        } else {
          throw Exception('Data field is missing or not a list');
        }
      } else {
        throw Exception(
            'Failed to load approvers (status: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  void reset() {
    setState(() {
      _selectedApprover1 = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      width: MediaQuery.of(context).size.width,
      borderRadius: BorderRadius.circular(0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Approver 1', style: AppTextStyles.heading2_1),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.primaryContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintStyle: AppTextStyles.heading2,
              ),
              hint: const Text('Select Approver'),
              value: _selectedApprover1,
              items: _approvers1
                  .map((approver) => DropdownMenuItem<String>(
                        value: approver['id'].toString(),
                        child: Text(approver['name'],
                            style: AppTextStyles.heading2_1),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedApprover1 = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
