import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';
import '../../providers/Orders_provider.dart';
import '../../utils/AddSolicitudEmergent.dart';
import '../../utils/FilterOptionsEmergent.dart';
import '../../utils/PaymentDialog.dart';
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
  int selectId = 0;
  int activePage = 0;
  String _errorSearch = "";
  bool _searchResults = false;
  @override
  void initState() {
    super.initState();
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider.getOrders();
    ordersProvider.getServicios();
    ordersProvider.getServiciosPopulares();
  }

  Widget slider(order) {
    return SizedBox(
      width: 200, // Tamaño fijo para asegurar uniformidad
      height: 300,
      child: mainOrdersCard(order),
    );
  }

  Widget mainOrdersCard(order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsOrderPage(order: order)));
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              // offset: const Offset(5, 5),
            ),
          ],
          // border: Border.all(color: AppColors.backgroundColor, width: 2),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: 90,
                    width: 140,
                    decoration: BoxDecoration(
                      color: AppColors.blueSecondColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blueSecondColor.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(5, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(25.0),
                      image: const DecorationImage(image: AssetImage('assets/images/logoVivienda.jpeg'), fit: BoxFit.cover, scale: 0.5),
                    ),
                  )),
            ),

            // Positioned(
            //   right: 8,
            //   top: 8,
            //   child: CircleAvatar(
            //     backgroundColor: AppColors.backgroundColor,
            //     radius: 15,
            //     child: Image.asset(
            //       'assets/icons/add.png',
            //       color: Colors.white,
            //       height: 15,
            //     ),
            //   ),
            // ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: ListTile(
                    title: Text(
                      order.orden.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      order.proveedor.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        // fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )),
                // child: Text(
                //   order.orden.toUpperCase(),
                //   style: GoogleFonts.inter(
                //     fontSize: 14,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
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
    final ordenesPropias = ordersProvider.data;
    final serviciosPopulares = ordersProvider.dataServiciosPopulares;
    // selectId = 1;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: ordersProvider.isLoading || ordenesPropias == null || serviciosPopulares == null
            ? const Center(child: Spinner())
            : SizedBox(
                height: screenHeight * 1,
                width: screenWidth * 1,
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20.0),
                      child: Row(
                        children: [
                          Container(
                            height: 45.0,
                            width: screenWidth * 0.9,
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: _errorSearch == "" ? Border.all(color: AppColors.backgroundColor) : Border.all(color: AppColors.errorColor),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.backgroundColor.withOpacity(0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 45.0,
                                  width: screenWidth * 0.65,
                                  child: TextField(
                                    controller: _SearchController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Buscar',
                                    ),
                                    onChanged: (value) => value,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        final scaffoldContext = context;
                                        if (_SearchController.text.isNotEmpty) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return FilterOptionsEmergent(
                                                onSubmitted: (pais, estado, municipio, presupuesto) async {
                                                  await ordersProvider.getServiciosFiltrados(_SearchController.text, pais, estado, municipio, presupuesto);
                                                  if (ordersProvider.errorMessage.isEmpty == true) {
                                                    _searchResults = true;
                                                    _SearchController.text = "";
                                                  } else {
                                                    showCustomSnackBar(scaffoldContext, ordersProvider.errorMessage, isError: true);
                                                    _SearchController.text = "";
                                                  }
                                                },
                                              );
                                            },
                                          );
                                        } else {
                                          _errorSearch = "Se necesita la busqueda";
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.search))
                              ],
                            ),
                          ),
                          // SizedBox(width: screenWidth * 0.01),
                          // Container(
                          //   height: 45.0,
                          //   width: screenWidth * 0.11,
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 10.0),
                          //   decoration: BoxDecoration(
                          //     color: AppColors.backgroundColor,
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: AppColors.backgroundColor
                          //             .withOpacity(0.5),
                          //         blurRadius: 10,
                          //         offset: const Offset(0, 0),
                          //       ),
                          //     ],
                          //     borderRadius: BorderRadius.circular(10.0),
                          //   ),
                          //   child: Image.asset('assets/icons/adjust.png',
                          //       color: Colors.white),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                      width: screenWidth * 0.96,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0; i < ordersProvider.dataServicios.length; i++)
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    selectId = ordersProvider.dataServicios[i].id;
                                    final scaffoldContext = context;
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return FilterOptionsEmergent(
                                          onSubmitted: (pais, estado, municipio, presupuesto) async {
                                            await ordersProvider.getServiciosFiltrados(ordersProvider.dataServicios[i].nombreServicio, pais, estado, municipio, presupuesto);
                                            if (ordersProvider.errorMessage.isEmpty == true) {
                                              _searchResults = true;
                                              _SearchController.text = "";
                                            } else {
                                              showCustomSnackBar(scaffoldContext, ordersProvider.errorMessage, isError: true);
                                              _SearchController.text = "";
                                            }
                                          },
                                        );
                                      },
                                    );
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ordersProvider.dataServicios[i].nombreServicio,
                                        style: TextStyle(
                                          color: selectId == ordersProvider.dataServicios[i].id ? AppColors.backgroundColor : Colors.black.withOpacity(0.7),
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      if (selectId == ordersProvider.dataServicios[i].id)
                                        const CircleAvatar(
                                          radius: 3,
                                          backgroundColor: AppColors.backgroundColor,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    _searchResults == true ? SizedBox(height: screenHeight * 0.020) : const Center(),
                    _searchResults == true
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Resultados',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Image.asset(
                                  'assets/icons/more.png',
                                  color: AppColors.backgroundColor,
                                  height: 20,
                                ),
                              ],
                            ),
                          )
                        : const Center(),
                    _searchResults == true
                        ? SizedBox(
                            height: screenHeight * 0.17,
                            width: screenWidth * 0.99,
                            child: ListView.builder(
                              itemCount: ordersProvider.dataServiciosFiltrados.length,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(left: 10.0),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (itemBuilder, index) {
                                final option = ordersProvider.dataServiciosFiltrados[index];
                                return Container(
                                    width: screenWidth * 0.60,
                                    margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.blueSecondColor.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Positioned(
                                                left: 0,
                                                top: 5,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow[700],
                                                    ),
                                                    Text(option.estrellas.toStringAsFixed(2))
                                                  ],
                                                )),
                                            Row(
                                              children: [
                                                option.selfie != null
                                                    ? ClipOval(
                                                        child: Image.memory(
                                                          base64Decode(option.selfie!),
                                                          width: 60,
                                                          height: 60,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                    : ClipOval(
                                                        child: Image.asset(
                                                          'assets/images/user.png',
                                                          width: 60,
                                                          height: 60,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                const SizedBox(width: 10.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        option.nombreProvedor,
                                                        style: TextStyle(
                                                          color: AppColors.backgroundColor.withOpacity(0.7),
                                                          fontWeight: FontWeight.w800,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2, // Limita el texto a 2 líneas
                                                      ),
                                                      Text(
                                                        '\$${option.precioTotal.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                          color: AppColors.backgroundColor.withOpacity(0.4),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 20,
                                                  bottom: 20,
                                                  child: CircleAvatar(
                                                    backgroundColor: AppColors.blueSecondColor,
                                                    radius: 15,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => AddOrderPage(options: option)));
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
                                                        });
                                                      },
                                                      child: Image.asset(
                                                        'assets/icons/add.png',
                                                        color: Colors.white,
                                                        height: 15,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        )));
                              },
                            ),
                          )
                        : const Center(),
                    SizedBox(height: screenHeight * 0.020),
                    ordersProvider.data.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Mis Trabajos',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Image.asset(
                                  'assets/icons/more.png',
                                  color: AppColors.backgroundColor,
                                  height: 20,
                                ),
                              ],
                            ),
                          )
                        : const Center(),
                    SizedBox(height: screenHeight * 0.020),
                    ordersProvider.data.isNotEmpty
                        ? SizedBox(
                            // height: 200,
                            height: screenHeight * 0.3,
                            width: screenWidth * 0.99,
                            child: ListView.builder(
                              itemCount: ordersProvider.data.length,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (itemBuilder, index) {
                                final order = ordersProvider.data[index];
                                // bool active = index == activePage;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10), // Espacio entre tarjetas
                                  child: slider(order),
                                );
                                // return slider(order);
                              },
                            ),
                          )
                        : const Center(),
                    SizedBox(height: screenHeight * 0.020),
                    ordersProvider.dataServiciosPopulares.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Popular',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Image.asset(
                                  'assets/icons/more.png',
                                  color: AppColors.backgroundColor,
                                  height: 20,
                                ),
                              ],
                            ),
                          )
                        : const Center(),
                    SizedBox(height: screenHeight * 0.020),
                    ordersProvider.dataServiciosPopulares.isNotEmpty
                        ? SizedBox(
                            height: screenHeight * 0.19,
                            width: screenWidth * 0.99,
                            child: ListView.builder(
                              itemCount: ordersProvider.dataServiciosPopulares.length,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(left: 10.0),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (itemBuilder, index) {
                                final optionPopular = ordersProvider.dataServiciosPopulares[index];
                                return Container(
                                    width: screenWidth * 0.60,
                                    margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.blueSecondColor.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Positioned(
                                                left: 0,
                                                top: 5,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow[700],
                                                    ),
                                                    Text(optionPopular.estrellas.toStringAsFixed(2))
                                                  ],
                                                )),
                                            Row(
                                              children: [
                                                optionPopular.selfie != null
                                                    ? ClipOval(
                                                        child: Image.memory(
                                                          base64Decode(optionPopular.selfie!),
                                                          width: 60,
                                                          height: 60,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                    : ClipOval(
                                                        child: Image.asset(
                                                          'assets/images/user.png',
                                                          width: 60,
                                                          height: 60,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                const SizedBox(width: 10.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        optionPopular.nombreProvedor,
                                                        style: TextStyle(
                                                          color: AppColors.backgroundColor.withOpacity(0.7),
                                                          fontWeight: FontWeight.w800,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                      Text(
                                                        'Minimo de horas: ${optionPopular.minHoras}',
                                                        style: TextStyle(
                                                          color: AppColors.backgroundColor.withOpacity(0.4),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 11.0,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 20,
                                                  bottom: 20,
                                                  child: CircleAvatar(
                                                    backgroundColor: AppColors.blueSecondColor,
                                                    radius: 15,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        // setState(() {
                                                        //   // Navigator.push(context, MaterialPageRoute(builder: (context) => AddOrderPage(options: option)));
                                                        //   showDialog(
                                                        //     context: context,
                                                        //     barrierDismissible: false,
                                                        //     builder: (context) {
                                                        //       return PaymentPage(); // Monto de prueba
                                                        //     },
                                                        //   );
                                                        // });
                                                      },
                                                      child: Image.asset(
                                                        'assets/icons/add.png',
                                                        color: Colors.white,
                                                        height: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )));
                              },
                            ),
                          )
                        : const Center()
                  ]),
                ),
              ));
  }
}
