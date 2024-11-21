class PagosModel {
  final int idPagos;
  final dynamic monto;
  final int idProveedor;
  final int idCliente;
  final int idOrden;
  final String orden;
  final int estadoPago;
  final String currency;
  final DateTime datePago;

  PagosModel({required this.idPagos, required this.monto, required this.idProveedor, required this.idCliente, required this.idOrden, required this.orden, required this.estadoPago, required this.currency, required this.datePago});

  factory PagosModel.fromJson(Map<String, dynamic> json) {
    return PagosModel(
        idPagos: json['idPagos'],
        monto: json['monto'],
        idProveedor: json['idProveedor'],
        idCliente: json['idCliente'],
        idOrden: json['idOrden'],
        orden: json['orden'],
        estadoPago: json['estadoPago'],
        currency: json['currency'],
        datePago: DateTime.parse(json['datePago']));
  }
}
