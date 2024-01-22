import 'package:flutter/material.dart';
import 'package:smart_pacifier/services/device.dart';
import 'package:smart_pacifier/services/ble_helper.dart';

class Bluetooth extends StatefulWidget {  
  List<String> buttonNames = [];

  Bluetooth({super.key});

  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
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
          NewDeviceButton(),
          RemoveDeviceButton(),
          for(String name in widget.buttonNames) ConnectionButton(buttonName: name,)
        ],
      ),
    );
  }
}

class NewDeviceButton extends Bluetooth{

  NewDeviceButton({Key? key} ) : super(key: key);

  @override
  State<NewDeviceButton> createState() => _NewDeviceButtonState();
}

class _NewDeviceButtonState extends State<NewDeviceButton>{
  
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return OutlinedButton.icon(
      label: const Text("New Device"),
      icon: const Icon(
        Icons.add,
        color: Colors.deepPurple,
      ),
      style: OutlinedButton.styleFrom(
          fixedSize: const Size(350, 50),
          textStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          side: const BorderSide(width: 3, color: Colors.deepPurple),
          backgroundColor: Colors.white,
          shape: const StadiumBorder()),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child:Image.asset('assets/images/pacifier1.png')
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
                    children: [
                      ElevatedButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          nameController.text = '';
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width:30),
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

class RemoveDeviceButton extends Bluetooth{

  RemoveDeviceButton({Key? key} ) : super(key: key);

  @override
  State<RemoveDeviceButton> createState() => _RemoveDeviceButtonState();
}

class _RemoveDeviceButtonState extends State<RemoveDeviceButton>{
  
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return OutlinedButton.icon(
      label: const Text("Remove Device"),
      icon: const Icon(
        Icons.remove,
        color: Colors.deepPurple,
      ),
      style: OutlinedButton.styleFrom(
          fixedSize: const Size(350, 50),
          textStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          side: const BorderSide(width: 3, color: Colors.deepPurple),
          backgroundColor: Colors.white,
          shape: const StadiumBorder()),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child:Image.asset('assets/images/pacifier1.png')
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
                    children: [
                      ElevatedButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          nameController.text = '';
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width:30),
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
  final String buttonName;
  
  const ConnectionButton({Key? key, required this.buttonName}) : super(key: key);

  @override
  State<ConnectionButton> createState() => _ConnectionButtonState();
}

class _ConnectionButtonState extends State<ConnectionButton> {
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
      child: buttonB ? Text("${widget.buttonName} (Connected)") : Text("${widget.buttonName} (Not Connected)"),
      onPressed: () {
        setState(() {
          buttonA = !buttonA;
          buttonB = !buttonB;
        });
      },
    );
  }
}
