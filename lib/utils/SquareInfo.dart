import 'dart:convert';

import 'package:flutter/material.dart';

import 'Colors_Utils.dart';

class squareInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final String type;
  final dynamic selfie;
  // final VoidCallback onTap;

  const squareInfo({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
    required this.type,
    required this.selfie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.border),
      ),
      color: AppColors.white,
      elevation: 2,
      child: ListTile(
        leading: type == "Icon"
            ? CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.backgroundIcons,
                child: Icon(
                  icon,
                  color: AppColors.blueSecondColor,
                  size: 30,
                ),
              )
            : ClipOval(
                child: Image.memory(
                  base64Decode(selfie),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.activeBlack,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          desc,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.activeBlack,
          ),
        ),
      ),
    );
  }
}
