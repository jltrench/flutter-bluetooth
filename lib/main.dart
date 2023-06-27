// ignore_for_file: avoid_print, prefer_final_fields, library_private_types_in_public_api

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brincagem Bluetooth - flutter_bluetooth_serial ^0.4.0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  BluetoothConnection? _connection;
  List<String> _brincos = [];
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;

  @override
  void initState() {
    super.initState();
    _getPairedDevices();
  }

  Future<void> _getPairedDevices() async {
    List<BluetoothDevice> devices =
        await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {
      _devices = devices;
    });
  }

  void _startConnection() async {
    BluetoothConnection.toAddress(_selectedDevice!.address).then((connection) {
      print('Conectado ao Bastão');

      setState(() {
        _connection = connection;
      });

      _connection!.input!.listen((Uint8List data) {
        String tagID = utf8.decode(data);
        setState(() {
          _brincos.add(tagID);
        });
      });
    }).catchError((error) {
      print('Não foi possível se conectar.');
      print(error);
    });
  }

  void _disconnect() async {
    await _connection?.close();
    setState(() {
      _connection = null;
      _brincos.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brincagem - flutter_bluetooth_serial ^0.4.0'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _connection == null ? _startConnection : _disconnect,
              child: Text(_connection == null ? 'Conectar' : 'Desconectar'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Códigos dos Brincos Capturados:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _brincos.length,
                itemBuilder: (context, index) {
                  String brinco = _brincos[index];
                  return ListTile(
                    title: Text(brinco),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Dispositivos pareados:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                BluetoothDevice device = _devices[index];
                return ListTile(
                  title: Text(device.name ?? ''),
                  subtitle: Text(device.address),
                  onTap: () {
                    setState(() {
                      _selectedDevice = device;
                    });
                  },
                  selected: _selectedDevice == device,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
