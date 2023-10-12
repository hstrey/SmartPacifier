import 'package:flutter/material.dart';

class Metrics extends StatelessWidget {
  const Metrics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const SizedBox()
        )
    );
  }
}