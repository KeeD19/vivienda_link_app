class PlanModel {
  final int idPlanes;
  final String nombrePlan;
  final String descripcion;
  final double monto;
  final int tipoPlan;
  final String beneficios;
  final String tipoCliente;

  PlanModel({required this.idPlanes, required this.nombrePlan, required this.descripcion, required this.monto, required this.tipoPlan, required this.beneficios, required this.tipoCliente});

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      idPlanes: json['idPlanes'],
      nombrePlan: json['nombrePlan'],
      descripcion: json['descripcion'],
      monto: json['monto'],
      tipoPlan: json['tipoPlan'],
      beneficios: json['beneficios'],
      tipoCliente: json['tipoCliente'],
    );
  }
}
