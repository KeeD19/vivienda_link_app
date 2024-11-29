// ignore_for_file: use_build_context_synchronously

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivienda_link_app/providers/Auth_provider.dart';
import 'package:vivienda_link_app/providers/Provedor_provider.dart';
import '../../providers/Orders_provider.dart';
import '../../utils/Colors_Utils.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../utils/ScaffoldMessengerUtil.dart';
import '../../utils/SpinnerLoader.dart';
import '../Proveedor/utils/JobOrderEmergent.dart';
import '../Proveedor/utils/StatusOrderEmergent.dart';
import '../chat/Comentarios.dart';
// import '../../widgets/pruebas.dart';

class DetailsOrderPage extends StatefulWidget {
  final int idOrder;
  const DetailsOrderPage({super.key, required this.idOrder});
  @override
  // ignore: library_private_types_in_public_api
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<DetailsOrderPage> {
  int selectedRating = 0;
  TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // late var orden = null;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final provProvider = Provider.of<ProvedorProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    debugPrint('id de la orden: ${widget.idOrder}');
    // final provProvider = Provider.of<ProvedorProvider>(context, listen: false);

    authProvider.getTypeUser();
    if (authProvider.typeUser == 3) {
      ordersProvider.getOrder(widget.idOrder);
    } else {
      provProvider.getOrder(widget.idOrder);
    }
  }

  String _formatDate(date) {
    DateTime fecha = DateTime.parse(date);
    String formattedDate = DateFormat('dd/MM/yyyy').format(fecha);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final provProvider = Provider.of<ProvedorProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // debugPrint('pago ${widget.order.pago}');
    // var height = MediaQuery.of(context).size.height;
    final orden = ordersProvider.dataorden ?? provProvider.dataorden;
    // debugPrint('provedor: ${orden.proveedor}');

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondColor,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const Text(
          'Detalles de la Orden',
          style: TextStyle(
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
      ),
      body: ordersProvider.isLoading || provProvider.isLoading || orden == null
          ? const Center(child: Spinner())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: screenHeight / 3.0,
                    width: screenWidth,
                    decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.backgroundColor.withOpacity(1.0),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        image: orden.archivo != null
                            ? DecorationImage(
                                image: MemoryImage(
                                  base64Decode(orden.archivo), // convierte la base64 a bytes
                                ),
                                fit: BoxFit.cover,
                              )
                            : const DecorationImage(
                                image: AssetImage('assets/images/logo.png'),
                                fit: BoxFit.cover,
                              )),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  GestureDetector(
                    onTap: () async {
                      if (orden.proveedor == null) {
                        final result = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return EstadoSelectorDialog(
                              initialEstado: orden.estado,
                              file: orden.archivo ?? "",
                            );
                          },
                        );

                        if (result != null) {
                          final nuevoEstado = result['estado'];
                          final nuevaEvidencia = result['evidencia'];
                          await provProvider.updateOrder(nuevoEstado, nuevaEvidencia, orden.idOrdenTrabajo);
                          if (provProvider.errorMessage.isEmpty) {
                            showCustomSnackBar(context, "La orden se actualizó de manera correcta", isError: false);
                            await loadData();
                            setState(() {});
                          } else {
                            showCustomSnackBar(context, provProvider.errorMessage, isError: true);
                          }
                        }
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 28,
                          color: orden.estado == "Completada" ? AppColors.successColor : AppColors.grey,
                        ),
                        Text(
                          orden.estado,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0), // Espacio lateral
                    child: Text(
                      orden.pago != null ? "Pagado: \$${orden.pago['monto']?.toStringAsFixed(2)}" : "No pagado",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: screenWidth * 0.03),
                      CustomButton(
                        iconPath: 'assets/icons/chat.png',
                        text: 'Comentarios',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ComentariosPage(
                                comentarios: orden.comentarios,
                                receverUserId: orden.idCliente,
                                idOrden: orden.idOrdenTrabajo,
                                identificador: orden.proveedor != null ? 'Cliente' : 'Proveedor',
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      orden.proveedor != null
                          ? orden.estado == "Completada"
                              ? CustomButton(
                                  iconPath: 'assets/icons/calificacion.png',
                                  text: 'Reseña',
                                  onTap: () {
                                    _showBottomSheet(orden.idProveedor, context, "Calificacion");
                                  },
                                )
                              : const Center()
                          : const Center(),
                      SizedBox(width: screenWidth * 0.03),
                      orden.proveedor != null
                          ? CustomButton(
                              iconPath: 'assets/icons/portapapeles.png',
                              text: 'Reportar',
                              onTap: () {
                                _showBottomSheet(orden.idProveedor, context, "Reporte");
                              },
                            )
                          : const Center(),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  DescriptionView(
                    title: 'Orden',
                    description: orden.orden,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  DescriptionView(
                    title: 'Tipo de Servicio',
                    description: orden.tipoServicio,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  DescriptionView(
                    title: 'Dirección',
                    description: orden.direccion,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  DescriptionView(
                    title: 'Fecha',
                    description: _formatDate(orden.citaFecha),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  SizedBox(height: screenHeight * 0.01),
                  DescriptionView(
                    title: 'Recomendación',
                    description: orden.recomendacion,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  DescriptionView(
                    title: 'Descripción',
                    description: orden.descripcionSolicitud,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  DescriptionView(
                    title: orden.proveedor != null ? "Proveedor:" : "Cliente:",
                    description: orden.proveedor != null ? '  ${orden.proveedor}' : '  ${orden.cliente}',
                  ),
                ],
              ),
            ),
    );
  }

  void _showBottomSheet(int idProvedor, BuildContext contexto, String type) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        int localRating = selectedRating;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return FractionallySizedBox(
              heightFactor: 0.65,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          type == "Calificacion" ? "Califica a tu proveedor" : "Reportar proveedor",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          type == "Calificacion" ? "Selecciona una calificación" : "Escribe las quejas de tu proveedor",
                          textAlign: TextAlign.justify,
                        ),
                        type == "Calificacion"
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return IconButton(
                                    icon: Icon(
                                      index < localRating ? Icons.star : Icons.star_border,
                                      color: Colors.yellow[700],
                                      size: 45,
                                    ),
                                    onPressed: () {
                                      setModalState(() {
                                        localRating = index + 1;
                                        selectedRating = localRating;
                                      });
                                    },
                                  );
                                }),
                              )
                            : const Center(),
                        const SizedBox(height: 10),
                        type == "Calificacion"
                            ? commentController.text == ""
                                ? const Text(
                                    "Comentarios",
                                    textAlign: TextAlign.justify,
                                  )
                                : const Center()
                            : const Center(),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: commentController,
                            maxLines: type == "Calificacion" ? 6 : 10,
                            decoration: InputDecoration(
                              labelText: type == "Calificacion" ? 'Comentario' : "Reporte",
                              border: const OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.red, width: 0.8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final ordersProvider = Provider.of<OrdersProvider>(contexto, listen: false);
                              if (type == "Calificacion") {
                                if (localRating != 0 && _formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                  await ordersProvider.saveResenia(idProvedor, localRating, commentController.text);
                                  if (ordersProvider.errorMessage.isEmpty == true) {
                                    showCustomSnackBar(contexto, ordersProvider.successMessage, isError: false);
                                  } else {
                                    showCustomSnackBar(contexto, ordersProvider.errorMessage, isError: true);
                                  }
                                  commentController.clear();
                                  localRating = 0;
                                  selectedRating = 0;
                                } else {
                                  Navigator.pop(context);
                                  showCustomSnackBar(contexto, "Todos los campos son requeridos", isError: true);
                                }
                              } else {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                  await ordersProvider.saveReporte(idProvedor, commentController.text);
                                  if (ordersProvider.errorMessage.isEmpty == true) {
                                    showCustomSnackBar(contexto, ordersProvider.successMessage, isError: false);
                                  } else {
                                    showCustomSnackBar(contexto, ordersProvider.errorMessage, isError: true);
                                  }
                                  commentController.clear();
                                  localRating = 0;
                                  selectedRating = 0;
                                } else {
                                  Navigator.pop(context);
                                  showCustomSnackBar(contexto, "Escribe tu reporte", isError: true);
                                }
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
                              "Enviar",
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
                    top: 5,
                    right: 5,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 30.0,
                      ),
                      onPressed: () {
                        commentController.clear();
                        localRating = 0;
                        selectedRating = 0;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class CustomButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.iconPath,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.skyBlue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              color: Colors.white,
              height: 12.0,
            ),
            const SizedBox(width: 5.0),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class DescriptionView extends StatelessWidget {
  final String title;
  final String description;

  const DescriptionView({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 80,
        ),
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
