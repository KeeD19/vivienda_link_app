class ClientModel {
  final int idCliente;
  final String nombre;
  final String telefono;
  final String correo;

  ClientModel(
      {required this.idCliente,
      required this.nombre,
      required this.telefono,
      required this.correo});

  @override
  String toString() {
    return 'Cliente(Cliente: $nombre, id: $idCliente, telefono: $telefono, correo: $correo)';
  }

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
        idCliente: json['idCliente'],
        nombre: json['nombre'],
        telefono: json['telefono'],
        correo: json['correo']);
  }
}
