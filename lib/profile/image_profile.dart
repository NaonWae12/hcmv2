import 'package:flutter/material.dart';

class ImageProfile extends StatelessWidget {
  const ImageProfile({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: ClipOval(
                child: Image.asset('assets/Payroll.png'),
              ),
            ),
          ),
          const Positioned(
            bottom: 2,
            right: 0,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: ClipOval(
                  child: Icon(
                Icons.camera_alt_outlined,
                color: Colors.black,
                size: 18,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
