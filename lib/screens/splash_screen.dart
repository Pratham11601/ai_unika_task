import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../widgets/constant_widgets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          height(29.h),
          Image.network("https://www.aiunika.com/_next/image?url=%2Faiunika-logo.png&w=640&q=75"),
        ],
      ),
    );
  }
}
