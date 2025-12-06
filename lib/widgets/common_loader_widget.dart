import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../utils/text_styles.dart';
import 'constant_widgets.dart';

class LoaderService {
  static final LoaderService _instance = LoaderService._internal();
  factory LoaderService() => _instance;
  LoaderService._internal();

  void showLoader() {
    if (!(Get.isDialogOpen ?? false)) {
      Get.dialog(
        const Center(child: CustomerLoadingNew()),
        barrierDismissible: false,
      );
    }
  }

  void hideLoader() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }
}



class CustomerLoadingNew extends StatelessWidget {
  const CustomerLoadingNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha((0.6 * 650).toInt()),
              borderRadius: BorderRadius.circular(10),
            ),
            child:   SizedBox(
              width: 42.w,
              height:42.w,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        height(0.5.h),
        Text("Loading Please wait..." ,style: TextHelper.size16.copyWith(
            fontWeight: FontWeight.w500
        ), )
      ],
    );
  }
}