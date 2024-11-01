class Mensajes {
  final int idMensajes;
  final int idProveedor;
  final int idCliente;
  final String contenido;
  final created_at;
  final String status;
  final String identificador;

  Mensajes({
    required this.idMensajes,
    required this.idProveedor,
    required this.idCliente,
    required this.contenido,
    required this.created_at,
    required this.status,
    required this.identificador,
  });

  factory Mensajes.fromJson(Map<String, dynamic> json) {
    return Mensajes(
      idMensajes: json['idMensajes'],
      idProveedor: json['idProveedor'],
      idCliente: json['idCliente'],
      contenido: json['contenido'],
      created_at: json['created_at'],
      status: json['status'],
      identificador: json['identificador'],
    );
  }
}
