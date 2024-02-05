import 'package:flutter/material.dart';
import 'package:smart_pacifier/services/device.dart';
import 'dart:math' as math;

class BatteryLife extends StatefulWidget {
  final BLEDevice? device;

  const BatteryLife({required this.device, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BatteryLifeState();
}

class _BatteryLifeState extends State<BatteryLife> {
  final List<Color> batteryColors = [
    Colors.black,
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.green
  ];

  late Future<int> batteryPercentFuture;

  @override
  void initState() {
    super.initState();
    batteryPercentFuture =
        widget.device?.getBatteryPercentage() ?? Future<int>.value(-1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: batteryPercentFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final int batteryValue = snapshot.data!;
          if (batteryValue == -1) {
            return const Scaffold(
                body: Center(
                    child: Text('No device connected.',
                        textScaleFactor: 2, textAlign: TextAlign.center)));
          } else {
            return Scaffold(
                body: Padding(
              padding: const EdgeInsets.only(top: 75),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    '$batteryValue%',
                    style: const TextStyle(fontSize: 100),
                  ),
                  Transform.rotate(
                    angle: 90 * math.pi / 180,
                    child: BatteryIcon(
                        batteryLevel: batteryValue,
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width / 2,
                        segmentColor: batteryColors[
                            (batteryValue / 25 + 0.99).truncate()]),
                  ),
                ]),
              ),
            ));
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class BatteryIcon extends StatelessWidget {
  final int batteryLevel;
  final double height;
  final double width;
  final Color segmentColor;
  const BatteryIcon(
      {Key? key,
      required this.batteryLevel,
      required this.height,
      required this.width,
      required this.segmentColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: height * 0.5,
          height: width * 0.075,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(5), topLeft: Radius.circular(5)),
              border: Border.all(color: Colors.black, width: 1)),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.black)),
          child: Column(
            children: [
              Container(
                  width: height,
                  height: width * (1 - batteryLevel * 0.01),
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(3)))),
              Container(
                width: height,
                height: width * (batteryLevel * 0.01),
                decoration: BoxDecoration(
                  color: segmentColor,
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
