import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vivienda_link_app/screens/perfil/PerfilView.dart';

import '../../providers/Orders_provider.dart';
import '../../utils/Colors_Utils.dart';
import '../../utils/ScaffoldMessengerUtil.dart';

class ContactoEmergenciaPage extends StatefulWidget {
  @override
  _ContactoEmergenciaPageState createState() => _ContactoEmergenciaPageState();
}

class _ContactoEmergenciaPageState extends State<ContactoEmergenciaPage> {
  List<Contact> contactos = [];
  String contactoSeleccionado = "";
  String contactoNumber = "";

  @override
  void initState() {
    super.initState();
    obtenerContactos();
  }

  Future<bool> solicitarPermisosContactos() async {
    var status = await Permission.contacts.request();
    return status.isGranted;
  }

  Future<void> obtenerContactos() async {
    // Solicita permiso para acceder a los contactos
    bool permiso = await solicitarPermisosContactos();
    if (permiso) {
      // Obtiene los contactos
      List<Contact> listaContactos = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
      );
      setState(() {
        contactos = listaContactos;
      });
    } else {
      // Maneja el caso en que el usuario no otorgue permisos
      print("Permiso denegado");
    }
  }

  void guardarContacto(Contact contacto) {
    setState(() {
      contactoSeleccionado = contacto.displayName ?? "Sin nombre";
      contactoNumber = contacto.phones.first.number ?? "Sin numero";
    });

    // Aquí puedes guardar el contacto en tu base de datos o configuración
    print("Contacto guardado: $contactoSeleccionado");
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacto de Emergencia',
          style: TextStyle(
            color: AppColors.blueSecondColor,
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(
          color: AppColors.blueSecondColor,
        ),
      ),
      body: contactos.isEmpty || ordersProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: contactos.length,
              itemBuilder: (context, index) {
                final contacto = contactos[index];
                return ListTile(
                  title: Text(contacto.displayName),
                  subtitle: contacto.phones.isNotEmpty ? Text(contacto.phones.first.number) : const Text("Sin teléfono"),
                  onTap: () => guardarContacto(contacto),
                );
              },
            ),
      floatingActionButton: contactoSeleccionado.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                setState(() async {
                  await ordersProvider.saveContact(contactoSeleccionado, contactoNumber);
                  if (ordersProvider.errorMessage.isEmpty) {
                    showCustomSnackBar(context, ordersProvider.successMessage, isError: false);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilView()));
                  } else {
                    showCustomSnackBar(context, ordersProvider.errorMessage, isError: true);
                  }
                });
              },
              child: Icon(Icons.check),
            )
          : null,
    );
  }
}
