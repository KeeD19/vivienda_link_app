import 'package:vivienda_link_app/models/CoberturasModel.dart';
import 'package:vivienda_link_app/models/ServiciosModel.dart';

class ServiciosPopularModel {
  final int idProveedor;
  final String nombreProvedor;
  final selfie;
  final int minHoras;
  final double estrellas;
  final List<ServiciosModel> servicios;
  final List<CoberturasModel> cobertura;

  ServiciosPopularModel({required this.idProveedor, required this.nombreProvedor, required this.selfie, required this.minHoras, required this.estrellas, required this.servicios, required this.cobertura});

  factory ServiciosPopularModel.fromJson(Map<String, dynamic> json) {
    return ServiciosPopularModel(
      idProveedor: json['idProveedor'],
      nombreProvedor: json['nombreProvedor'],
      selfie: json['selfie'],
      minHoras: json['minHoras'],
      estrellas: json['estrellas'],
      servicios: (json['servicios'] as List<dynamic>).map((item) => ServiciosModel.fromJson(item)).toList(),
      cobertura: (json['cobertura'] as List<dynamic>).map((item) => CoberturasModel.fromJson(item)).toList(),
    );
  }
}
