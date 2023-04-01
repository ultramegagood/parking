import 'dart:async';
import 'package:flutter/material.dart';

class ParkingTimerWidget extends StatefulWidget {
  final DateTime paymentDateAndTime;
  final int hours;
  ParkingTimerWidget({required this.paymentDateAndTime, required this.hours});

  @override
  _ParkingTimerWidgetState createState() => _ParkingTimerWidgetState();
}

class _ParkingTimerWidgetState extends State<ParkingTimerWidget> {
  late Timer _timer;
  late Duration _timeRemaining;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _endTime = widget.paymentDateAndTime.add(Duration(hours: widget.hours));
    _timeRemaining = _calculateTimeRemaining();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _timeRemaining = _calculateTimeRemaining();
      });
    });
  }

  Duration _calculateTimeRemaining() {
    DateTime now = DateTime.now();
    Duration timeRemaining = _endTime.difference(now);
    return timeRemaining.isNegative ? Duration() : timeRemaining;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Осталось времени: ${_timeRemaining.inHours} часов ${_timeRemaining.inMinutes.remainder(60)} минут',
          style: TextStyle(fontSize: 18),
        ),

      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
