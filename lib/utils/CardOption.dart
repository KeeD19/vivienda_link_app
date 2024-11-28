import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vivienda_link_app/models/FilterOptionsModel.dart';

import 'Colors_Utils.dart';

class ServicioCard extends StatelessWidget {
  final String type;
  final dynamic servicio;
  final double width;
  final double height;
  final VoidCallback onAddSolicitud;

  const ServicioCard({
    required this.servicio,
    required this.type,
    required this.width,
    required this.height,
    required this.onAddSolicitud,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.blueSecondColor.withOpacity(0.1),
            blurRadius: AppColors.border,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: servicio.selfie != null
                  ? Image.memory(
                      base64Decode(servicio.selfie!),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/user.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: AppColors.skyBlue),
                Text(servicio.estrellas.toStringAsFixed(2)),
              ],
            ),
            const SizedBox(height: 7),
            Text(
              servicio.nombreProvedor,
              style: const TextStyle(
                color: AppColors.activeBlack,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 3),
            Text(
              'Minimo de horas ${servicio.minHoras}',
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 3),
            type == "filtro"
                ? Text(
                    '\$${servicio.precioTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.activeBlack,
                      fontSize: 12.0,
                    ),
                  )
                : const Center(),
            const SizedBox(height: 7),
            GestureDetector(
              onTap: onAddSolicitud,
              child: const Text(
                'Pedir servicio',
                style: TextStyle(
                  color: AppColors.orangeColor,
                  fontSize: 14.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
