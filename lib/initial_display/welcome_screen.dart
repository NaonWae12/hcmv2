// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/components/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navbar.dart';
import 'greeting_page.dart';
import 'page_login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    checkSession();
  }

  Future<void> checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('session_id');

    if (sessionId != null) {
      // Jika session_id ditemukan, arahkan langsung ke Navbar
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Navbar()),
      );
    }
  }

  List<WelcomeSlider> welcomeSlider = [
    WelcomeSlider(
      title: 'Effortless Attendance Tracking',
      description:
          "Log your attendance effortlessly. Clock in, clock out – it's that simple. Focus on your work, and we'll take care of the rest",
      image: 'assets/wellscreen1.png',
    ),
    WelcomeSlider(
      title: 'Elevate Your Performance',
      description:
          "Track your Key Performance Indicators (KPIs), set goals, and visualize your progress. Your career journey just got a whole lot clearer.",
      image: 'assets/wellscreen2.png',
    ),
    WelcomeSlider(
      title: 'Seize Work-Life Balance',
      description:
          "Need a day off? Planning a holiday? We puts time-off requests at your fingertips. Take charge of your work-life balance with us",
      image: 'assets/wellscreen3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/bg.png'), fit: BoxFit.fill)),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        welcomeSlider.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.all(1),
                            child: Container(
                              height: 5,
                              width: MediaQuery.of(context).size.width / 3.65,
                              decoration: BoxDecoration(
                                color: index <= _currentPage
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const PageLogin(),
                          ),
                        );
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: welcomeSlider.length,
                      onPageChanged: (value) {
                        setState(() {
                          _currentPage = value;
                        });
                      },
                      itemBuilder: (context, index) {
                        final item = welcomeSlider[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              item.image,
                              height: 350,
                              width: 350,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.25,
                              child: Text(item.title,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.displayText_3(context)),
                            ),
                            Text(
                              item.description,
                              style: AppTextStyles.heading3_3,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          if (_currentPage < welcomeSlider.length - 1) {
            _pageController.jumpToPage(_currentPage + 1);
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const GreetingPage(),
              ),
            );
          }
        },
        child: _currentPage != welcomeSlider.length - 1
            ? Icon(Icons.arrow_forward,
                color: Theme.of(context).colorScheme.surface)
            : Icon(Icons.done, color: Theme.of(context).colorScheme.surface),
      ),
    );
  }
}

class WelcomeSlider {
  final String title;
  final String description;
  final String image;

  WelcomeSlider({
    required this.title,
    required this.description,
    required this.image,
  });
}
