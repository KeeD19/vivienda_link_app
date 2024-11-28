class ListaChatProv {
  final int idOrden;
  final int idProveedor;
  final int idCliente;
  final String? proveedor;
  final String? cliente;
  final dynamic selfie;
  final String? correoProveedor;
  final String? correoCliente;

  ListaChatProv({
    required this.idOrden,
    required this.idProveedor,
    required this.idCliente,
    required this.proveedor,
    required this.cliente,
    required this.selfie,
    required this.correoProveedor,
    required this.correoCliente,
  });

  factory ListaChatProv.fromJson(Map<String, dynamic> json) {
    return ListaChatProv(
      idOrden: json['idOrden'],
      idProveedor: json['idProveedor'],
      idCliente: json['idCliente'],
      proveedor: json['proveedor'],
      cliente: json['cliente'],
      selfie: json['selfie'],
      correoProveedor: json['correoProveedor'],
      correoCliente: json['correoCliente'],
    );
  }
}
