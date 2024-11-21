class ServiciosModel {
  final int id;
  final String nombreServicio;
  final int idProveedor;
  final double monto;
  final String tipo;

  ServiciosModel(
      {required this.id,
      required this.nombreServicio,
      required this.idProveedor,
      required this.monto,
      required this.tipo});

  factory ServiciosModel.fromJson(Map<String, dynamic> json) {
    return ServiciosModel(
        id: json['id'],
        nombreServicio: json['nombreServicio'],
        idProveedor: json['idProveedor'],
        monto: json['monto'],
        tipo: json['tipo']);
  }
}
