// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hcm_3/service/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class ImageProfile extends StatefulWidget {
  const ImageProfile({super.key});

  @override
  State<ImageProfile> createState() => _ImageProfileState();
}

class _ImageProfileState extends State<ImageProfile> {
  String? _photoBase64;
  Uint8List? _photoBytes;
  int? employeeId;
  final String apiKey = ApiConfig.apiKey;

  @override
  void initState() {
    super.initState();
    _loadEmployeeIdAndFetchPhoto();
  }

  Future<void> _loadEmployeeIdAndFetchPhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    employeeId = prefs.getInt('employee_id');

    if (employeeId != null) {
      final url = "$baseUrl/employee/get_photo/$employeeId";

      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'api-key': apiKey,
          },
        );

        // print("Response Status Code: ${response.statusCode}");
        // print("Response Body: ${response.body}");

        if (response.statusCode == 200) {
          final body = json.decode(response.body);

          // Validasi struktur JSON yang benar
          if (body.containsKey('status') &&
              body['status'] == 'success' &&
              body.containsKey('data') &&
              body['data'].containsKey('photo')) {
            final photoBase64 = body['data']['photo'];

            // Coba decode base64, tangani error jika tidak valid
            try {
              final bytes = base64Decode(photoBase64);
              setState(() {
                _photoBase64 = photoBase64;
                _photoBytes = bytes;
              });
            } catch (e) {
              print("Failed to decode base64: $e");
            }
          } else {
            print("Invalid response format: Missing 'data' or 'photo'");
          }
        } else {
          print("Failed to load image, status code: ${response.statusCode}");
        }
      } catch (e) {
        print("Exception: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_photoBase64 != null && _photoBytes != null) {
      if (_photoBase64!.startsWith('<svg') || _photoBase64!.contains('<?xml')) {
        imageWidget = SvgPicture.string(
          utf8.decode(base64Decode(_photoBase64!)),
          fit: BoxFit.cover,
          width: 39,
          height: 39,
        );
      } else {
        imageWidget = Image.memory(
          _photoBytes!,
          fit: BoxFit.cover,
          width: 39,
          height: 39,
          errorBuilder: (context, error, stackTrace) {
            print("Error displaying image: $error");
            return const Icon(
              Icons.account_circle,
              size: 32,
              color: Colors.grey,
            );
          },
        );
      }
    } else {
      // Fallback ke ikon default jika tidak ada foto
      imageWidget = const Icon(
        Icons.account_circle,
        size: 32,
        color: Colors.grey,
      );
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey,
      child: ClipOval(child: imageWidget),
    );
  }
}
