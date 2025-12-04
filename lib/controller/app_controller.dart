import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../api/api_manager.dart';
import '../routes/routes.dart';
import '../utils/connection.dart';

class AppController extends GetxController {
  final Connection connection = Connection();
  StreamSubscription<bool>? connectionSubscription;
  String? userToken;

  @override
  void onInit() async {
    super.onInit();
    await initializeConnectionServices();
    APIManager.init(this);
    await Future.delayed(const Duration(seconds: 3));
    Get.offAllNamed(Routes.DASHBOARD_SCREEN);
  }



  Future<void> initializeConnectionServices() async {
    connection.initValue = await Connection.checkInternet();
    connectionSubscription = connection.onChangeConnectivity.listen((event) {
      debugPrint('Has internet $event');
    });
  }


  @override
  void onClose() {
    connectionSubscription?.cancel();
    super.onClose();
  }
}
