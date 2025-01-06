import 'package:flutter/material.dart';
import '../../page_reimburse.dart';
import '/components/primary_container.dart';
import '/components/text_style.dart';
import 'content_submit_report.dart';
import '/components/primary_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PageSubmitReport extends StatefulWidget {
  const PageSubmitReport({super.key});

  @override
  State<PageSubmitReport> createState() => _PageSubmitReportState();
}

class _PageSubmitReportState extends State<PageSubmitReport> {
  int? _selectedMessageId;

  void _handleSelectMessage(int messageId) {
    setState(() {
      _selectedMessageId = messageId;
    });
  }

  Future<void> _submitData() async {
    if (_selectedMessageId == null) {
      // ignore: avoid_print
      print("No message selected!");
      return;
    }

    const String apiUrl =
        "https://jt-hcm.simise.id/api/hr.expense.sheet/execute_kw";
    const Map<String, String> headers = {
      'Content-Type': 'application/json',
      'api-key': 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08',
    };
    final body = jsonEncode({
      "method": "action_submit_sheet",
      "args": [
        [_selectedMessageId]
      ],
      "kw": {}
    });

    try {
      final response =
          await http.post(Uri.parse(apiUrl), headers: headers, body: body);
      if (response.statusCode == 200) {
        // ignore: avoid_print
        print("Data submitted successfully!");
        _showSuccessDialog();
      } else {
        // ignore: avoid_print
        print("Failed to submit data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text("Data has been submitted successfully."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const PageReimburse(),
                  ),
                );
              },
              child: const Text("OK"),
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
                      'Submit Report',
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
                  child: ContentSubmitReport(
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
