import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivienda_link_app/utils/ReportEmergent.dart';
import '../../models/OrdersModel.dart';
import '../../providers/Orders_provider.dart';
import '../../utils/Colors_Utils.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../utils/QualificationEmergent.dart';
import '../../utils/ScaffoldMessengerUtil.dart';
import '../chat/Comentarios.dart';
// import '../../widgets/pruebas.dart';

class DetailsOrderPage extends StatefulWidget {
  final Order order;
  const DetailsOrderPage({super.key, required this.order});
  @override
  // ignore: library_private_types_in_public_api
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<DetailsOrderPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // var height = MediaQuery.of(context).size.height;
    DateTime fecha = DateTime.parse(widget.order.citaFecha);
    String formattedDate = DateFormat('dd/MM/yyyy').format(fecha);
    return Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: const Text(
            'Detalles de la Orden',
            style: TextStyle(
              color: AppColors.blueSecondColor,
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          iconTheme: const IconThemeData(
            color: AppColors.blueSecondColor,
          ),
        ),
        body: SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: screenHeight / 3.0,
                        width: screenWidth,
                        decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.backgroundColor.withOpacity(1.0),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            image: widget.order.archivo != null
                                ? DecorationImage(
                                    image: MemoryImage(
                                      base64Decode(widget.order
                                          .archivo), // convierte la base64 a bytes
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: AssetImage('assets/images/logo.png'),
                                    fit: BoxFit.cover,
                                  )),
                        // automaticallyImplyLeading: false,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      SizedBox(height: screenHeight * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0), // Espacio lateral
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Orden",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              TextSpan(
                                text: '  ${widget.order.orden}',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0), // Espacio lateral
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Tipo de Servicio",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              TextSpan(
                                text: '  ${widget.order.tipoServicio}',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0), // Espacio lateral
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Dirección:",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              TextSpan(
                                text: '  ${widget.order.direccion}',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0), // Espacio lateral
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Fecha:",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              TextSpan(
                                text: '  $formattedDate',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0), // Espacio lateral
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Recomendación:",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              TextSpan(
                                text: '  ${widget.order.recomendacion}',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0), // Espacio lateral
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Descripción:",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              TextSpan(
                                text: '  ${widget.order.descripcionSolicitud}',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0), // Espacio lateral
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Proveedor:",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              TextSpan(
                                text: '  ${widget.order.proveedor}',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.050),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ComentariosPage(
                                    comentarios: widget.order.comentarios,
                                    receverUserId: widget.order.idCliente,
                                    idOrden: widget.order.idOrdenTrabajo,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset('assets/icons/chat.png',
                                      color: AppColors.bluePrimaryColor,
                                      height: 34.0)
                                ]),
                          ),
                          GestureDetector(
                            onTap: () async {
                              // aqui iria la llamada a la pantalla emergente
                              final scaffoldContext = context;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return QualificationEmergent(
                                    onSubmitted: (rating, comment) async {
                                      await ordersProvider.saveResenia(
                                          widget.order.idProveedor,
                                          rating,
                                          comment);
                                      if (ordersProvider.errorMessage.isEmpty ==
                                          true) {
                                        // ignore: use_build_context_synchronously
                                        showCustomSnackBar(scaffoldContext,
                                            ordersProvider.successMessage,
                                            isError: false);
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        showCustomSnackBar(scaffoldContext,
                                            ordersProvider.errorMessage,
                                            isError: true);
                                      }
                                    },
                                  );
                                },
                              );
                            },
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset('assets/icons/calificacion.png',
                                      color: AppColors.bluePrimaryColor,
                                      height: 34.0)
                                ]),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final scaffoldContext = context;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ReportEmergent(
                                    onSubmitted: (motivoReporte) async {
                                      // Aquí puedes manejar la calificación y comentario enviados.
                                      // print('Comentario: $motivoReporte');
                                      await ordersProvider.saveReporte(
                                          widget.order.idProveedor,
                                          motivoReporte);
                                      if (ordersProvider.errorMessage.isEmpty ==
                                          true) {
                                        // ignore: use_build_context_synchronously
                                        showCustomSnackBar(scaffoldContext,
                                            ordersProvider.successMessage,
                                            isError: false);
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        showCustomSnackBar(scaffoldContext,
                                            ordersProvider.errorMessage,
                                            isError: true);
                                      }
                                    },
                                  );
                                },
                              );
                            },
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset('assets/icons/report.png',
                                      // color: AppColors.bluePrimaryColor,
                                      height: 34.0)
                                ]),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15.0),
                          decoration: BoxDecoration(
                            color: widget.order.estado == "Completada"
                                ? AppColors.backgroundColor
                                : widget.order.estado == "Aceptada"
                                    ? AppColors.successColor
                                    : AppColors.errorColor,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.backgroundColor.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, -5),
                              ),
                            ],
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(60),
                            ),
                          ),
                          child: Text(
                            widget.order.estado,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 18.0,
                              height: 1.4,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      widget.order.monto != 0
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.backgroundColor
                                          .withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, -5),
                                    ),
                                  ],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(60),
                                  ),
                                ),
                                child: Text(
                                  widget.order.estadoPago == 0
                                      ? 'Pay \$${widget.order.monto.toStringAsFixed(0)}'
                                      : 'Payed \$${widget.order.monto.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 18.0,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            )
                          : const Align(),
                    ],
                  ),
                )
              ],
            )));
  }
}
