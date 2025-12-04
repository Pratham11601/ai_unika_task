import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/text_styles.dart';
import '../widgets/constant_widgets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          height(49.h),
          Center(child: Text("Task round AI UNIKA", style: TextHelper.size20))],
      ),
    );
  }
}
