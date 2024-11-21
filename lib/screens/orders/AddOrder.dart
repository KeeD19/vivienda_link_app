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
        appBar: AppBar(
          title: const Text(
            'Agregar Orden',
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Tipo de servicio:",
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
                                SizedBox(height: screenHeight * 0.02),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                                SizedBox(height: screenHeight * 0.02),
                                SizedBox(
                                    child: TextFormField(
                                  controller: ordenController,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey, width: 0.8)),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.bluePrimaryColor, width: 0.8)),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.red, width: 0.8),
                                      ),
                                      labelText: 'Nombre de la orden',
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
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey, width: 0.8)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.bluePrimaryColor, width: 0.8)),
                                    labelText: 'Dirección',
                                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
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
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey, width: 0.8)),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.bluePrimaryColor, width: 0.8)),
                                      labelText: 'Recomendación',
                                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
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
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey, width: 0.8)),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.bluePrimaryColor, width: 0.8)),
                                      labelText: 'Descripción',
                                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
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
                                            backgroundColor: AppColors.backgroundColor,
                                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30.0),
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
