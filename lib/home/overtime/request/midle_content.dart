import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../components/primary_container.dart';
import '../../../components/text_style.dart';

class MidleContent extends StatefulWidget {
  const MidleContent({super.key});

  @override
  State<MidleContent> createState() => MidleContentState();
}

class MidleContentState extends State<MidleContent> {
  List<Map<String, dynamic>> _reason = [];
  String? _selectedReason;

  String? get selectedReason => _selectedReason;

  @override
  void initState() {
    super.initState();
    _fetchOvertimeRules();
  }

  Future<void> _fetchOvertimeRules() async {
    const String apiUrl =
        "https://jt-hcm.simise.id/api/overtime.reason/search?domain=[]&fields=['id','name']";
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
            _reason = (jsonData['data'] as List)
                .map((item) => {'id': item['id'], 'name': item['name']})
                .toList();
          });
        } else {
          throw Exception('Data field is missing or not a list');
        }
      } else {
        throw Exception(
            'Failed to load overtime rules (status: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  void reset() {
    setState(() {
      _selectedReason = null;
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
            Text('Reason', style: AppTextStyles.heading2_1),
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
              hint: const Text('Select your reason'),
              value: _selectedReason,
              items: _reason
                  .map((rule) => DropdownMenuItem<String>(
                        value: rule['id'].toString(),
                        child:
                            Text(rule['name'], style: AppTextStyles.heading2_1),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedReason = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
