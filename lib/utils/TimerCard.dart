// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';

import '../models/FilterOptionsModel.dart';
import '../screens/orders/AddOrder.dart';

class TimerCard extends StatefulWidget {
  final int initialSeconds;
  final FilterOptionsModel options;
  final String description;
  final VoidCallback onTimerEnd;

  const TimerCard({
    Key? key,
    required this.initialSeconds,
    required this.description,
    required this.onTimerEnd,
    required this.options,
  }) : super(key: key);

  @override
  State<TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _startTimer();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print('Mensaje recibido en espera: ${message.notification?.title}');
      if (message.notification?.title == "Solicitud Aceptada") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddOrderPage(options: widget.options)));
      }
      if (message.notification?.title == "Solicitud Rechazada") {
        _remainingSeconds = 0;
        _startTimer();
        widget.onTimerEnd();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        widget.onTimerEnd();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Temporizador
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                _formatTime(_remainingSeconds),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Descripción
            Expanded(
              child: Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
