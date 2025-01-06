import 'package:flutter/material.dart';
import 'package:hcm_3/service/api_config.dart';
import '../../page_overtime.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';
import 'content_submit_ovt.dart';
import '/components/primary_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class PageSubmitOvt extends StatefulWidget {
  const PageSubmitOvt({super.key});

  @override
  State<PageSubmitOvt> createState() => _PageSubmitOvtState();
}

class _PageSubmitOvtState extends State<PageSubmitOvt> {
  int? _selectedMessageId;

  void _handleSelectMessage(int messageId) {
    setState(() {
      _selectedMessageId = messageId;
    });
  }

  Future<void> _submitData() async {
    if (_selectedMessageId == null) {
      Fluttertoast.showToast(msg: "No message selected!");
      return;
    }

    String apiUrl = ApiEndpoints.submitData();
    const Map<String, String> headers = {
      'Content-Type': 'application/json',
      'api-key': ApiConfig.apiKey
    };
    final body = jsonEncode({
      "method": "button_submit",
      "args": [
        [_selectedMessageId]
      ],
      "kw": {}
    });

    try {
      final response =
          await http.post(Uri.parse(apiUrl), headers: headers, body: body);
      if (response.statusCode == 200) {
        _showSuccessDialog();
      } else {
        Fluttertoast.showToast(
            msg: "Failed to submit data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Data submitted successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PageOvertime()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/appBar_bg_full.png', fit: BoxFit.cover),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                    ),
                    Text(
                      'Submit Overtime',
                      style: AppTextStyles.heading1_2,
                    ),
                    const SizedBox(width: 40)
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: PrimaryContainer(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0)),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: ContentSubmitOvt(
                    onSelectId: _handleSelectMessage,
                  ),
                ),
              )
            ],
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: PrimaryButton(
          buttonWidth: MediaQuery.of(context).size.width / 1.5,
          buttonText: 'Submit',
          onPressed: _submitData,
        ),
      ),
    );
  }
}
