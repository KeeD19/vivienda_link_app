import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Auth_provider.dart';
import '../../providers/Orders_provider.dart';
import '../../providers/Provedor_provider.dart';
import '../../utils/Colors_Utils.dart';
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
    loadData();
  }

  Future<void> loadData() async {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final provProvider = Provider.of<ProvedorProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    authProvider.getTypeUser();
    if (authProvider.typeUser == 3) {
      ordersProvider.getListchatProv();
    } else {
      provProvider.getListchatProv();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final provProvider = Provider.of<ProvedorProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final dataChat = authProvider.typeUser == 3 ? ordersProvider.dataChat : provProvider.dataChat;

    return Scaffold(
        backgroundColor: AppColors.backgroundSecondColor,
        body: ordersProvider.isLoading || provProvider.isLoading
            ? const Center(child: Spinner())
            : dataChat.isNotEmpty
                ? ListView.builder(
                    itemCount: dataChat.length,
                    itemBuilder: (context, index) {
                      final list = dataChat[index];
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppColors.border),
                            color: AppColors.white,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Alineación del contenido
                            leading: list.selfie != null
                                ? ClipOval(
                                    child: Image.memory(
                                      base64Decode(list.selfie),
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const CircleAvatar(
                                    radius: 35,
                                    child: Icon(Icons.person, color: AppColors.grey),
                                  ),
                            title: Text(
                              list.correoProveedor ?? list.correoCliente,
                              style: const TextStyle(fontSize: 16), // Opcional, para ajustar tamaño
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatViewPage(
                                    idProveedor: list.idProveedor,
                                    idCliente: list.idCliente,
                                    proveedor: list.correoProveedor ?? list.correoCliente,
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
