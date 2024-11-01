class Comentarios {
  final int idComentario;
  final String comentario;
  final int idUsuario;
  final int idTrabajo;

  Comentarios({
    required this.idComentario,
    required this.comentario,
    required this.idUsuario,
    required this.idTrabajo,
  });

  @override
  String toString() {
    return 'Comentarios(comentario: $comentario, id: $idComentario, idUsuario: $idUsuario)';
  }

  factory Comentarios.fromJson(Map<String, dynamic> json) {
    return Comentarios(
        idComentario: json['idComentario'],
        comentario: json['comentario'],
        idUsuario: json['idUsuario'],
        idTrabajo: json['idTrabajo']);
  }
}