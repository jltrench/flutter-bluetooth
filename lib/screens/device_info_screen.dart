import 'package:bluetest/controllers/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DeviceInfoScreen extends StatelessWidget {
  final BluetoothController _bluetoothController = Get.find();

  @override
  Widget build(BuildContext context) {
    final BluetoothDevice device = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações do Dispositivo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Nome do Dispositivo:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              device.name ?? 'Desconhecido',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Código do Último Brinco Capturado:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Text(
                _bluetoothController.lastBrincoCapturado ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _bluetoothController.clearBluetoothConnection();
          Get.back();
        },
        child: const Icon(Icons.bluetooth_disabled),
      ),
    );
  }
}
