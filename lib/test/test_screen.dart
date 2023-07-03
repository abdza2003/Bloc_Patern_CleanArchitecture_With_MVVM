import 'package:flutter/material.dart';
import 'package:school_cafteria/test/app_bar_widget.dart';
import 'package:school_cafteria/test/background_test.dart';
import 'package:sizer/sizer.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RPSCustomPainter(),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text('testScreen'),
        ),
      ),
    );
  }
}
