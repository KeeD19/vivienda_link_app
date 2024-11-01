import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Orders_provider.dart';
import '../../utils/SpinnerLoader.dart';
import 'ChatView.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider
        .getListchatProv(); // Llamar al método getOrders al iniciar la pantalla
  }

  @override
  Widget build(BuildContext context) {
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final spiner = Spinner();

    return Scaffold(
        body: ordersProvider.isLoading
            ? Center(child: spiner)
            : ordersProvider.data.isNotEmpty
                ? ListView.builder(
                    itemCount: ordersProvider.dataChat.length,
                    itemBuilder: (context, index) {
                      final list = ordersProvider.dataChat[index];
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey.shade100,
                          ),
                          child: ListTile(
                            leading:
                                const Icon(Icons.person, color: Colors.grey),
                            title: Text(list.correoProveedor),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatViewPage(
                                    idProveedor: list.idProveedor,
                                    proveedor: list.correoProveedor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  )
                : const Text("No hay proveedores disponibles"));
  }
}
