import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_pacifier/services/ble_helper.dart';
import 'package:smart_pacifier/services/device.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({super.key});

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  final Set<BLEDevice> scannedDevices = <BLEDevice>{};
  late final StreamSubscription<BLEDevice> scanSubscription;

  @override
  void initState(){
    super.initState();

    scanSubscription = BLE.scan().listen((BLEDevice device) {
      setState(() {
        scannedDevices.add(device);
      });
    });
  }
  

  @override
  void dispose() {
    super.dispose();

    scanSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrap(
        runSpacing: 25.0,
        alignment: WrapAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
            child: Text(
              "These are the instructions on how to connect to your Bluetooth Smart Pacifier.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(350, 50),
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepPurple,
              shape: const StadiumBorder(),
            ),
            child: const Text("Scan for Devices"),
            onPressed: () {
              setState(
                () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => _buildPopup(context, scannedDevices),
                  );
                },
              );
            },
          ),
          for (BLEDevice device in BLEDevice.currentDevices) ConnectionButton(device: device),
        ],
      ),
    );
  }
}

class ConnectionButton extends StatefulWidget {
  const ConnectionButton({required this.device, super.key});
  final BLEDevice device;

  @override
  State<ConnectionButton> createState() => _ConnectionButtonState();
}

class _ConnectionButtonState extends State<ConnectionButton> {
  String buttonName = 'Connect Device';
  bool connected = !(BLEDevice.displayedDevice == null);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(350, 50),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        shape: const StadiumBorder(),
      ),
      child: connected ? const Text("Connected") : const Text("Connect Device"),
      onPressed: () {
        setState(() {
          connected = !connected;
          connected
              ? BLEDevice.displayedDevice = widget.device
              : BLEDevice.displayedDevice = null;
        });
      },
    );
  }
}

Dialog _buildPopup(BuildContext context, Set<BLEDevice> devices) {
  return Dialog(
    elevation: 16,
    child: ListView(
      padding: const EdgeInsets.all(15),
      shrinkWrap: true,
      children: <Widget>[
        const SizedBox(
          height: 50,
          child: Text('Available Devices'),
        ),
        _popupItem(context, devices),
        const SizedBox(height: 20),
      ],
    ),
  );
}

Widget _popupItem(BuildContext context, Set<BLEDevice> devices) {
  final List<SizedBox> popupDisplay = <SizedBox>[];

  for (int i = 0; i < devices.length; i++) {
    popupDisplay.add(
      SizedBox(
        height: 50,
        child: TextButton(
          child: Text(devices.elementAt(i).name),
          onPressed: () async {
            Navigator.of(context).pop();
            await devices.elementAt(i).connect();
            
          },
        ),
      ),
    );
  }
  return Column(children: popupDisplay);
}
