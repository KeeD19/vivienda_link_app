import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivienda_link_app/models/FilterOptionsModel.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../providers/Orders_provider.dart';
import '../screens/orders/AddOrder.dart';
import 'ScaffoldMessengerUtil.dart';
import 'SpinnerLoader.dart';

class AddSolicitudEmergent extends StatefulWidget {
  final void Function(String status) onSubmitted;
  final FilterOptionsModel options;
  const AddSolicitudEmergent({super.key, required this.onSubmitted, required this.options});

  @override
  // ignore: library_private_types_in_public_api
  _AddSolicitudEmergentState createState() => _AddSolicitudEmergentState();
}

class _AddSolicitudEmergentState extends State<AddSolicitudEmergent> {
  TextEditingController statusController = TextEditingController();
  late Timer _timer;
  bool _timerActive = false;
  int _remainingSeconds = 300; // 5 minutos en segundos
  String rechazado = "";
  int idSolicitud = 0;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensaje recibido en espera: ${message.notification?.title}');
      if (message.notification?.title == "Solicitud Aceptada") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddOrderPage(options: widget.options)));
      }
      if (message.notification?.title == "Solicitud Rechazada") {
        rechazado = "Intenta con otro proveedor";
        // _remainingSeconds = 0;
        _timer.cancel();
        setState(() {});
      }
    });
  }

  void _startTimer(int idSolicitud) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          _timerActive = true;
          if (_remainingSeconds == 0) {
            rechazado = "Intenta con otro proveedor";
            ordersProvider.updatestatusSolicitud(idSolicitud);
          }
        } else {
          _timer.cancel();
          rechazado = "Intenta con otro proveedor";
          ordersProvider.updatestatusSolicitud(idSolicitud);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    statusController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _Lugar(String pais, String estado, String mpo) {
    return "$mpo, $estado, $pais";
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    return AlertDialog(
      title: const Text(
        'Esta por enviar una solicitud',
        style: TextStyle(color: AppColors.backgroundColor),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0), // Espacio lateral
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Servicio: ",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  TextSpan(
                    text: '  ${widget.options.nombreServicio}',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0), // Espacio lateral
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Monto: ",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  TextSpan(
                    text: '  \$${widget.options.precioTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Proveedor: ",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  TextSpan(
                    text: '  ${widget.options.nombreProvedor}',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Lugar del servicio: ",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  TextSpan(
                    text: _Lugar(widget.options.cobertura['pais'], widget.options.cobertura['estado'], widget.options.cobertura['municipio']),
                    // text: '  mexico',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          ordersProvider.isLoading
              ? const Center(
                  child: Spinner(),
                )
              : _timerActive
                  ? Center(
                      child: Text(
                        rechazado == "" ? 'Espera mientras se confirma el servicio: ${_formatTime(_remainingSeconds)}' : rechazado,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.backgroundColor,
                        ),
                      ),
                    )
                  : const Center(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (idSolicitud != 0) {
              await ordersProvider.updatestatusSolicitud(idSolicitud);
            }
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              AppColors.errorColor,
            ),
          ),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.white),
          ),
        ),
        rechazado == ""
            ? TextButton(
                onPressed: () async {
                  DateTime now = DateTime.now();
                  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                  await ordersProvider.saveSolicitud(widget.options.idServicio, widget.options.idProveedor, widget.options.cobertura['idCobertura'], formattedDate);
                  idSolicitud = ordersProvider.idSolicitud;
                  if (ordersProvider.errorMessage.isEmpty == true) {
                    _startTimer(idSolicitud);
                  } else {
                    showCustomSnackBar(context, ordersProvider.errorMessage, isError: true);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppColors.backgroundColor,
                  ),
                ),
                child: const Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : TextButton(
                onPressed: () async {
                  setState(() {
                    widget.onSubmitted("rechazado");
                    Navigator.pop(context);
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppColors.backgroundColor,
                  ),
                ),
                child: const Text(
                  'Reintentar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ],
    );
  }
}
