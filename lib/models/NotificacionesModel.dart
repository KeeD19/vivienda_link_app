class NotificacionesModel {
  final int idNotificacion;
  final int idUsuario;
  final String tipo;
  final String cuerpo;
  final int idModulo;
  final int status;
  final String identificador;
  final create_at;
  final update_at;

  NotificacionesModel({
    required this.idNotificacion,
    required this.idUsuario,
    required this.tipo,
    required this.cuerpo,
    required this.idModulo,
    required this.status,
    required this.identificador,
    required this.create_at,
    required this.update_at,
  });

  factory NotificacionesModel.fromJson(Map<String, dynamic> json) {
    return NotificacionesModel(
        idNotificacion: json['idNotificacion'],
        idUsuario: json['idUsuario'],
        tipo: json['tipo'],
        cuerpo: json['cuerpo'],
        idModulo: json['idModulo'],
        status: json['status'],
        identificador: json['identificador'],
        create_at: json['create_at'],
        update_at: json['update_at']);
  }
}
