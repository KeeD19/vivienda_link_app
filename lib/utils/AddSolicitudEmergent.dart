import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivienda_link_app/models/FilterOptionsModel.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../providers/Orders_provider.dart';
import 'ScaffoldMessengerUtil.dart';
import 'SpinnerLoader.dart';
import 'SquareInfo.dart';
import 'TimerCard.dart';

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
  String rechazado = "";
  int idSolicitud = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    statusController.dispose();
    super.dispose();
  }

  String _Lugar(String pais, String estado, String mpo) {
    return "$mpo, $estado, $pais";
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: AppColors.backgroundSecondColor,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Estas por enviar una solicitud',
                  style: TextStyle(
                    color: AppColors.backgroundColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                _timerActive
                    ? TimerCard(
                        initialSeconds: 600,
                        // initialSeconds: 10,
                        description: 'Espera mientras se confirma el servicio',
                        options: widget.options,
                        onTimerEnd: () {
                          rechazado = "Intenta con otro proveedor";
                          ordersProvider.updatestatusSolicitud(idSolicitud);
                          debugPrint('¡El temporizador ha terminado!');
                        },
                      )
                    : const Center(),
                const SizedBox(height: 10),
                squareInfo(icon: Icons.app_settings_alt_outlined, title: "Servicio:", desc: widget.options.nombreServicio, type: "Icon", selfie: ""),
                const SizedBox(height: 10),
                squareInfo(icon: Icons.monetization_on, title: "Monto:", desc: widget.options.precioTotal.toStringAsFixed(2), type: "Icon", selfie: ""),
                const SizedBox(height: 10),
                squareInfo(icon: Icons.monetization_on, title: "Proveedor:", desc: widget.options.nombreProvedor, type: "Selfie", selfie: widget.options.selfie),
                const SizedBox(height: 10),
                squareInfo(icon: Icons.location_on_rounded, title: "Lugar del servicio:", desc: _Lugar(widget.options.cobertura['pais'], widget.options.cobertura['estado'], widget.options.cobertura['municipio']), type: "Icon", selfie: ""),
                rechazado != ""
                    ? Text(
                        rechazado,
                        style: const TextStyle(
                          color: AppColors.errorColor,
                        ),
                      )
                    : const Center(),
                const SizedBox(height: 20),
                ordersProvider.isLoading
                    ? const Center(
                        child: Spinner(),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (rechazado == "") {
                              DateTime now = DateTime.now();
                              String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                              await ordersProvider.saveSolicitud(widget.options.idServicio, widget.options.idProveedor, widget.options.cobertura['idCobertura'], formattedDate);
                              idSolicitud = ordersProvider.idSolicitud;
                              if (ordersProvider.errorMessage.isEmpty == true) {
                                // _startTimer(idSolicitud);
                                _timerActive = true;
                              } else {
                                showCustomSnackBar(context, ordersProvider.errorMessage, isError: true);
                              }
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orangeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                          child: const Text(
                            "Aceptar",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: AppColors.activeBlack,
                size: 35,
              ),
              onPressed: () {
                if (idSolicitud != 0) {
                  ordersProvider.updatestatusSolicitud(idSolicitud);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
