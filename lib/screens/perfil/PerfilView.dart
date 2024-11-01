import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';

import '../../providers/Orders_provider.dart';
import '../../utils/HeadUtil.dart';
import '../../utils/ScaffoldMessengerUtil.dart';
import '../../utils/SpinnerLoader.dart';
// import 'package:healwiz/themes/theme.dart';
// import 'package:http/http.dart' as http;

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PerfilViewState createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  bool _onEdit = false;
  bool _onEditPass = false;
  String _errorName = "";
  String _errorPhone = "";
  String _errorEmail = "";
  bool isObscure = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passOldController = TextEditingController();
  TextEditingController passNewController = TextEditingController();
  @override
  void initState() {
    super.initState();
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    // ordersProvider.getDataPerfil();
    ordersProvider.getDataPerfil().then((_) {
      // Asigna el valor una vez que los datos estén disponibles
      setState(() {
        nameController.text = ordersProvider.dataClient.nombre;
        phoneController.text = ordersProvider.dataClient.telefono;
        emailController.text = ordersProvider.dataClient.correo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final client = ordersProvider.dataClient;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: const HeadUtil(),
        body: ordersProvider.isLoading
            ? const Center(child: Spinner())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: _onEdit == false
                        ? screenHeight * 0.25
                        : screenHeight * 0.5,
                    width: screenWidth,
                    child: Card(
                      // color: AppColors.backgroundColor.withOpacity(0.01),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Alinear a la izquierda
                        children: [
                          SizedBox(
                              height: screenHeight * 0.02), // Espacio superior
                          SizedBox(
                              height: _onEdit == false
                                  ? screenHeight * 0.1
                                  : screenHeight * 0.4,
                              child: _onEdit == false
                                  ? ListTile(
                                      leading: ClipOval(
                                        child: Image.asset(
                                          'assets/images/user.png',
                                          width:
                                              60, // Tamaño ajustado del ícono redondo
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(
                                        client.nombre,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(client.telefono),
                                      contentPadding: EdgeInsets
                                          .zero, // Ajusta el relleno si es necesario
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              SizedBox(
                                                  height: screenHeight * 0.01),
                                              TextField(
                                                  controller: nameController,
                                                  cursorColor: Colors.black,
                                                  decoration: InputDecoration(
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                          width: 0.8,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .bluePrimaryColor,
                                                          width: 0.8,
                                                        ),
                                                      ),
                                                      labelText:
                                                          _errorName != ""
                                                              ? _errorName
                                                              : 'Nombre',
                                                      labelStyle: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary))),
                                              SizedBox(
                                                  height: screenHeight * 0.01),
                                              TextField(
                                                  controller: phoneController,
                                                  cursorColor: Colors.black,
                                                  decoration: InputDecoration(
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                          width: 0.8,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .bluePrimaryColor,
                                                          width: 0.8,
                                                        ),
                                                      ),
                                                      labelText:
                                                          _errorName != ""
                                                              ? _errorName
                                                              : 'Telefono',
                                                      labelStyle: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary))),
                                              SizedBox(
                                                  height: screenHeight * 0.01),
                                              TextField(
                                                  controller: emailController,
                                                  cursorColor: Colors.black,
                                                  decoration: InputDecoration(
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                          width: 0.8,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .bluePrimaryColor,
                                                          width: 0.8,
                                                        ),
                                                      ),
                                                      labelText:
                                                          _errorName != ""
                                                              ? _errorEmail
                                                              : 'Correo',
                                                      labelStyle: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary))),
                                              SizedBox(
                                                  height: screenHeight * 0.01),
                                              Center(
                                                child: TextButton(
                                                  onPressed: () {
                                                    final scaffoldContext =
                                                        context;
                                                    setState(() async {
                                                      if (nameController
                                                          .text.isNotEmpty) {
                                                        if (phoneController
                                                            .text.isNotEmpty) {
                                                          if (emailController
                                                              .text
                                                              .isNotEmpty) {
                                                            await ordersProvider
                                                                .updateClient(
                                                                    nameController
                                                                        .text,
                                                                    phoneController
                                                                        .text,
                                                                    emailController
                                                                        .text);

                                                            if (ordersProvider
                                                                    .errorMessage
                                                                    .isEmpty ==
                                                                true) {
                                                              // ignore: use_build_context_synchronously
                                                              showCustomSnackBar(
                                                                  scaffoldContext,
                                                                  ordersProvider
                                                                      .successMessage,
                                                                  isError:
                                                                      false);
                                                            } else {
                                                              // ignore: use_build_context_synchronously
                                                              showCustomSnackBar(
                                                                  scaffoldContext,
                                                                  ordersProvider
                                                                      .errorMessage,
                                                                  isError:
                                                                      true);
                                                            }
                                                            ordersProvider
                                                                .getDataPerfil()
                                                                .then((_) {
                                                              // Asigna el valor una vez que los datos estén disponibles
                                                              setState(() {
                                                                nameController
                                                                        .text =
                                                                    ordersProvider
                                                                        .dataClient
                                                                        .nombre;
                                                                phoneController
                                                                        .text =
                                                                    ordersProvider
                                                                        .dataClient
                                                                        .telefono;
                                                                emailController
                                                                        .text =
                                                                    ordersProvider
                                                                        .dataClient
                                                                        .correo;
                                                              });
                                                            });
                                                          } else {
                                                            _errorEmail =
                                                                "No puede estar vacio";
                                                          }
                                                        } else {
                                                          _errorPhone =
                                                              "No puede estar vacio";
                                                        }
                                                      } else {
                                                        _errorName =
                                                            "No puede estar vacio";
                                                      }
                                                      _onEdit = !_onEdit;
                                                    });
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStateProperty.all(
                                                      AppColors.backgroundColor,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    _onEdit == false
                                                        ? 'Editar'
                                                        : 'Guardar',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )))),
                          SizedBox(height: screenHeight * 0.02),
                          _onEdit == false
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 0), // Espacio lateral
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Correo: ",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '(${client.correo})',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const Center(),
                          SizedBox(height: screenHeight * 0.01),
                          _onEdit == false
                              ? Center(
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _onEdit = !_onEdit;
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                        AppColors.backgroundColor,
                                      ),
                                    ),
                                    child: Text(
                                      _onEdit == false ? 'Editar' : 'Guardar',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              : const Center(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 0),
                    child: _onEditPass == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Cambiar la contraseña  ",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _onEditPass = !_onEditPass;
                                  });
                                },
                                child: Text(
                                  'Cambiar',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8)),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: screenHeight * 0.01),
                              TextField(
                                  controller: passOldController,
                                  cursorColor: Colors.white,
                                  obscureText: isObscure,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 0.8,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: AppColors.bluePrimaryColor,
                                        width: 0.8,
                                      ),
                                    ),
                                    labelText: " Contraseña anterior ",
                                    labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isObscure = !isObscure;
                                        });
                                      },
                                      icon: Icon(
                                        isObscure
                                            ? Icons.lock
                                            : Icons
                                                .no_encryption_gmailerrorred_rounded,
                                      ),
                                    ),
                                  )),
                              SizedBox(height: screenHeight * 0.01),
                              TextField(
                                  controller: passNewController,
                                  cursorColor: Colors.white,
                                  obscureText: isObscure,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 0.8,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: AppColors.bluePrimaryColor,
                                        width: 0.8,
                                      ),
                                    ),
                                    labelText: " Nueva Contraseña ",
                                    labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isObscure = !isObscure;
                                        });
                                      },
                                      icon: Icon(
                                        isObscure
                                            ? Icons.lock
                                            : Icons
                                                .no_encryption_gmailerrorred_rounded,
                                      ),
                                    ),
                                  )),
                              SizedBox(height: screenHeight * 0.01),
                              TextButton(
                                onPressed: () {
                                  setState(() async {
                                    final scaffoldContext = context;
                                    if (passOldController.text.isNotEmpty ||
                                        passNewController.text.isNotEmpty) {
                                      await ordersProvider.updatePass(
                                          passNewController.text,
                                          passOldController.text);
                                      if (ordersProvider.errorMessage.isEmpty ==
                                          true) {
                                        // ignore: use_build_context_synchronously
                                        showCustomSnackBar(scaffoldContext,
                                            ordersProvider.successMessage,
                                            isError: false);
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        showCustomSnackBar(scaffoldContext,
                                            ordersProvider.errorMessage,
                                            isError: true);
                                      }
                                      ordersProvider.getDataPerfil().then((_) {
                                        setState(() {
                                          nameController.text =
                                              ordersProvider.dataClient.nombre;
                                          phoneController.text = ordersProvider
                                              .dataClient.telefono;
                                          emailController.text =
                                              ordersProvider.dataClient.correo;
                                        });
                                      });
                                      passNewController.text = "";
                                      passOldController.text = "";
                                      _onEditPass = !_onEditPass;
                                    } else {
                                      showCustomSnackBar(scaffoldContext,
                                          "Las contraseñas no pueden estar vacias",
                                          isError: true);
                                    }
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    AppColors.backgroundColor,
                                  ),
                                ),
                                child: const Text(
                                  'Guardar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                  )
                ],
              ));
  }
}
