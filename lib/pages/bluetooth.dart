import 'package:flutter/material.dart';
import 'package:smart_pacifier/services/device.dart';
import 'package:smart_pacifier/services/ble_helper.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({super.key});

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  List<ConnectionButton> scannedDevices = [];
  
  @override
  void initState() {
    super.initState();
    for(BLEDevice device in BLEDevice.currentDevices){
      scannedDevices.add(ConnectionButton(device: device));
    }
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
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                shape: const StadiumBorder()),
            child: const Text("Scan for Devices"),
            onPressed: () {
              setState(() {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopup(context)
                );
            },);
            },
          ),
          for(ConnectionButton button in scannedDevices) button,
        ],
      ),
    );
  }
}

class ConnectionButton extends StatefulWidget {
  final BLEDevice device;
  
  const ConnectionButton({required this.device, Key? key}) : super(key: key);

  @override
  State<ConnectionButton> createState() => _ConnectionButtonState();
}

class _ConnectionButtonState extends State<ConnectionButton> {
  String buttonName = 'Connect Device';
  bool connected = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize: const Size(350, 50),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          shape: const StadiumBorder()),
      child: connected ? const Text("Connected") : const Text("Connect Device"),
      onPressed: () {
        setState(() {
          connected = !connected;
          connected ? BLEDevice.displayedDevice = widget.device : BLEDevice.displayedDevice = null;
        });
      },
    );
  }
}

Dialog _buildPopup(BuildContext context) {
  return Dialog(
    elevation: 16,
    child: ListView(padding: const EdgeInsets.all(15), shrinkWrap: true, children: [
      const SizedBox(
        height: 50,
        child: Text('Available Devices'),
      ),
      _popupItem(context),
      const SizedBox(height: 20)
    ]),
  );
}

Widget _popupItem(BuildContext context) {
  List<SizedBox> popupDisplay = [];
  List<BLEDevice> devices = [];

  for (int i = 0; i < devices.length; i++) {
    popupDisplay.add(SizedBox(
      height: 50,
      child: TextButton(
        child: Text(devices[i].name),
        onPressed: () async {
          Navigator.of(context).pop();
          devices[i].connect();
        },
      ),
    ));
  }
  return Column(children: popupDisplay);
}