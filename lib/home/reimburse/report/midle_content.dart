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
  List<Map<String, dynamic>> _managers = [];
  String? _selectedManager;

  String? get selectedManager => _selectedManager;

  @override
  void initState() {
    super.initState();
    _fetchManagers();
  }

  Future<void> _fetchManagers() async {
    const String apiUrl =
        "https://jt-hcm.simise.id/api/res.users/search?domain=[('groups_id','in',163)]&fields=['partner_id']";
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
            _managers = (jsonData['data'] as List)
                .map((item) => {
                      'id': item['partner_id'][0]['id'],
                      'name': item['partner_id'][0]['name'],
                    })
                .toList();
          });
        } else {
          throw Exception('Data field is missing or not a list');
        }
      } else {
        throw Exception(
            'Failed to load managers (status: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
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
            Text('Manager', style: AppTextStyles.heading2_1),
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
              hint: const Text('Select Manager'),
              value: _selectedManager,
              items: _managers
                  .map((manager) => DropdownMenuItem<String>(
                        value: manager['id'].toString(),
                        child: Text(manager['name'],
                            style: AppTextStyles.heading2_1),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedManager = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
