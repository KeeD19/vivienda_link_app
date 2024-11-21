// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivienda_link_app/providers/Orders_provider.dart';
import 'package:vivienda_link_app/screens/home/Home.dart';
import 'package:vivienda_link_app/screens/orders/DetailsOrders.dart';
import 'package:vivienda_link_app/utils/HeadUtil.dart';
import '../../providers/Notification_Provider.dart';
import '../../utils/SpinnerLoader.dart';
import '../chat/ChatView.dart';

class NotificacionesPage extends StatefulWidget {
  const NotificacionesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  @override
  void initState() {
    super.initState();
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.getNotificaciones();
  }

  String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'unos segundos';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inDays < 30) {
      return '${difference.inDays ~/ 7} semana${difference.inDays ~/ 7 > 1 ? 's' : ''}';
    } else if (difference.inDays < 365) {
      return '${difference.inDays ~/ 30} mes${difference.inDays ~/ 30 > 1 ? 'es' : ''}';
    } else {
      return '${difference.inDays ~/ 365} año${difference.inDays ~/ 365 > 1 ? 's' : ''}';
    }
  }

  void _onMenuOptionSelected(BuildContext context, String option, int id, int idModulo, int idNotificacion, int status) async {
    final rootContext = context;
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    if (status == 0) {
      await notificationProvider.updateNotificacion(idNotificacion);
    }

    if (notificationProvider.errorMessage.isEmpty) {
      if (option == "Solicitud de Servicio") {
        if (mounted) {
          Navigator.push(
            rootContext,
            MaterialPageRoute(builder: (rootContext) => const HomePage()),
          );
        }
      }
      if (option == "Mensajes") {
        await ordersProvider.getDetailMessagge(idModulo);
        if (mounted) {
          Navigator.push(
            rootContext,
            MaterialPageRoute(builder: (rootContext) => ChatViewPage(idProveedor: ordersProvider.idProvedor, proveedor: ordersProvider.correoProv)),
          );
        }
      }
      if (option == "Comentarios") {
        await ordersProvider.getOrder(idModulo);
        if (mounted) {
          Navigator.push(rootContext, MaterialPageRoute(builder: (rootContext) => DetailsOrderPage(order: ordersProvider.dataorden)));
        }
      }
      if (option == "Ordenes de Trabajo") {
        await ordersProvider.getOrder(idModulo);
        if (mounted) {
          Navigator.push(rootContext, MaterialPageRoute(builder: (rootContext) => DetailsOrderPage(order: ordersProvider.dataorden)));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(notificationProvider.errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final rootContext = context;
    return Scaffold(
      appBar: const HeadUtil(),
      body: notificationProvider.isLoading || ordersProvider.isLoading
          ? const Center(child: Spinner())
          : notificationProvider.dataNotificaciones.isNotEmpty
              ? ListView.builder(
                  itemCount: notificationProvider.dataNotificaciones.length,
                  itemBuilder: (context, index) {
                    final notificacion = notificationProvider.dataNotificaciones[index];
                    return NotificacionCard(
                      titulo: notificacion.tipo,
                      descripcion: notificacion.cuerpo,
                      hora: notificacion.status == 0 ? 'Hace ${timeAgo(DateTime.parse(notificacion.create_at))}' : 'Visto hace ${timeAgo(DateTime.parse(notificacion.update_at))}',
                      leido: notificacion.status == 0 ? false : true,
                      id: notificacion.idNotificacion,
                      tipo: notificacion.tipo,
                      idNotificacion: notificacion.idNotificacion,
                      idModulo: notificacion.idModulo,
                      onTap: () {
                        _onMenuOptionSelected(rootContext, notificacion.tipo, notificacion.idNotificacion, notificacion.idModulo, notificacion.idNotificacion, notificacion.status);
                      },
                    );
                  },
                )
              : Text(notificationProvider.errorMessage),
    );
  }
}

class NotificacionCard extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String hora;
  final bool leido;
  final int id;
  final String tipo;
  final int idNotificacion;
  final int idModulo;
  final VoidCallback onTap;

  const NotificacionCard({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.hora,
    required this.leido,
    required this.id,
    required this.tipo,
    required this.idNotificacion,
    required this.idModulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        color: leido ? Colors.grey[200] : Colors.white,
        child: ListTile(
          leading: Icon(
            leido ? Icons.notifications : Icons.notifications_active,
            color: leido ? Colors.grey : Colors.blue,
          ),
          title: Text(
            titulo,
            style: TextStyle(
              fontWeight: leido ? FontWeight.normal : FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  descripcion,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  hora,
                  style: const TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
          trailing: !leido
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                )
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}
