// ignore_for_file: avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import '../../service/api_config.dart';
import '/components/primary_button.dart';
import '/components/text_style.dart';
import 'approval/page_approval.dart';
import 'bottom_content.dart';
import 'package:http/http.dart' as http;
import 'history_time_of/page_history.dart';
import 'midle_content1.dart';
import 'midle_content2.dart';
import 'success_dialog.dart';
import 'top_content.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PageTimeOff extends StatefulWidget {
  const PageTimeOff({super.key});

  @override
  State<PageTimeOff> createState() => _PageTimeOffState();
}

class _PageTimeOffState extends State<PageTimeOff> {
  final GlobalKey<TopContentState> _topContentKey =
      GlobalKey<TopContentState>();
  final GlobalKey<MidleContent1State> _midleContent1Key =
      GlobalKey<MidleContent1State>();
  final GlobalKey<MidleContent2State> _midleContent2Key =
      GlobalKey<MidleContent2State>();
  PlatformFile? _selectedFile;
  bool showBottomContent = false;
  String? roleUser;
  int tabCount = 2;

  @override
  void initState() {
    super.initState();
    _loadRoleUser();
  }

  Future<void> _loadRoleUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      roleUser = prefs.getString('role_user');
      print('Role User: $roleUser');
      tabCount = (roleUser == 'approver') ? 3 : 2;
    });
  }

  void _onFileSelected(PlatformFile? file) {
    setState(() {
      _selectedFile = file;
    });
  }

  void _handleSupportDocumentChanged(bool supportDocument) {
    setState(() {
      showBottomContent = supportDocument;
    });
  }

  void _resetForm() {
    // Reset all form states
    _topContentKey.currentState
        ?.reset(); // Tambahkan metode reset di TopContent
    _midleContent1Key.currentState
        ?.reset(); // Tambahkan metode reset di MidleContent1
    _midleContent2Key.currentState
        ?.reset(); // Tambahkan metode reset di MidleContent2
    setState(() {
      _selectedFile = null;
      showBottomContent = false;
    });
  }

  Future<void> submitTimeOffRequest() async {
    final holidayStatusId =
        _topContentKey.currentState?.selectedHolidayStatusId;
    final fromDate1 = _midleContent1Key.currentState?.fromDate1;
    final fromDate2 = _midleContent1Key.currentState?.fromDate2;
    final description = _midleContent2Key.currentState?.description;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final employeeId = prefs.getInt('employee_id');

    if (holidayStatusId == null || employeeId == null) {
      print(
          "Please select a category and ensure employee ID is loaded before submitting.");
      return;
    }

    final url = Uri.parse(ApiEndpoints.submitTimeOffRequest());
    final body = json.encode({
      'holiday_status_id': holidayStatusId,
      'employee_id': employeeId,
      "holiday_type": "employee",
      'request_date_from': fromDate1?.toIso8601String(),
      'request_date_to': fromDate2?.toIso8601String(),
      'name': description,
    });

    print('Sending request to API hr.leave/create with data: $body');

    try {
      final response = await http.post(
        url,
        headers: {
          'api-key': ApiConfig.apiKey,
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final createId = responseData['create_id'];

        if (createId != null) {
          print('API hr.leave/create successful, create_id: $createId');

          // Log additional information
          print('Response body from API hr.leave/create: ${response.body}');

          // Lanjutkan untuk mengunggah file
          await uploadFile(employeeId, createId);

          if (mounted) {
            await showSuccessDialog(
              context,
              'Your time off request has been successfully submitted!',
            );

            // Reset form setelah sukses
            _resetForm();
          }
        } else {
          print('create_id not found in response.');
        }
      } else if (response.statusCode == 400) {
        // Tangani error 400
        print('Failed to submit request: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (mounted) {
          await showErrorDialog(
            context,
            'Failed to submit request: Invalid data or overlapping dates. Please check your input.',
          );
        }
      } else {
        print('Failed to submit request: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error submitting request: $e');
    }
  }

  Future<void> showErrorDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadFile(int employeeId, int createId) async {
    if (_selectedFile == null) {
      print('No file selected for upload.');
      return;
    }

    try {
      // Baca file dan encode menjadi base64
      final fileBytes = await File(_selectedFile!.path!).readAsBytes();
      final encodedFile = base64Encode(fileBytes);

      // Gunakan mime untuk mendeteksi MIME type, atau tambahkan "image/" jika tidak ditemukan
      String? mimeType = lookupMimeType(_selectedFile!.path!);
      if (mimeType == null || !mimeType.startsWith('image/')) {
        final extension =
            _selectedFile!.extension ?? 'unknown'; // Ambil ekstensi file
        mimeType = 'image/$extension';
      }

      // URL API
      final uploadUrl = Uri.parse(ApiEndpoints.uploadFile());

      // Buat body JSON
      final fileBody = json.encode({
        "name": _selectedFile!.name,
        "datas": encodedFile,
        "res_model": "hr.leave",
        "res_id": createId,
        "mimetype": mimeType,
        "public": true,
      });

      print('Sending file to API ir.attachment/create with data: $fileBody');

      // Kirim POST request ke API
      final response = await http.post(
        uploadUrl,
        headers: {
          'api-key': ApiConfig.apiKey,
          'Content-Type': 'application/json',
        },
        body: fileBody,
      );

      // Cek status response
      if (response.statusCode == 200) {
        print('File uploaded successfully.');
      } else {
        print('Failed to upload file: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabCount,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Text(
                'Time Off',
                style: AppTextStyles.heading1_1,
              ),
              const SizedBox(width: 40),
            ],
          ),
          bottom: TabBar(
            tabs: [
              const Tab(text: 'Request'),
              const Tab(text: 'History'),
              if (roleUser == 'approver') const Tab(text: 'Approval'),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  TopContent(
                    key: _topContentKey,
                    midleContentKey: _midleContent1Key,
                    onSupportDocumentChanged: _handleSupportDocumentChanged,
                  ),
                  const SizedBox(height: 10),
                  MidleContent1(key: _midleContent1Key),
                  const SizedBox(height: 10),
                  MidleContent2(key: _midleContent2Key),
                  const SizedBox(height: 10),
                  if (showBottomContent)
                    BottomContent(onFileSelected: _onFileSelected),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: PrimaryButton(
                      buttonHeight: 50,
                      buttonWidth: MediaQuery.of(context).size.width,
                      buttonText: 'Submit time off request',
                      onPressed: submitTimeOffRequest,
                    ),
                  ),
                ],
              ),
            ),
            const PageHistory(),
            if (roleUser == 'approver') const PageApproval(),
          ],
        ),
      ),
    );
  }
}
