class ProvedorModel {
  final int idProvedor;
  final String nombre;
  final String nombreEmpresarial;
  final String telefono;
  final String correo;
  final selfie;

  ProvedorModel({
    required this.idProvedor,
    required this.nombre,
    required this.nombreEmpresarial,
    required this.telefono,
    required this.selfie,
    required this.correo,
  });

  factory ProvedorModel.fromJson(Map<String, dynamic> json) {
    return ProvedorModel(
      idProvedor: json['idProvedor'],
      nombre: json['nombre'],
      nombreEmpresarial: json['nombreEmpresarial'],
      telefono: json['telefono'],
      selfie: json['selfie'],
      correo: json['correo'],
    );
  }
}
