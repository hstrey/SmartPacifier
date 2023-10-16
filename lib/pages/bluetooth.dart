import 'package:flutter/material.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({super.key});

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  String buttonName = 'Connect Device';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Wrap(
        runSpacing: 25.0,
        alignment: WrapAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
            child: Text(
              "These are the instructions on how to connect to your Bluetooth Smart Pacifier.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          ConnectionButton(),
          ConnectionButton(),
          ConnectionButton(),
          ConnectionButton(),
          ConnectionButton(),
        ],
      ),
    );
  }
}

class ConnectionButton extends StatefulWidget {
  const ConnectionButton({Key? key}) : super(key: key);

  @override
  State<ConnectionButton> createState() => _ConnectionButtonState();
}

class _ConnectionButtonState extends State<ConnectionButton> {
  String buttonName = 'Connect Device';
  bool buttonA = false;
  bool buttonB = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize: const Size(350, 50),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          shape: const StadiumBorder()),
      child: buttonB ? const Text("Connected") : const Text("Connect Device"),
      onPressed: () {
        setState(() {
          buttonA = !buttonA;
          buttonB = !buttonB;
        });
      },
    );
  }
}
