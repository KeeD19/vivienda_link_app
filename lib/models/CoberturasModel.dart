class CoberturasModel {
  final int idCobertura;
  final String pais;
  final String estado;
  final String municipio;
  final String cp;
  final int idProveedor;
  final int estatus;

  CoberturasModel({required this.idCobertura, required this.pais, required this.estado, required this.municipio, required this.cp, required this.idProveedor, required this.estatus});

  factory CoberturasModel.fromJson(Map<String, dynamic> json) {
    return CoberturasModel(idCobertura: json['idCobertura'], pais: json['pais'], estado: json['estado'], municipio: json['municipio'], cp: json['cp'], idProveedor: json['idProveedor'], estatus: json['estatus']);
  }
}
