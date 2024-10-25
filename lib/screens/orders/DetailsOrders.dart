import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/Orders_provider.dart';
// import '../../utils/SpinnerLoader.dart';
import '../../models/OrdersModel.dart';
import '../../utils/Colors_Utils.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsOrderPage extends StatefulWidget {
  final Order order;
  // final Object order;
  const DetailsOrderPage({Key? key, required this.order}) : super(key: key);
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<DetailsOrderPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: height / 5.5,
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
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // automaticallyImplyLeading: false,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.order.orden,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                TextSpan(
                                  text: '  (${widget.order.tipoServicio})',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      RichText(
                        text: TextSpan(
                          text: widget.order.descripcionSolicitud,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 15.0,
                            height: 1.4,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Treatment',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.9),
                          fontSize: 18.0,
                          height: 1.4,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset('assets/icons/ic_answer.png',
                              color: Colors.black, height: 24.0),
                          Image.asset('assets/icons/ic_answer.png',
                              color: Colors.black, height: 24.0),
                          Image.asset('assets/icons/ic_answer.png',
                              color: Colors.black, height: 24.0),
                          Image.asset('assets/icons/ic_answer.png',
                              color: Colors.black, height: 24.0),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // muestra iconos debajo del appBar
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     IconButton(
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //       icon: const Icon(Icons.arrow_back),
            //     ),
            //     Image.asset('assets/icons/ic_home.png',
            //         color: Colors.black, height: 40.0),
            //   ],
            // ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, -5),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                  ),
                ),
                child: Text(
                  'Buy \$${widget.order.monto.toStringAsFixed(0)}',
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
          ],
        ),
      ),
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Text('Orden ID: ${widget.order.descripcionSolicitud}'),
      //     SizedBox(height: 8),
      //     Text('Descripción: ${widget.order.monto}'),
      //     // Agrega aquí más campos según el modelo de Order
      //   ],
      // ),
    );
  }
}
