import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/components/text_style.dart';

import 'bottom_content.dart';
import 'midle_content.dart';
import 'top_content.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isRefreshing = false;
  final GlobalKey<BottomContentState> _bottomContentKey =
      GlobalKey<BottomContentState>();

  String _jobId = 'Loading...';
  String _name = 'Loading...';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _loadUserData(); // Load data saat widget diinisialisasi
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _jobId = prefs.getString('job_id') ?? 'Unknown Job';
      _name = prefs.getString('name') ?? 'Unknown Name';
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    _animationController.repeat(); // Memulai animasi rotasi
    await Future.delayed(const Duration(seconds: 1)); // Simulasi waktu pemuatan

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
      _animationController.stop(); // Menghentikan animasi rotasi
      _animationController.reset();
      await _loadUserData(); // Refresh data dari SharedPreferences
    }
  }

  Future<void> _triggerRefresh() async {
    await _handleRefresh();
    if (mounted) {
      setState(() {}); // Memperbarui tampilan setelah refresh
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _jobId, // Teks dari SharedPreferences
                style: AppTextStyles.heading3_2,
              ),
              Text(
                _name, // Teks dari SharedPreferences
                style: AppTextStyles.heading2_3,
              ),
            ],
          ),
          leading: const Icon(
            Icons.account_circle,
            color: Colors.white,
            size: 32,
          ),
          flexibleSpace: Image.asset(
            'assets/appBar_bg1.png',
            fit: BoxFit.fill,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(), // Memastikan bisa di-scroll untuk refresh
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Image.asset(
                      'assets/appBar_bg2.png',
                      fit: BoxFit.cover,
                    ),
                    Column(
                      children: [
                        const TopContent(),
                        const SizedBox(height: 20),
                        const MidleContent(),
                        const SizedBox(height: 10),
                        BottomContent(key: _bottomContentKey),
                      ],
                    ),
                    Positioned(
                      top: 10,
                      right: 30,
                      child: IconButton(
                        onPressed: _triggerRefresh,
                        icon: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return RotationTransition(
                              turns: _animationController,
                              child: Icon(
                                Icons.refresh_outlined,
                                color:
                                    _isRefreshing ? Colors.blue : Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}