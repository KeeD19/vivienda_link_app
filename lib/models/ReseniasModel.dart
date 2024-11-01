class ReseniasModel {
  final int idResenias;
  final String descripcion;
  final int estrellas;
  final create_at;
  final int idCliente;
  final int idProveedor;
  final int activo;

  ReseniasModel({
    required this.idResenias,
    required this.descripcion,
    required this.estrellas,
    required this.create_at,
    required this.idCliente,
    required this.idProveedor,
    required this.activo,
  });

  factory ReseniasModel.fromJson(Map<String, dynamic> json) {
    return ReseniasModel(
        idResenias: json['idResenias'],
        descripcion: json['descripcion'],
        estrellas: json['estrellas'],
        create_at: json['create_at'],
        idCliente: json['idCliente'],
        idProveedor: json['idProveedor'],
        activo: json['activo']);
  }
}
