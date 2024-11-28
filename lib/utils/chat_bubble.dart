import 'package:flutter/material.dart';
import '../utils/Colors_Utils.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String color;
  const ChatBubble({super.key, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: screenWidth * 2 / 3, // Máximo 2/3 del ancho de la pantalla
      ),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: color == "send" ? AppColors.greySecond : AppColors.blueTh,
        ),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, color: AppColors.activeBlack),
        ),
      ),
    );
  }
}
