import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Metrics extends StatelessWidget {
    
  const Metrics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          'Pacifier information from the last 15 minutes',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        SizedBox.square(
                          dimension:
                              MediaQuery.of(context).size.width * 3 / 4 - 60,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xffD9D9D9),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                const SizedBox(
                                  height: 45,
                                  child: Text(
                                    'Waveform',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                            3 /
                                            4 -
                                        180,
                                    width: MediaQuery.of(context).size.width *
                                            3 /
                                            4 -
                                        60,
                                    child: DecoratedBox(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: SfCartesianChart(
                                        primaryXAxis: CategoryAxis(),
                                        title: ChartTitle(text: 'Pressure'),
                                        //tooltipBehavior: _tooltipBehavior,
                                        //series: <LineSeries<data, String>> [
                                        // LineSeries(dataSource: data, xValueMapper: Class data, yValueMapper: Class data)
                                      ),
                                    )),
                                const SizedBox(height: 60)
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Peak Pressure',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 28),
                                    ),
                                    Text(
                                      '40 mmHg',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ])),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Suck Frequency',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 28),
                                    ),
                                    Text(
                                      '1 Hour',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ])),
                        ),
                      ],
                    )),
              ),
            )));
  }
}
