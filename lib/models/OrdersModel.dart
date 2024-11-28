import './ComentariosModel.dart';

class Order {
//   Codec<String, String> stringToBase64 = utf8.fuse(base64);
// String encoded = stringToBase64.encode(credentials);      // dXNlcm5hbWU6cGFzc3dvcmQ=
// String decoded = stringToBase64.decode(encoded);          // username:password
  final int idOrdenTrabajo;
  final String orden;
  final int idServicio;
  final String? tipoServicio;
  final String? direccion;
  final dynamic citaFecha;
  final String? recomendacion;
  final String descripcionSolicitud;
  final String estado;
  final int idProveedor;
  final int idCliente;
  final int? fase;
  final int? fasePago;
  final archivo;
  final String? extencionArchivo;
  final String? cliente;
  final String? proveedor;
  // final double? monto;
  // final int? estadoPago;
  final List<Comentarios> comentarios;
  final pago;

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
      required this.idCliente,
      required this.fase,
      required this.fasePago,
      required this.archivo,
      required this.extencionArchivo,
      required this.proveedor,
      required this.cliente,
      // required this.monto,
      // required this.estadoPago,
      required this.comentarios,
      required this.pago});

  @override
  String toString() {
    return 'Order(orden: $orden, description: $tipoServicio)';
  }

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
        idCliente: json['idCliente'],
        fase: json['fase'],
        fasePago: json['fasePago'],
        archivo: json['archivo'] != null ? json['archivo'] : null,
        extencionArchivo: json['extencionArchivo'],
        proveedor: json['proveedor'],
        cliente: json['cliente'],
        // monto: json['monto'],
        // estadgo: json['estadoPago'],
        comentarios: json['comentarios'] != null ? (json['comentarios'] as List<dynamic>).map((item) => Comentarios.fromJson(item)).toList() : [],
        pago: json['pago'] != null ? json['pago'] : null);
  }
}
