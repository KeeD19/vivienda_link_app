// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vivienda_link_app/screens/home/Home.dart';
import '../../models/FilterOptionsModel.dart';
import '../../providers/Orders_provider.dart';
import '../../utils/Colors_Utils.dart';
import '../../utils/PaymentDialog.dart';
import '../../utils/ScaffoldMessengerUtil.dart';
import '../../utils/SpinnerLoader.dart';
import '../../utils/SquareInfo.dart';

class AddOrderPage extends StatefulWidget {
  final FilterOptionsModel options;
  const AddOrderPage({super.key, required this.options});
  @override
  // ignore: library_private_types_in_public_api
  _AddOrdersState createState() => _AddOrdersState();
}

class _AddOrdersState extends State<AddOrderPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController ordenController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController citaController = TextEditingController();
  TextEditingController recomendacionController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String formattedDate = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: AppColors.backgroundSecondColor,
        appBar: AppBar(
          title: const Text(
            'Agregar Orden',
            style: TextStyle(
              color: AppColors.white,
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          iconTheme: const IconThemeData(
            color: AppColors.white,
          ),
        ),
        body: SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    margin: const EdgeInsets.all(10),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.zero, // Opcional: Bordes redondeados
                    ),
                    color: AppColors.backgroundSecondColor,
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Column(children: [
                                squareInfo(icon: Icons.app_settings_alt_outlined, title: "Servicio:", desc: widget.options.nombreServicio, type: "Icon", selfie: ""),
                                SizedBox(height: screenHeight * 0.01),
                                squareInfo(icon: Icons.monetization_on, title: "Proveedor:", desc: widget.options.nombreProvedor, type: "Selfie", selfie: widget.options.selfie),
                                SizedBox(height: screenHeight * 0.01),
                                SizedBox(
                                    child: TextFormField(
                                  controller: ordenController,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppColors.border), borderSide: const BorderSide(color: Colors.grey, width: 0.8)),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppColors.border), borderSide: const BorderSide(color: AppColors.bluePrimaryColor, width: 0.8)),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(AppColors.border),
                                        borderSide: const BorderSide(color: Colors.red, width: 0.8),
                                      ),
                                      labelText: 'Nombre de la orden',
                                      filled: true,
                                      fillColor: AppColors.white,
                                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Este campo es obligatorio';
                                    }
                                    return null;
                                  },
                                )),
                                SizedBox(height: screenHeight * 0.01),
                                SizedBox(
                                    child: TextFormField(
                                  controller: direccionController,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppColors.border), borderSide: const BorderSide(color: Colors.grey, width: 0.8)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppColors.border), borderSide: const BorderSide(color: AppColors.bluePrimaryColor, width: 0.8)),
                                    labelText: 'Dirección',
                                    filled: true,
                                    fillColor: AppColors.white,
                                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppColors.border),
                                      borderSide: const BorderSide(color: Colors.red, width: 0.8),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Este campo es obligatorio';
                                    }
                                    return null;
                                  },
                                )),
                                SizedBox(height: screenHeight * 0.01),
                                SizedBox(
                                    child: TextFormField(
                                  controller: citaController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'Fecha del trabajo',
                                    filled: true,
                                    fillColor: AppColors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppColors.border)),
                                    suffixIcon: const Icon(Icons.calendar_today),
                                  ),
                                  onTap: () async {
                                    DateTime? selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now().add(const Duration(days: 1)),
                                      firstDate: DateTime(2024),
                                      lastDate: DateTime(2100),
                                    );

                                    if (selectedDate != null) {
                                      formattedDate = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                      citaController.text = formattedDate;
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor selecciona una fecha';
                                    }
                                    DateTime selectedDate = DateTime.parse(value);
                                    DateTime today = DateTime.now();
                                    if (selectedDate.isBefore(DateTime(today.year, today.month, today.day))) {
                                      return 'La fecha debe ser posterior al día de hoy';
                                    }
                                    return null;
                                  },
                                )),
                                SizedBox(height: screenHeight * 0.01),
                                SizedBox(
                                    child: TextFormField(
                                  controller: recomendacionController,
                                  maxLines: 2,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppColors.border), borderSide: const BorderSide(color: Colors.grey, width: 0.8)),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppColors.border), borderSide: const BorderSide(color: AppColors.bluePrimaryColor, width: 0.8)),
                                      labelText: 'Recomendación',
                                      filled: true,
                                      fillColor: AppColors.white,
                                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(AppColors.border),
                                        borderSide: const BorderSide(color: Colors.red, width: 0.8),
                                      )),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Este campo es obligatorio';
                                    }
                                    return null;
                                  },
                                )),
                                SizedBox(height: screenHeight * 0.01),
                                SizedBox(
                                    child: TextFormField(
                                  controller: descController,
                                  maxLines: 3,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppColors.border), borderSide: const BorderSide(color: Colors.grey, width: 0.8)),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppColors.border), borderSide: const BorderSide(color: AppColors.bluePrimaryColor, width: 0.8)),
                                      labelText: 'Descripción',
                                      filled: true,
                                      fillColor: AppColors.white,
                                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(AppColors.border),
                                        borderSide: const BorderSide(color: Colors.red, width: 0.8),
                                      )),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Este campo es obligatorio';
                                    }
                                    return null;
                                  },
                                )),
                                SizedBox(height: screenHeight * 0.03),
                                ordersProvider.isLoading
                                    ? const Center(
                                        child: Spinner(),
                                      )
                                    : SizedBox(
                                        width: screenWidth,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                              setState(() {});
                                              await ordersProvider.saveOrder(
                                                  ordenController.text, widget.options.idServicio, direccionController.text, citaController.text, recomendacionController.text, descController.text, widget.options.idProveedor);
                                              if (ordersProvider.errorMessage.isEmpty) {
                                                showCustomSnackBar(context, ordersProvider.successMessage, isError: false);
                                                // Mostrar pantalla emergente para el pago
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) {
                                                    return PaymentPage(order: ordersProvider.dataorden, monto: widget.options.precioTotal); // Monto de prueba
                                                  },
                                                );
                                              } else {
                                                showCustomSnackBar(context, ordersProvider.errorMessage, isError: true);
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.orangeColor,
                                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(AppColors.border),
                                            ),
                                          ),
                                          child: const Text(
                                            'Agregar',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(height: screenHeight * 0.01),
                              ]),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
