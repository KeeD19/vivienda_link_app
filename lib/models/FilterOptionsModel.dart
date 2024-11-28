class FilterOptionsModel {
  final int idServicio;
  final String nombreServicio;
  final double monto;
  final int idProveedor;
  final String nombreProvedor;
  final dynamic selfie;
  final int minHoras;
  final double precioTotal;
  final double estrellas;
  final cobertura;

  FilterOptionsModel({
    required this.idServicio,
    required this.nombreServicio,
    required this.monto,
    required this.idProveedor,
    required this.nombreProvedor,
    required this.selfie,
    required this.minHoras,
    required this.precioTotal,
    required this.estrellas,
    required this.cobertura,
  });

  factory FilterOptionsModel.fromJson(Map<String, dynamic> json) {
    return FilterOptionsModel(
      idServicio: json['idServicio'],
      nombreServicio: json['nombreServicio'],
      monto: json['monto'],
      idProveedor: json['idProveedor'],
      nombreProvedor: json['nombreProvedor'],
      selfie: json['selfie'],
      minHoras: json['minHoras'],
      precioTotal: json['precioTotal'],
      estrellas: json['estrellas'],
      cobertura: json['cobertura'],
    );
  }
}
