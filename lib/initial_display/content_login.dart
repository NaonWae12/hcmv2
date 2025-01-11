// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../components/primary_button.dart';
import '../components/textfield_input.dart';
import '../components/textfield_pw.dart';
import '../custom_loading.dart';
import '../navbar.dart';
import '../service/api_config.dart';

class ContentLogin extends StatefulWidget {
  const ContentLogin({super.key});

  @override
  State<ContentLogin> createState() => _ContentLoginState();
}

class _ContentLoginState extends State<ContentLogin> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final String databaseName = 'JT_HCM_UAT';

  Future<void> login() async {
    // Log untuk menampilkan username dan database yang digunakan
    // print('Attempting login with username: ${usernameController.text}');
    // print('Database: $databaseName');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CustomLoading(imagePath: 'assets/3.png'),
    );

    final url = ApiEndpoints.login(
        databaseName, usernameController.text, passwordController.text);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'db': databaseName,
          'login': usernameController.text,
          'password': passwordController.text,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print('Decoded Data: $data');

        if (data['status'] == 'success') {
          print('Login successful. Session ID: ${data['session_id']}');

          SharedPreferences prefs = await SharedPreferences.getInstance();

          if (data.containsKey('user_id')) {
            print('User ID: ${data['user_id']}');
            await prefs.setInt('user_id', data['user_id']);
          }

          if (data.containsKey('employee_id')) {
            print('Employee ID: ${data['employee_id']}');
            await prefs.setInt('employee_id', data['employee_id']);
          }

          if (data.containsKey('name')) {
            print('Name: ${data['name']}');
            await prefs.setString('name', data['name']);
          }

          if (data.containsKey('role_user')) {
            print('Role User: ${data['role_user']}');
            await prefs.setString('role_user', data['role_user'].toString());
          }

          if (data.containsKey('job_id')) {
            final jobId = data['job_id'];
            print('Job ID: $jobId');
            if (jobId is bool) {
              await prefs.setString('job_id',
                  'No Job Assigned'); // Menyimpan nilai default jika boolean
            } else {
              await prefs.setString('job_id', jobId.toString());
            }
          }

          await prefs.setString('session_id', data['session_id']);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Navbar()),
          );
        } else {
          print('Login failed. Message: ${data['message']}');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Login Failed"),
              content: Text(data['message'] ??
                  "Please check your credentials and try again."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Connection Error"),
            content: const Text("An error occurred. Please try again later."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      print('An error occurred: $error'); // Log jika terjadi error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("An error occurred. Please try again later."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Column(
        children: [
          const Text(
              "Ensure that your account is associated with your company's email address to access our applications."),
          const SizedBox(height: 20),
          TextfieldInput(
            controller: usernameController,
            hintText: 'Username',
            icon: const Icon(Icons.person, color: Colors.grey),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          TextfileldPw(
            controller: passwordController,
            icon: 'assets/icons/Lock_key.svg',
            hintText: 'Input your password',
            obscureText: true,
          ),
          const SizedBox(height: 35),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PrimaryButton(
                      buttonWidth: MediaQuery.of(context).size.width,
                      buttonHeight: 50,
                      buttonText: 'Sign In',
                      onPressed: login),
                  SizedBox(height: MediaQuery.of(context).size.height / 3.5),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('assets/icons/attention.svg'),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: const Text(
                            "If you encounter issues, please contact your company's HR department for assistance.",
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
