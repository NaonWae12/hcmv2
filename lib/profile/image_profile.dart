// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hcm_3/service/api_config.dart';
import 'package:image_picker/image_picker.dart'; // Tambahkan library image_picker
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class ImageProfile extends StatefulWidget {
  const ImageProfile({super.key});

  @override
  State<ImageProfile> createState() => _ImageProfileState();
}

class _ImageProfileState extends State<ImageProfile> {
  String? _photoBase64; // Data Base64 dari API
  Uint8List? _photoBytes; // Data gambar dalam format byte
  final String _defaultPhoto = 'assets/Payroll.png'; // Foto default
  int? employeeId;
  final String apiKey = ApiConfig.apiKey;

  @override
  void initState() {
    super.initState();
    _loadEmployeeIdAndFetchPhoto();
  }

  Future<void> _loadEmployeeIdAndFetchPhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    employeeId = prefs.getInt('employee_id'); // Ambil langsung sebagai int

    if (employeeId != null) {
      final url = "$baseUrl/employee/get_photo/$employeeId";

      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'api-key': apiKey,
          },
        );

        // print('Response status: ${response.statusCode}');
        // print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final body = json.decode(response.body);
          if (body['status'] == 'success') {
            final photoBase64 = body['data']['photo'];
            // print('Photo Base64: $photoBase64');

            setState(() {
              _photoBase64 = photoBase64;
              _photoBytes = base64Decode(photoBase64);
            });
          } else {
            // print('Error in response: ${body['status']}');
          }
        } else {
          // print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        }
      } catch (e) {
        // print('Exception: $e');
      }
    } else {
      // print('Employee ID not found in SharedPreferences.');
    }
  }

  Future<void> _updatePhoto(File imageFile) async {
    // Encode image to Base64
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    // Cek employeeId
    if (employeeId == null) {
      // print('Employee ID is null.');
      return;
    }

    const url = "$baseUrl/employee/update_photo";
    final body = jsonEncode({
      'employee_id': employeeId,
      'photo': base64Image,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'api-key': apiKey,
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['status'] == 'success') {
          // print('Photo updated successfully.');

          // Refresh halaman dengan memuat ulang data foto
          await _loadEmployeeIdAndFetchPhoto();

          setState(() {
            _photoBase64 = base64Image;
            _photoBytes = bytes;
          });
        } else {
          // print('Error updating photo: ${responseBody['message']}');
        }
      } else {
        // print('Failed to update photo: ${response.reasonPhrase}');
      }
    } catch (e) {
      // print('Exception: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File imageFile = File(image.path);
      await _updatePhoto(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_photoBase64 != null) {
      if (_photoBase64!.startsWith('<svg') || _photoBase64!.contains('<?xml')) {
        imageWidget = SvgPicture.string(
          utf8.decode(base64Decode(_photoBase64!)),
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        );
      } else {
        imageWidget = Image.memory(
          _photoBytes!,
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        );
      }
    } else {
      imageWidget = Image.asset(
        _defaultPhoto,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    }

    return Center(
      child: Stack(
        children: [
          const SizedBox(
            height: 105,
            width: 103,
          ),
          Positioned(
            top: 0,
            left: 0,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.lightBlueAccent,
              child: ClipOval(child: imageWidget),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: const CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
