import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:vivienda_link_app/models/OrdersModel.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';
import 'package:vivienda_link_app/utils/SpinnerLoader.dart';

import '../providers/Orders_provider.dart';
import '../screens/home/Home.dart';
import 'ScaffoldMessengerUtil.dart';

class PaymentPage extends StatefulWidget {
  final Order order;
  final double monto;
  const PaymentPage({super.key, required this.order, required this.monto});
  @override
  // ignore: library_private_types_in_public_api
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late TextEditingController cardNumberController;
  late TextEditingController expiryMonthController;
  late TextEditingController expiryYearController;
  late TextEditingController cvcController;
  late TextEditingController paymentController;
  late GlobalKey<FormState> paymentForm;
  Map<String, dynamic>? paymentIntentData;

  @override
  void initState() {
    super.initState();
    cardNumberController = TextEditingController();
    expiryMonthController = TextEditingController();
    expiryYearController = TextEditingController();
    cvcController = TextEditingController();
    paymentController = TextEditingController();
    paymentForm = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondColor,
      body: ordersProvider.isLoading
          ? const Center(child: Spinner())
          : Padding(
              // padding: const EdgeInsets.all(16.0),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.06, // 5% del ancho de la pantalla
              ),
              child: Form(
                key: paymentForm,
                child: Column(
                  // shrinkWrap: true,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Image.asset(
                        'assets/images/cardPay.png',
                        width: 300,
                        height: 300,
                        // fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        var paymentAmount = (widget.monto * 100);
                        makePayment(
                          amount: paymentAmount.round(),
                          currency: "USD",
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orangeColor,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppColors.border),
                        ),
                      ),
                      child: const Text(
                        'Pagar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> makePayment({required int amount, required String currency}) async {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    try {
      await ordersProvider.createPaymentIntent(amount, widget.order.idProveedor, widget.order.idOrdenTrabajo);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: ordersProvider.clientSecret,
          merchantDisplayName: "Pago de prueba", // Define el nombre del comerciante
          style: ThemeMode.light,
          appearance: const PaymentSheetAppearance(
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Color(0xFF000000), // Color de fondo
                ),
              ),
            ),
          ),
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      debugPrint('Pago exitoso');
      await ordersProvider.updateOrden(widget.order.idOrdenTrabajo);
      if (ordersProvider.errorMessage.isEmpty) {
        showCustomSnackBar(context, ordersProvider.successMessage, isError: false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        showCustomSnackBar(context, "No se pudo realizar el pago, intenta con otra tarjeta por favor", isError: true);
      }
    } catch (e) {
      debugPrint('Error creating payment method: $e');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then(
            (value) {},
          );
    } on StripeException catch (e) {
      debugPrint('Payment failed: ${e.error.localizedMessage}');
    } catch (e) {
      debugPrint('An unexpected error occurred: $e');
    }
  }
}
