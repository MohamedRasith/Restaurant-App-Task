import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountdownTimer extends StatefulWidget {
  final Duration duration;
  final Function onTimerFinished;

  const CountdownTimer({
    required this.duration,
    required this.onTimerFinished,
    Key? key,
  }) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _remainingTime = _remainingTime - const Duration(seconds: 1);
      });
      if (_remainingTime == Duration.zero) {
        _timer.cancel();
        widget.onTimerFinished();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_remainingTime.inSeconds} seconds',
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
