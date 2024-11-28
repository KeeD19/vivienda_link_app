import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vivienda_link_app/models/FilterOptionsModel.dart';

import '../utils/Colors_Utils.dart';

class FiltradoServicioWidget extends StatelessWidget {
  final List<FilterOptionsModel> serviciosFiltrados; // Cambiar según el tipo real
  final Function(FilterOptionsModel) onAddSolicitud; // Callback para manejar clics

  FiltradoServicioWidget({
    required this.serviciosFiltrados,
    required this.onAddSolicitud,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.60;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.17,
      child: ListView.separated(
        itemCount: serviciosFiltrados.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 10.0),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final option = serviciosFiltrados[index];
          return ServicioCard(
            servicio: option,
            width: cardWidth,
            onAddSolicitud: () => onAddSolicitud(option),
          );
        },
      ),
    );
  }
}

class ServicioCard extends StatelessWidget {
  final FilterOptionsModel servicio; // Cambiar según el tipo real
  final double width;
  final VoidCallback onAddSolicitud;

  const ServicioCard({
    required this.servicio,
    required this.width,
    required this.onAddSolicitud,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.blueSecondColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Colors.yellow[700]),
                Text(servicio.estrellas.toStringAsFixed(2)),
              ],
            ),
            Row(
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
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        servicio.nombreProvedor,
                        style: TextStyle(
                          color: AppColors.backgroundColor.withOpacity(0.7),
                          fontWeight: FontWeight.w800,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        '\$${servicio.precioTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: AppColors.backgroundColor.withOpacity(0.4),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: AppColors.blueSecondColor,
                  radius: 15,
                  child: GestureDetector(
                    onTap: onAddSolicitud,
                    child: Image.asset(
                      'assets/icons/add.png',
                      color: Colors.white,
                      height: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
