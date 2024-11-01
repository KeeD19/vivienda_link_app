import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';
import '../../models/category_model.dart';
import '../../models/data/plant_data.dart';
import '../../providers/Orders_provider.dart';
import '../../utils/SpinnerLoader.dart';
import '../../screens/orders/DetailsOrders.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<DashboardPage> {
  final TextEditingController _SearchController = TextEditingController();
  int selectId = 0;
  int activePage = 0;
  @override
  void initState() {
    super.initState();
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider
        .getOrders(); // Llamar al método getOrders al iniciar la pantalla
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsOrderPage(order: order)));
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
                      image: const DecorationImage(
                          image: AssetImage('assets/images/logoVivienda.jpeg'),
                          fit: BoxFit.cover,
                          scale: 0.5),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
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
                  width: screenWidth * 0.8,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.backgroundColor),
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
                    children: [
                      SizedBox(
                        height: 45.0,
                        width: screenWidth * 0.67,
                        child: TextField(
                          controller: _SearchController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                          ),
                          onChanged: (value) => value,
                        ),
                      ),
                      Image.asset(
                        'assets/icons/search.png',
                        height: 25,
                      )
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.01),
                Container(
                  height: 45.0,
                  width: screenWidth * 0.11,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.backgroundColor.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Image.asset(
                    'assets/icons/adjust.png',
                    color: Colors.white,
                    height: 25,
                  ),
                ),
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
                  for (int i = 0; i < categories.length; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() => selectId = categories[i].id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              categories[i].name,
                              style: TextStyle(
                                color: selectId == categories[i].id
                                    ? AppColors.backgroundColor
                                    : Colors.black.withOpacity(0.7),
                                fontSize: 16.0,
                              ),
                            ),
                            if (selectId == categories[i].id)
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
          ordersProvider.isLoading
              ? const Center(child: Spinner())
              : ordersProvider.data.isNotEmpty
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
                            padding: const EdgeInsets.only(
                                right: 10), // Espacio entre tarjetas
                            child: slider(order),
                          );
                          // return slider(order);
                        },
                      ),
                    )
                  : const Center(),
          SizedBox(height: screenHeight * 0.020),
          Padding(
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
          ),
          SizedBox(height: screenHeight * 0.020),
          SizedBox(
            height: screenHeight * 0.15,
            width: screenWidth * 0.99,
            child: ListView.builder(
              itemCount: populerPlants.length,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 20.0),
              scrollDirection: Axis.horizontal,
              itemBuilder: (itemBuilder, index) {
                return Container(
                  width: 200.0,
                  margin: const EdgeInsets.only(right: 20, bottom: 10),
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
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            populerPlants[index].imagePath,
                            width: 70,
                            height: 70,
                          ),
                          const SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                populerPlants[index].name,
                                style: TextStyle(
                                  color: AppColors.backgroundColor
                                      .withOpacity(0.7),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '\$${populerPlants[index].price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: AppColors.backgroundColor
                                      .withOpacity(0.4),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: CircleAvatar(
                          backgroundColor: AppColors.blueSecondColor,
                          radius: 15,
                          child: Image.asset(
                            'assets/icons/add.png',
                            color: Colors.white,
                            height: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ]),
      ),
    ));
  }
}
