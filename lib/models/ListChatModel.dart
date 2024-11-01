class ListaChatProv {
  final int idOrden;
  final int idProveedor;
  final int idCliente;
  final String proveedor;
  final String correoProveedor;

  ListaChatProv(
      {required this.idOrden,
      required this.idProveedor,
      required this.idCliente,
      required this.proveedor,
      required this.correoProveedor});

  factory ListaChatProv.fromJson(Map<String, dynamic> json) {
    return ListaChatProv(
        idOrden: json['idOrden'],
        idProveedor: json['idProveedor'],
        idCliente: json['idCliente'],
        proveedor: json['proveedor'],
        correoProveedor: json['correoProveedor']);
  }
}
