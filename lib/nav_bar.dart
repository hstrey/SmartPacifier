import 'package:flutter/material.dart';
import 'package:smart_pacifier/pages/bluetooth.dart';
import 'package:smart_pacifier/pages/battery_life.dart';
import 'package:smart_pacifier/pages/metrics.dart';
import 'package:smart_pacifier/services/device.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<StatefulWidget> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 1;

  final List<String> _titles = <String>[
    'Bluetooth',
    'Metrics',
    'Battery',
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      const Bluetooth(),
      Metrics(device: BLEDevice.displayedDevice),
      BatteryLife(device: BLEDevice.displayedDevice),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
      ),
      body: children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth_rounded),
            backgroundColor: Color(0xFFA8EFFF),
            label: 'Bluetooth',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.broken_image_outlined),
            backgroundColor: Color(0xFFA8EFFF),
            label: 'Metrics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.battery_6_bar),
            label: 'Battery',
            backgroundColor: Color(0xFFA8EFFF),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) async {
    setState(() {
      _currentIndex = index;
    });
  }
}
