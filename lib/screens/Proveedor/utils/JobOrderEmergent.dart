import 'package:flutter/material.dart';
import '../../../utils/Colors_Utils.dart';

class JobAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const JobAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onReject,
          child: const Text(
            'Rechazar',
            style: TextStyle(color: AppColors.errorColor),
          ),
        ),
        ElevatedButton(
          onPressed: onAccept,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.orangeColor),
          child: const Text(
            'Aceptar',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      ],
    );
  }
}
