// import 'dart:convert';
// import 'package:intl/intl.dart';

class Order {
//   Codec<String, String> stringToBase64 = utf8.fuse(base64);
// String encoded = stringToBase64.encode(credentials);      // dXNlcm5hbWU6cGFzc3dvcmQ=
// String decoded = stringToBase64.decode(encoded);          // username:password
  final int idOrdenTrabajo;
  final String orden;
  final int idServicio;
  final String tipoServicio;
  final String direccion;
  final citaFecha;
  final String recomendacion;
  final String descripcionSolicitud;
  final String estado;
  final int idProveedor;
  final int fase;
  final int aprobacion;
  final archivo;
  final String? extencionArchivo;
  final String proveedor;
  final double monto;
  final int estadoPago;
  final comentarios;

  Order(
      {required this.idOrdenTrabajo,
      required this.orden,
      required this.idServicio,
      required this.tipoServicio,
      required this.direccion,
      required this.citaFecha,
      required this.recomendacion,
      required this.descripcionSolicitud,
      required this.estado,
      required this.idProveedor,
      required this.fase,
      required this.aprobacion,
      required this.archivo,
      required this.extencionArchivo,
      required this.proveedor,
      required this.monto,
      required this.estadoPago,
      required this.comentarios});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        idOrdenTrabajo: json['idOrdenTrabajo'],
        orden: json['orden'],
        idServicio: json['idServicio'],
        tipoServicio: json['tipoServicio'],
        direccion: json['direccion'],
        citaFecha: json['citaFecha'],
        recomendacion: json['recomendacion'],
        descripcionSolicitud: json['descripcionSolicitud'],
        estado: json['estado'],
        idProveedor: json['idProveedor'],
        fase: json['fase'],
        aprobacion: json['aprobacion'],
        archivo: json['archivo'],
        extencionArchivo: json['extencionArchivo'],
        proveedor: json['proveedor'],
        monto: json['monto'],
        estadoPago: json['estadoPago'],
        comentarios: json['comentarios']);
  }
}
