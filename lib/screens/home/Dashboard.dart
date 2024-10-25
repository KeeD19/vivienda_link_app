import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Orders_provider.dart';
import '../../utils/SpinnerLoader.dart';
import '../../screens/orders/DetailsOrders.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider
        .getOrders(); // Llamar al método getOrders al iniciar la pantalla
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final _spiner = Spinner();

    return Scaffold(
      // appBar: AppBar(title: Text('Órdenes')),
      body: ordersProvider.isLoading
          ? Center(child: _spiner)
          : ordersProvider.data.isNotEmpty
              ? Column(
                  children: [
                    // header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Container(
                        height: 200,
                        width: double.maxFinite,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 63, 161, 233),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(22),
                            top: Radius.circular(22),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 32, 0, 0),
                              child: Text(
                                "Hello!",
                                style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Image.asset('assets/images/cont1.png'),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Image.asset('assets/images/cont2.png'),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Image.asset('assets/images/cont3.png'),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(22),
                                ),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  // scale: 4.9,
                                  // 'assets/images/new-york-city.jpg',
                                  fit: BoxFit.contain,
                                  width: 500,
                                ),
                              ),
                            ),
                            // Positioned(
                            //   bottom: 1,
                            //   right: 293,
                            //   child: Image.asset('assets/images/block.png'),
                            // ),
                            // Positioned(
                            //   bottom: 1,
                            //   left: 330,
                            //   child: Image.asset('assets/images/box1.png'),
                            // ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                120,
                                20,
                                0,
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  // filled: true,
                                  // fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Color.fromARGB(255, 241, 100, 33),
                                    size: 30,
                                  ),
                                  hoverColor:
                                      const Color.fromARGB(255, 241, 100, 33),
                                  focusColor:
                                      const Color.fromARGB(255, 35, 59, 254),
                                  hintText: "Search..",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //grid view
                    Expanded(
                        child: GridView.builder(
                      itemCount: ordersProvider.data.length,
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 3.4,
                      ),
                      itemBuilder: (context, index) {
                        final order = ordersProvider.data[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsOrderPage(order: order)),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color.fromARGB(40, 158, 158, 158),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'assets/images/logoVivienda.jpeg',
                                      // scale: 0.3,
                                      fit: BoxFit.contain,
                                      width: 100,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 15,
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                    child: ListTile(
                                        title: Text(
                                          order.orden.toUpperCase(),
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        subtitle: Text(
                                          order.proveedor.toUpperCase(),
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
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
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ))
                  ],
                )
              : const Center(child: Text('No hay órdenes')),
    );
  }
}
