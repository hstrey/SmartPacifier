import 'package:flutter/material.dart';

class Metrics extends StatelessWidget {
  Metrics({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Text(title)
        )
    );
  }
}