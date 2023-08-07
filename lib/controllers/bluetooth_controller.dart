import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothController extends GetxController {
  RxList<BluetoothDevice> _pairedDevices = RxList<BluetoothDevice>([]);
  BluetoothConnection? _bluetoothConnection;
  String _connectedDeviceName = '';
  String? _lastBrincoCapturado;

  List<BluetoothDevice> get pairedDevices => _pairedDevices;
  BluetoothConnection? get bluetoothConnection => _bluetoothConnection;
  String get connectedDeviceName => _connectedDeviceName;
  String? get lastBrincoCapturado => _lastBrincoCapturado;

  void updatePairedDevices(List<BluetoothDevice> devices) {
    _pairedDevices.assignAll(devices);
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    _bluetoothConnection = await BluetoothConnection.toAddress(device.address);
    _connectedDeviceName = device.name ?? 'Desconhecido';
    update();
    _bluetoothConnection?.input!.listen((Uint8List data) {
      String tagID = utf8.decode(data);
      _lastBrincoCapturado = tagID;
      update();
    });
  }

  void clearBluetoothConnection() {
    _bluetoothConnection?.finish();
    _bluetoothConnection = null;
    _connectedDeviceName = '';
    _lastBrincoCapturado = null;
    update();
  }
}
