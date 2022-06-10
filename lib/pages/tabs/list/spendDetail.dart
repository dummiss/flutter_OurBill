import 'package:flutter/material.dart';

class SpendDetail extends StatefulWidget {
  const SpendDetail({Key? key}) : super(key: key);

  @override
  State<SpendDetail> createState() => _SpendDetailState();
}

class _SpendDetailState extends State<SpendDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('消費細節'),
      ),
    );
  }
}
