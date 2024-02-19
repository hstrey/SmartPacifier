import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_pacifier/services/device.dart';

class Metrics extends StatefulWidget {
  const Metrics({required this.device, super.key});
  final BLEDevice? device;

  @override
  State<Metrics> createState() => _MetricsState();
}

class _MetricsState extends State<Metrics> {
  late Stream<double>? metricsStream;

  List<ChartData> pressureValues = <ChartData>[];
  int counter = 0;
  
  @override
  void initState(){
    super.initState();
    metricsStream = widget.device?.pressureStream();
  }

  @override
  void dispose(){
    super.dispose();
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
    } else{
      return StreamBuilder<double>(
        stream: metricsStream,
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          if (snapshot.hasData) {
            counter++;
            pressureValues.add(ChartData(counter, snapshot.data!));
            if (pressureValues.length > 6000){
              pressureValues.removeAt(0);
            }
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
                            'Pacifier information from the last 5 minutes',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          SizedBox.square(
                            dimension: MediaQuery.of(context).size.width * 3 / 4 - 60,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: const Color(0xffD9D9D9),
                                borderRadius: BorderRadius.circular(60),
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
                                        MediaQuery.of(context).size.width * 3 / 4 - 180,
                                    width:
                                        MediaQuery.of(context).size.width * 3 / 4 - 60,
                                    child: DecoratedBox(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: SfCartesianChart(
                                        primaryXAxis: CategoryAxis(),
                                        title: ChartTitle(text: 'Pressure'),
                                        //tooltipBehavior: _tooltipBehavior,
                                        series: <LineSeries<ChartData, int>> [
                                          LineSeries(
                                            dataSource: pressureValues,
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y
                                          ),
                                        ]
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
                            width: MediaQuery.of(context).size.width * 3 / 4 - 60,
                            height: MediaQuery.of(context).size.width * 1 / 4,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    'Peak Pressure',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                    ),
                                  ),
                                  Text(
                                    '40 mmHg',
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
                          const SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 3 / 4 - 60,
                            height: MediaQuery.of(context).size.width * 1 / 4,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(20),
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
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    }
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}
