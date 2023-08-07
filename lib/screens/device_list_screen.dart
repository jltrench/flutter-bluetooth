import 'package:bluetest/controllers/bluetooth_controller.dart';
import 'package:bluetest/screens/device_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceListScreen extends StatelessWidget {
  final BluetoothController _bluetoothController =
      Get.put(BluetoothController());

  Future<void> _requestBluetoothPermission() async {
    if (await Permission.bluetooth.request().isGranted) {
      final BluetoothState state = await FlutterBluetoothSerial.instance.state;
      if (state == BluetoothState.STATE_OFF) {
        await FlutterBluetoothSerial.instance.requestEnable();
      }
    } else {
      print('A permissão para Bluetooth foi negada pelo usuário.');
    }
  }

  Future<void> _getPairedDevices() async {
    List<BluetoothDevice> devices =
        await FlutterBluetoothSerial.instance.getBondedDevices();
    _bluetoothController.updatePairedDevices(devices);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dispositivos Bluetooth Pareados'),
      ),
      body: Obx(
        () {
          if (_bluetoothController.pairedDevices.isEmpty) {
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _requestBluetoothPermission();
                  await _getPairedDevices();
                },
                child: Text('Procurar Dispositivos Pareados'),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: _bluetoothController.pairedDevices.length,
              itemBuilder: (context, index) {
                BluetoothDevice device =
                    _bluetoothController.pairedDevices[index];
                return ListTile(
                  title: Text(device.name ?? ''),
                  subtitle: Text(device.address),
                  onTap: () {
                    _bluetoothController.connectToDevice(device);
                    Get.to(DeviceInfoScreen(), arguments: device);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
