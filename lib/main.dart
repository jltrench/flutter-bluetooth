import 'package:bluetest/screens/device_info_screen.dart';
import 'package:bluetest/screens/device_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Brincagem Bluetooth - flutter_bluetooth_serial ^0.4.0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(name: '/', page: () => DeviceListScreen()),
        GetPage(name: '/device-info', page: () => DeviceInfoScreen()),
      ],
      initialRoute: '/',
    );
  }
}
