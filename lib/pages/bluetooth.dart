import 'package:flutter/material.dart';
import 'package:smart_pacifier/services/device.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({super.key});

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  List<ConnectionButton> scannedDevices = <ConnectionButton>[];

  @override
  void initState() {
    super.initState();
    for (BLEDevice device in BLEDevice.currentDevices) {
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
                    builder: (BuildContext context) => _buildPopup(context),
                  );
                },
              );
            },
          ),
          for (ConnectionButton button in scannedDevices) button,
        ],
      ),
    );
  }
}

class NewDeviceButton extends StatefulWidget {
  const NewDeviceButton({super.key});

  @override
  State<NewDeviceButton> createState() => _NewDeviceButtonState();
}

class _NewDeviceButtonState extends State<NewDeviceButton> {
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      label: const Text("New Device"),
      icon: const Icon(
        Icons.add,
        color: Colors.deepPurple,
      ),
      style: OutlinedButton.styleFrom(
        fixedSize: const Size(350, 50),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        side: const BorderSide(width: 3, color: Colors.deepPurple),
        backgroundColor: Colors.white,
        shape: const StadiumBorder(),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: Image.asset('assets/images/pacifier1.png'),
                  ),
                  const Text(
                    'What is your new device name?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a new device name...',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          nameController.text = '';
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        child: const Text('Add Device'),
                        onPressed: () {
                          widget.buttonNames.add(nameController.text);
                          nameController.text = '';
                          Navigator.pop(context);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class RemoveDeviceButton extends Bluetooth {
  const RemoveDeviceButton({super.key});

  @override
  State<RemoveDeviceButton> createState() => _RemoveDeviceButtonState();
}

class _RemoveDeviceButtonState extends State<RemoveDeviceButton> {
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      label: const Text("Remove Device"),
      icon: const Icon(
        Icons.remove,
        color: Colors.deepPurple,
      ),
      style: OutlinedButton.styleFrom(
        fixedSize: const Size(350, 50),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        side: const BorderSide(width: 3, color: Colors.deepPurple),
        backgroundColor: Colors.white,
        shape: const StadiumBorder(),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: Image.asset('assets/images/pacifier1.png'),
                  ),
                  const Text(
                    'What is your new device name?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a new device name...',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          nameController.text = '';
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        child: const Text('Add Device'),
                        onPressed: () {
                          widget.buttonNames.add(nameController.text);
                          nameController.text = '';
                          Navigator.pop(context);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
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
  bool connected = false;

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

Dialog _buildPopup(BuildContext context) {
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
        _popupItem(context),
        const SizedBox(height: 20),
      ],
    ),
  );
}

Widget _popupItem(BuildContext context) {
  final List<SizedBox> popupDisplay = <SizedBox>[];
  final List<BLEDevice> devices = <BLEDevice>[];

  for (int i = 0; i < devices.length; i++) {
    popupDisplay.add(
      SizedBox(
        height: 50,
        child: TextButton(
          child: Text(devices[i].name),
          onPressed: () async {
            Navigator.of(context).pop();
            await devices[i].connect();
          },
        ),
      ),
    );
  }
  return Column(children: popupDisplay);
}
