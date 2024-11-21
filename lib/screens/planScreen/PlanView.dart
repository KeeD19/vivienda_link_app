import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/PlanModel.dart';
import '../../providers/Orders_provider.dart';
// import '../../models/meals_list_data.dart';
import '../../utils/Colors_Utils.dart';
import '../../utils/SpinnerLoader.dart';

class MealsListView extends StatefulWidget {
  const MealsListView({Key? key}) : super(key: key);

  @override
  _MealsListViewState createState() => _MealsListViewState();
}

class _MealsListViewState extends State<MealsListView> {
  // List<MealsListData> mealsListData = MealsListData.tabIconsList;

  @override
  void initState() {
    super.initState();
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider.getPlans();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final planes = ordersProvider.dataPlan;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth =
        screenWidth / 2 - 24; // Ajuste de 24 para padding entre tarjetas
    final cardHeight = screenHeight / 3; // 1/3 de la pantalla
    return ordersProvider.isLoading
        ? const Center(child: Spinner())
        : ordersProvider.dataPlan.isNotEmpty
            ? Center(
                child: SizedBox(
                  height: cardHeight,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: planes.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return PlanesView(
                        planesListData: planes[index],
                        width: cardWidth,
                        height: cardHeight,
                      );
                    },
                  ),
                ),
              )
            : Text(ordersProvider.errorMessage);
  }
}

class PlanesView extends StatelessWidget {
  final PlanModel? planesListData;
  final double width;
  final double height;

  const PlanesView({
    Key? key,
    this.planesListData,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      width: screenWidth * 0.4,
      height: height,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.white.withOpacity(0.6),
                    offset: const Offset(1.1, 4.0),
                    blurRadius: 8.0,
                  ),
                ],
                gradient: const LinearGradient(
                  colors: [
                    AppColors.bluePrimaryColor,
                    AppColors.blueSecondColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(54.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 54, left: 16, right: 16, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      planesListData?.name ?? 'No title',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      planesListData?.frequencyPlan ?? 'No frequency plan',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 0.2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      planesListData?.amount != null
                          ? '\$${planesListData!.amount.toStringAsFixed(2)}'
                          : 'No price',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 0.2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
