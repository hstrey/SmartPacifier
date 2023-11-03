import 'package:flutter/material.dart';
import 'package:smart_pacifier/pages/bluetooth.dart';
import 'package:smart_pacifier/pages/batteryLife.dart';
import 'package:smart_pacifier/pages/metrics.dart';

class NavBar extends StatefulWidget {
  int initialIndex = 1;
  NavBar(initialIndex, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _NavBarState(initialIndex);
  }
}

class _NavBarState extends State<NavBar> {
  _NavBarState(this._currentIndex);
  int _currentIndex;
  final List<Widget> _children = [
    const Bluetooth(),
    const Metrics(),
    BatteryLife(batteryValue: 49,)
  ];

  final List<String> _titles = [
    'Bluetooth',
    'Metrics',
    'Battery'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        items: const [
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
          )
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