import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_pacifier/services/device.dart';

class Metrics extends StatefulWidget {
  const Metrics({required this.device, super.key});
  final BLEDevice? device;
  static List<ChartData> pressureValues = <ChartData>[];
  static int counter = 0;
  static double maxPressure = -1000;
  static List<double> samplingData = <double>[];
  static double roomPressure = 0;

  static void reset(){
    pressureValues = <ChartData>[];
    counter = 0;
    maxPressure = -1000;
    samplingData = <double>[];
    roomPressure = 0;
  }

  @override
  State<Metrics> createState() => _MetricsState();
}

class _MetricsState extends State<Metrics> {
  late Stream<double>? metricsStream;
  late StreamSubscription<double>? metricsSubscription;
  
  @override
  void initState(){
    super.initState();
    metricsStream = widget.device?.pressureStream();
    metricsSubscription = metricsStream?.listen((double data) {
      Metrics.counter++;
      if (Metrics.counter <= 20){
        Metrics.samplingData += <double>[data];
      }
      else{
        final DateTime now = DateTime.now();

        Metrics.pressureValues.add(ChartData(now.hour*360 + now.minute*60 + now.second, Metrics.roomPressure-data));
      }
      if (Metrics.counter  == 20){
        int maxCount = 0;
        for(double value in Metrics.samplingData){
          int modeCount = 0;
          for(double value2 in Metrics.samplingData){
            if(value == value2) {
              modeCount++;
            }
          }
          if(modeCount > maxCount){
            maxCount = modeCount;
            Metrics.roomPressure = value;
          }
        }
      }
      if (Metrics.counter % 20 == 0){
        update();
      }
      if (Metrics.pressureValues.length > 1200){
        Metrics.pressureValues.removeAt(0);
      }
      Metrics.maxPressure = -1000;
      for(ChartData data in Metrics.pressureValues){
        if(data.y>Metrics.maxPressure) {
          Metrics.maxPressure = data.y;
        }
      }
    });
  }

  void update(){
    setState(() {});
  }

  @override
  void dispose(){
    super.dispose();
    metricsSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if(metricsStream == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No device connected.',
            textScaleFactor: 2,
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (Metrics.counter <= 20) {
      return const CircularProgressIndicator();
    } else{
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Pacifier information from the last minute',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 9 / 10,
                      height: MediaQuery.of(context).size.width * 9 / 10 + 100,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 15),
                            const SizedBox(
                              height: 45,
                              child: Text(
                                'Waveform',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.width * 5 / 6,
                              width:
                                  MediaQuery.of(context).size.width * 5 / 6,
                              child: DecoratedBox(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  title: ChartTitle(text: 'Pressure'),
                                  series: <LineSeries<ChartData, int>> [
                                    LineSeries<ChartData, int>(
                                      dataSource: Metrics.pressureValues,
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y,
                                      animationDuration: 0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 5 / 6,
                      height: MediaQuery.of(context).size.width * 1 / 3,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            const Text(
                              'Maximum Pressure',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                            Text(
                              '${Metrics.maxPressure.toStringAsFixed(2)} mmHg',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 5 / 6,
                      height: MediaQuery.of(context).size.width * 1 / 3,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              'Suck Frequency',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                            Text(
                              '1 Suck / Second',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}
