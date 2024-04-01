import 'package:flutter/material.dart';
import 'package:smart_pacifier/services/device.dart';
import 'dart:math' as math;

class BatteryLife extends StatefulWidget {
  const BatteryLife({required this.device, super.key});
  final BLEDevice? device;

  @override
  State<StatefulWidget> createState() => _BatteryLifeState();
}

class _BatteryLifeState extends State<BatteryLife> {
  final List<Color> batteryColors = <Color>[
    Colors.black,
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.green,
  ];

  late Future<List<int>>? batteryFuture;

  @override
  void initState() {
    super.initState();
    batteryFuture =
        widget.device?.getBatteryInfo();
  }

  @override
  Widget build(BuildContext context) {
    if(batteryFuture == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No device connected.',
            textScaleFactor: 2,
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else{
      return FutureBuilder<List<int>>(
        future: batteryFuture,
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          if (snapshot.hasData) {
            final int batteryValue = snapshot.data![0];
            final int isCharging = snapshot.data![1];
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.only(top: 75),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '$batteryValue%',
                        style: const TextStyle(fontSize: 100),
                      ),
                      BatteryRow(
                        batteryLevel: batteryValue,
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width / 2,
                        segmentColor: batteryColors[
                            (batteryValue / 25 + 0.99).truncate()],
                        charging: isCharging == 0,
                      ),
                    ],
                  ),
                  ),
                ),
              );
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    }
  }
}

class BatteryRow extends StatelessWidget {
  const BatteryRow({
    required this.batteryLevel,
    required this.height,
    required this.width,
    required this.segmentColor,
    required this.charging,
    super.key,
  });
  final int batteryLevel;
  final double height;
  final double width;
  final Color segmentColor;
  final bool charging;

  @override
  Widget build(BuildContext context) {
    if (!charging){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(width:40),
          BatteryIcon(
            batteryLevel: batteryLevel, 
            height: height, 
            width: width, 
            segmentColor: segmentColor, 
            charging: charging,
          ),
          const SizedBox(width:40),
          const Icon(Icons.bolt, size: 100),
        ],
      );
    } else {
      return BatteryIcon(
        batteryLevel: batteryLevel, 
        height: height, 
        width: width, 
        segmentColor: segmentColor, 
        charging: charging,
      );
    }
  }
}

class BatteryIcon extends StatelessWidget {
  const BatteryIcon({
    required this.batteryLevel,
    required this.height,
    required this.width,
    required this.segmentColor,
    required this.charging,
    super.key,
  });
  final int batteryLevel;
  final double height;
  final double width;
  final Color segmentColor;
  final bool charging;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 90 * math.pi / 180,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: height * 0.5,
            height: width * 0.075,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                topLeft: Radius.circular(5),
              ),
              border: Border.all(color: Colors.black, width: 1),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  width: height,
                  height: width * (1 - batteryLevel * 0.01),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                ),
                Container(
                  width: height,
                  height: width * (batteryLevel * 0.01),
                  decoration: BoxDecoration(
                    color: segmentColor,
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
