import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/PagosModel.dart';
import '../../providers/Orders_provider.dart';
import '../../utils/Colors_Utils.dart';
import '../../utils/SpinnerLoader.dart';
// import 'package:provider/provider.dart';
// import '../../providers/Auth_provider.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  void initState() {
    super.initState();
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider.getPayments();
  }

  String capitalizarPrimeraLetra(String texto) {
    if (texto.isEmpty) {
      return texto;
    }
    return texto[0].toUpperCase() + texto.substring(1);
  }

  String capitalizarFecha(DateTime date) {
    final dia = DateFormat('dd', 'es_ES').format(date);
    final mes = DateFormat('MMMM', 'es_ES').format(date);
    final diaAnio = '$dia de ${capitalizarPrimeraLetra(mes)}';

    return diaAnio;
  }

  Map<String, List<PagosModel>> agruparPagosPorMes(List<PagosModel> pagos) {
    Map<String, List<PagosModel>> pagosAgrupados = {};

    for (var pago in pagos) {
      final mesAnio = DateFormat('MMMM yyyy', 'es_ES').format(pago.datePago);

      if (pagosAgrupados.containsKey(mesAnio)) {
        pagosAgrupados[mesAnio]?.add(pago);
      } else {
        pagosAgrupados[mesAnio] = [pago];
      }
    }

    return pagosAgrupados;
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final pagosAgrupados = agruparPagosPorMes(ordersProvider.pagosData);
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondColor,
      body: ordersProvider.isLoading
          ? const Center(child: Spinner())
          : ordersProvider.pagosData.isNotEmpty
              ? ListView.builder(
                  itemCount: pagosAgrupados.length,
                  itemBuilder: (context, index) {
                    final mesAnio = pagosAgrupados.keys.elementAt(index);
                    final pagosDelMes = pagosAgrupados[mesAnio]!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            capitalizarPrimeraLetra(mesAnio),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.activeBlack,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            itemCount: pagosDelMes.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, pagoIndex) {
                              final pago = pagosDelMes[pagoIndex];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppColors.border),
                                ),
                                color: AppColors.white,
                                elevation: 2,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: AppColors.skyBlue,
                                    child: Icon(
                                      Icons.monetization_on,
                                      color: AppColors.lightText,
                                      size: 30,
                                    ),
                                  ),
                                  // title: Text('Orden: ${pago.orden}'),
                                  title: Text(
                                    '${capitalizarFecha(pago.datePago)} ${pago.datePago.hour}:${pago.datePago.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                  // subtitle: Text("Monto: \$${pago.monto.toStringAsFixed(2)} ${pago.currency}"),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Orden: ${pago.orden}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: AppColors.activeBlack,
                                        ),
                                      ),
                                      Text(
                                        "Monto: \$${pago.monto.toStringAsFixed(2)} ${pago.currency}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: AppColors.activeBlack,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const Text('Aún no hay pagos realizados'),
    );
  }
}
