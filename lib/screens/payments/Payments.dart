import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/PagosModel.dart';
import '../../providers/Orders_provider.dart';
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

  Map<String, List<PagosModel>> agruparPagosPorMes(List<PagosModel> pagos) {
    Map<String, List<PagosModel>> pagosAgrupados = {};

    for (var pago in pagos) {
      final mesAnio = "${pago.datePago.month.toString().padLeft(2, '0')}/${pago.datePago.year}";
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
      body: ordersProvider.isLoading
          ? const Center(child: Spinner())
          : ordersProvider.pagosData.length > 0
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
                            mesAnio,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            itemCount: pagosDelMes.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, pagoIndex) {
                              final pago = pagosDelMes[pagoIndex];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                elevation: 2,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Text(
                                      pago.datePago.day.toString(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text('Orden: ${pago.orden}'),
                                  subtitle: Text("Monto: \$${pago.monto.toStringAsFixed(2)} ${pago.currency}"),
                                  trailing: Text(
                                    "${pago.datePago.hour}:${pago.datePago.minute.toString().padLeft(2, '0')}",
                                    style: TextStyle(color: Colors.grey.shade600),
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
              : Text('Error: ${ordersProvider.errorMessage}'),
    );
  }
}
