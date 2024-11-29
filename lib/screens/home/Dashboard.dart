// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vivienda_link_app/providers/Provedor_provider.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';
import '../../providers/Auth_provider.dart';
import '../../providers/Orders_provider.dart';
import '../../utils/AddSolicitudEmergent.dart';
import '../../utils/CardOption.dart';
import '../../utils/DetailsPopularOption.dart';
import '../../utils/FilterOptionsEmergent.dart';
import '../../utils/ScaffoldMessengerUtil.dart';
import '../../utils/SpinnerLoader.dart';
import '../../screens/orders/DetailsOrders.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<DashboardPage> {
  // ignore: non_constant_identifier_names
  final TextEditingController _SearchController = TextEditingController();
  // TextEditingController paisController = TextEditingController();
  final TextEditingController paisController = TextEditingController(text: "Costa Rica");
  TextEditingController provinciaController = TextEditingController(text: "San Jose");
  TextEditingController distritoController = TextEditingController();
  TextEditingController presupuestoController = TextEditingController();
  String? canton;
  final _formKey = GlobalKey<FormState>();
  int selectId = 0;
  int activePage = 0;
  String _errorSearch = "";
  bool _searchResults = false;
  @override
  void initState() {
    super.initState();

    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provProvider = Provider.of<ProvedorProvider>(context, listen: false);

    authProvider.getTypeUser();
    if (authProvider.typeUser == 3) {
      canton = "Santa Ana";
      ordersProvider.getOrders();
      ordersProvider.getServicios();
      ordersProvider.getServiciosPopulares();
    } else {
      provProvider.getOrders();
    }
  }

  Widget slider(order, double width) {
    return SizedBox(
      width: width,
      height: 200,
      child: mainOrdersCard(order, width),
    );
  }

  Widget mainOrdersCard(order, double width) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsOrderPage(idOrder: order.idOrdenTrabajo)));
      },
      child: Container(
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: AppColors.backgroundIcons,
          boxShadow: [
            BoxShadow(
              color: AppColors.backgroundIcons.withOpacity(0.05),
              blurRadius: AppColors.border,
            ),
          ],
          borderRadius: BorderRadius.circular(AppColors.border),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: 100,
                    width: width,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundIcons,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: AppColors.border,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(AppColors.border),
                      image: const DecorationImage(image: AssetImage('assets/images/logoVivienda.jpeg'), fit: BoxFit.cover, scale: 0.6),
                    ),
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: ListTile(
                    title: Text(
                      order.orden,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    subtitle: Text(
                      order.proveedor != null ? order.proveedor.toUpperCase() : order.cliente.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.white,
                        // fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    // selectId = 1;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.47;
    final authProvider = Provider.of<AuthProvider>(context);
    final provedoresProvider = Provider.of<ProvedorProvider>(context);
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: ordersProvider.isLoading || authProvider.isLoading
            ? const Center(child: Spinner())
            : authProvider.typeUser == 3
                ? SizedBox(
                    height: screenHeight,
                    width: screenWidth * 1,
                    child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20.0),
                          child: _buildSearchBar(screenWidth),
                        ),
                        SizedBox(
                          height: screenHeight * 0.052,
                          width: screenWidth * 0.96,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: ordersProvider.dataServicios.map((servicio) {
                                return _buildServiceItem(
                                  context,
                                  servicio.id,
                                  servicio.nombreServicio,
                                  selectId,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        _searchResults == true ? SizedBox(height: screenHeight * 0.020) : const Center(),
                        _searchResults == true
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: _buildTittleItem('Resultados'),
                              )
                            : const Center(),
                        _searchResults == true
                            ? SizedBox(
                                width: screenWidth,
                                height: screenHeight * 0.32,
                                child: ListView.separated(
                                  itemCount: ordersProvider.dataServiciosFiltrados.length,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                                  itemBuilder: (context, index) {
                                    final option = ordersProvider.dataServiciosFiltrados[index];
                                    return ServicioCard(
                                      type: "filtro",
                                      servicio: option,
                                      width: cardWidth,
                                      height: screenHeight * 0.5,
                                      onAddSolicitud: () => {
                                        // _showBottomSheet(orden.idProveedor, context, "Reporte");
                                        setState(() {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return AddSolicitudEmergent(
                                                onSubmitted: (status) async {},
                                                options: option,
                                              );
                                            },
                                          );
                                        })
                                      },
                                    );
                                  },
                                ),
                              )
                            : const Center(),
                        SizedBox(height: screenHeight * 0.010),
                        ordersProvider.data.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: _buildTittleItem('Mis Trabajos'),
                              )
                            : const Center(),
                        SizedBox(height: screenHeight * 0.010),
                        ordersProvider.data.isNotEmpty
                            ? SizedBox(
                                height: screenHeight * 0.3,
                                width: screenWidth,
                                child: ListView.builder(
                                  itemCount: ordersProvider.data.length,
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (itemBuilder, index) {
                                    final order = ordersProvider.data[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10), // Espacio entre tarjetas
                                      child: slider(order, cardWidth),
                                    );
                                    // return slider(order);
                                  },
                                ),
                              )
                            : const Center(),
                        SizedBox(height: screenHeight * 0.010),
                        ordersProvider.dataServiciosPopulares.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: _buildTittleItem('Popular'),
                              )
                            : const Center(),
                        SizedBox(height: screenHeight * 0.020),
                        ordersProvider.dataServiciosPopulares.isNotEmpty
                            ? SizedBox(
                                width: screenWidth,
                                height: screenHeight * 0.32,
                                child: ListView.separated(
                                  itemCount: ordersProvider.dataServiciosPopulares.length,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                                  itemBuilder: (context, index) {
                                    final option = ordersProvider.dataServiciosPopulares[index];
                                    return ServicioCard(
                                      type: "popular",
                                      servicio: option,
                                      width: cardWidth,
                                      height: screenHeight * 0.5,
                                      onAddSolicitud: () => {
                                        setState(() {
                                          setState(() {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPopularOption(options: option)));
                                          });
                                        })
                                      },
                                    );
                                  },
                                ),
                              )
                            : const Center()
                      ]),
                    ),
                  )
                : SizedBox(
                    height: screenHeight * 1,
                    width: screenWidth * 1,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          provedoresProvider.orderData.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: _buildTittleItem('Mis Trabajos'),
                                )
                              : const Center(),
                          SizedBox(height: screenHeight * 0.020),
                          provedoresProvider.orderData.isNotEmpty
                              ? SizedBox(
                                  // height: 200,
                                  height: screenHeight * 0.3,
                                  width: screenWidth * 0.99,
                                  child: ListView.builder(
                                    itemCount: provedoresProvider.orderData.length,
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (itemBuilder, index) {
                                      final order = provedoresProvider.orderData[index];
                                      // bool active = index == activePage;
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 10), // Espacio entre tarjetas
                                        child: slider(order, cardWidth),
                                      );
                                      // return slider(order);
                                    },
                                  ),
                                )
                              : const Center(),
                        ],
                      ),
                    )));
  }

  Widget _buildSearchBar(double screenWidth) {
    return Container(
      height: 55.0,
      width: screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: AppColors.fondSearchColor,
        border: _errorSearch == "" ? Border.all(color: AppColors.backgroundColor) : Border.all(color: AppColors.errorColor),
        boxShadow: const [
          BoxShadow(
            color: AppColors.backgroundColor,
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: _SearchController,
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Buscar',
                hintStyle: TextStyle(color: AppColors.white),
              ),
              style: const TextStyle(color: AppColors.white),
            ),
          ),
          IconButton(
            onPressed: () => _onSearch(),
            icon: const Icon(Icons.search, color: AppColors.white),
          ),
        ],
      ),
    );
  }

  void _onSearch() {
    setState(() {
      if (_SearchController.text.isNotEmpty) {
        _showBottomSheet(context, _SearchController.text);
      } else {
        _errorSearch = "Se necesita la busqueda";
      }
    });
  }

  Widget _buildServiceItem(BuildContext context, int serviceId, String serviceName, int selectedId) {
    final isSelected = selectedId == serviceId;

    return GestureDetector(
      onTap: () => _onServiceSelected(context, serviceId, serviceName),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade300 : AppColors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              serviceName,
              style: TextStyle(
                color: isSelected ? AppColors.skyBlue : AppColors.activeBlack,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onServiceSelected(BuildContext context, int serviceId, String serviceName) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    setState(() {
      selectId = serviceId;
      final scaffoldContext = context;
      _showBottomSheet(context, serviceName);
    });
  }

  Widget _buildTittleItem(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        fontSize: 22.0,
      ),
    );
  }

  void _showBottomSheet(BuildContext contexto, String servicio) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return FractionallySizedBox(
              heightFactor: 0.75,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "Filtro de busqueda",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: paisController,
                                readOnly: true,
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: "País",
                                  border: const OutlineInputBorder(),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Colors.red, width: 0.8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: provinciaController,
                                readOnly: true,
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: "Provincia",
                                  border: const OutlineInputBorder(),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Colors.red, width: 0.8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Canton:',
                                style: TextStyle(
                                  color: AppColors.activeBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              DropdownButton<String>(
                                value: canton,
                                isExpanded: true,
                                items: [
                                  'Santa Ana',
                                  'Escazu',
                                ].map((String provincia) {
                                  return DropdownMenuItem<String>(
                                    value: provincia,
                                    child: Text(provincia),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setModalState(() {
                                    canton = newValue;
                                  });
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: distritoController,
                                decoration: InputDecoration(
                                  labelText: "Distrito",
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
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: presupuestoController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  labelText: "Presupuesto",
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
                            ],
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await ordersProvider.getServiciosFiltrados(
                                  servicio,
                                  paisController.text,
                                  provinciaController.text,
                                  canton!,
                                  presupuestoController.text,
                                  distritoController.text,
                                );
                                if (ordersProvider.errorMessage.isEmpty == true) {
                                  _searchResults = true;
                                  distritoController.clear();
                                  presupuestoController.clear();
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pop(context);
                                  showCustomSnackBar(contexto, ordersProvider.errorMessage, isError: true);
                                }
                              } else {
                                // Algún campo no es válido
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Por favor, completa todos los campos')),
                                );
                              }
                              // final ordersProvider = Provider.of<OrdersProvider>(contexto, listen: false);
                              // if (type == "Calificacion") {
                              //   if (localRating != 0 && _formKey.currentState!.validate()) {
                              //     Navigator.pop(context);
                              //     await ordersProvider.saveResenia(idProvedor, localRating, commentController.text);
                              //     if (ordersProvider.errorMessage.isEmpty == true) {
                              //       showCustomSnackBar(contexto, ordersProvider.successMessage, isError: false);
                              //     } else {
                              //       showCustomSnackBar(contexto, ordersProvider.errorMessage, isError: true);
                              //     }
                              //     commentController.clear();
                              //     localRating = 0;
                              //     selectedRating = 0;
                              //   } else {
                              //     Navigator.pop(context);
                              //     showCustomSnackBar(contexto, "Todos los campos son requeridos", isError: true);
                              //   }
                              // } else {
                              //   if (_formKey.currentState!.validate()) {
                              //     Navigator.pop(context);
                              //     await ordersProvider.saveReporte(idProvedor, commentController.text);
                              //     if (ordersProvider.errorMessage.isEmpty == true) {
                              //       showCustomSnackBar(contexto, ordersProvider.successMessage, isError: false);
                              //     } else {
                              //       showCustomSnackBar(contexto, ordersProvider.errorMessage, isError: true);
                              //     }
                              //     commentController.clear();
                              //     localRating = 0;
                              //     selectedRating = 0;
                              //   } else {
                              //     Navigator.pop(context);
                              //     showCustomSnackBar(contexto, "Escribe tu reporte", isError: true);
                              //   }
                              // }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orangeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            ),
                            child: const Text(
                              "Buscar",
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
                        distritoController.clear();
                        presupuestoController.clear();
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
