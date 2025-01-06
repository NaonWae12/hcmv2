import 'package:flutter/material.dart';
import 'package:hcm_3/components/text_style.dart';
import 'package:hcm_3/service/api_config.dart';
import 'dart:convert'; // Untuk JSON decoding
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'submited/page_submit_ovt.dart';

class NavSubmited extends StatefulWidget {
  const NavSubmited({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavSubmitedState createState() => _NavSubmitedState();
}

class _NavSubmitedState extends State<NavSubmited> {
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
    }
  }

  Future<bool> _fetchHistoryData() async {
    final String apiUrl = ApiEndpoints.fetchHistoryData2(_employeeId);
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
          // Cek apakah ada state dengan nilai "draft"
          return data.any((item) => item['state'] == 'draft');
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _fetchHistoryData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error loading data."),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          // Tampilkan NavSubmited jika ada state = "draft"
          return Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PageSubmitOvt()),
                );
              },
              child: Text(
                'Show all submited',
                style: AppTextStyles.heading3_1,
              ),
            ),
          );
        } else {
          // Tidak ada data dengan state = "draft"
          return const SizedBox.shrink(); // Tidak tampilkan apa pun
        }
      },
    );
  }
}
