import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';
import '../providers/Orders_provider.dart';
import '../utils/HeadUtil.dart';
import '../utils/ScaffoldMessengerUtil.dart';
import '../utils/SpinnerLoader.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _onEdit = false;
  bool _onChngePassword = false;
  final ImagePicker _picker = ImagePicker();
  String? _imageBase64;
  bool _onEditPass = false;
  String _errorName = "";
  String _errorPhone = "";
  String _errorEmail = "";
  bool isObscure = true;
  // final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passOldController = TextEditingController();
  TextEditingController passNewController = TextEditingController();
  // final auth = FirebaseAuth.instance;
  // final authData = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider.getDataPerfil().then((_) {
      setState(() {
        nameController.text = ordersProvider.dataClient?.nombre;
        phoneController.text = ordersProvider.dataClient?.telefono;
        emailController.text = ordersProvider.dataClient?.correo;
        _imageBase64 = ordersProvider.dataClient?.selfie;
      });
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar Foto'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Elegir de la Galería'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final client = ordersProvider.dataClient;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // User? currentUser = auth.currentUser;
    return Scaffold(
        appBar: const HeadUtil(),
        body: ordersProvider.isLoading
            ? const Center(child: Spinner())
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Container(
                          // alignment: Alignment.centerLeft,
                          height:
                              _onEdit ? screenHeight * 0.6 : screenHeight * 0.2,
                          width: screenWidth * 1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black.withOpacity(0.1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: screenHeight * 0.01),
                                      _onEdit
                                          ? _imageBase64 != null
                                              ? ClipOval(
                                                  child: Image.memory(
                                                    base64Decode(
                                                        client.selfie!),
                                                    width:
                                                        60, // Ajusta el tamaño de la imagen redonda
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : ClipOval(
                                                  child: Image.asset(
                                                    'assets/images/user.png',
                                                    width:
                                                        60, // Tamaño ajustado del ícono redondo
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                          : const Center(),
                                      _onEdit
                                          ? ElevatedButton(
                                              onPressed: () => setState(() {
                                                _showImageSourceOptions();
                                              }),
                                              child: const Text("Cambiar"),
                                            )
                                          : const Center(),
                                      SizedBox(height: screenHeight * 0.01),
                                      _onEdit
                                          ? Flexible(
                                              child: TextField(
                                                controller: nameController,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.grey,
                                                        width: 0.8,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: AppColors
                                                            .bluePrimaryColor,
                                                        width: 0.8,
                                                      ),
                                                    ),
                                                    labelText: _errorName != ""
                                                        ? _errorName
                                                        : 'Nombre',
                                                    labelStyle: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary)),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                "${client.nombre}",
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                      // SizedBox(height: screenHeight * 0.01),
                                      _onEdit
                                          ? Flexible(
                                              child: TextField(
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
                                                                  .secondary))))
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                '${client.correo}',
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                      _onEdit
                                          ? Flexible(
                                              child: TextField(
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
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                "phone: ${client.telefono}",
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _onEdit = !_onEdit;
                                            });
                                          },
                                          child: Text(
                                            _onEdit ? "Cancelar" : "Editar",
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: AppColors.bluePrimaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      _onEdit
                                          ? Center(
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
                                                            .text.isNotEmpty) {
                                                          await ordersProvider
                                                              .updateClient(
                                                                  nameController
                                                                      .text,
                                                                  phoneController
                                                                      .text,
                                                                  emailController
                                                                      .text,
                                                                  _imageBase64);

                                                          if (ordersProvider
                                                                  .errorMessage
                                                                  .isEmpty ==
                                                              true) {
                                                            // ignore: use_build_context_synchronously
                                                            showCustomSnackBar(
                                                                scaffoldContext,
                                                                ordersProvider
                                                                    .successMessage,
                                                                isError: false);
                                                          } else {
                                                            // ignore: use_build_context_synchronously
                                                            showCustomSnackBar(
                                                                scaffoldContext,
                                                                ordersProvider
                                                                    .errorMessage,
                                                                isError: true);
                                                          }
                                                          ordersProvider
                                                              .getDataPerfil()
                                                              .then((_) {
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
                                                              _imageBase64 =
                                                                  ordersProvider
                                                                      .dataClient
                                                                      .selfie;
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
                                                            AppColors
                                                                .bluePrimaryColor)),
                                                child: const Text(
                                                  'Guardar',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          : const Center()
                                    ],
                                  ),
                                ),
                                _onEdit == false
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                            client.selfie != null
                                                ? ClipOval(
                                                    child: Image.memory(
                                                      base64Decode(
                                                          client.selfie),
                                                      width:
                                                          60, // Ajusta el tamaño de la imagen redonda
                                                      height: 60,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : ClipOval(
                                                    child: Image.asset(
                                                      'assets/images/user.png',
                                                      width:
                                                          60, // Tamaño ajustado del ícono redondo
                                                      height: 60,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                            // _onEdit
                                            //     ? ElevatedButton(
                                            //         onPressed:
                                            //             _showImageSourceOptions,
                                            //         child: const Text("Cambiar"),
                                            //       )
                                            //     : const Center()
                                          ])
                                    : const Center()
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      //mode section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Container(
                          height: _onChngePassword ? screenHeight * 0.4 : 60,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black.withOpacity(0.1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: ,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(Icons.password_sharp),
                                      const Text(
                                        'Cambiar Contraseña',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(_onChngePassword
                                            ? Icons.cancel
                                            : Icons.change_circle_outlined),
                                        onPressed: () {
                                          setState(() {
                                            _onChngePassword =
                                                !_onChngePassword;
                                          });
                                        },
                                      )
                                    ]),
                                _onChngePassword
                                    ? TextField(
                                        controller: passOldController,
                                        cursorColor: Colors.white,
                                        obscureText: isObscure,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                              width: 0.8,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                        ))
                                    : const Center(),
                                // SizedBox(height: screenHeight * 0.01),
                                _onChngePassword
                                    ? TextField(
                                        controller: passNewController,
                                        cursorColor: Colors.white,
                                        obscureText: isObscure,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                              width: 0.8,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                        ))
                                    : const Center(),
                                // SizedBox(height: screenHeight * 0.01),
                                _onChngePassword
                                    ? TextButton(
                                        onPressed: () {
                                          setState(() async {
                                            final scaffoldContext = context;
                                            if (passOldController
                                                    .text.isNotEmpty ||
                                                passNewController
                                                    .text.isNotEmpty) {
                                              await ordersProvider.updatePass(
                                                  passNewController.text,
                                                  passOldController.text);
                                              if (ordersProvider
                                                      .errorMessage.isEmpty ==
                                                  true) {
                                                // ignore: use_build_context_synchronously
                                                showCustomSnackBar(
                                                    scaffoldContext,
                                                    ordersProvider
                                                        .successMessage,
                                                    isError: false);
                                              } else {
                                                // ignore: use_build_context_synchronously
                                                showCustomSnackBar(
                                                    scaffoldContext,
                                                    ordersProvider.errorMessage,
                                                    isError: true);
                                              }
                                              ordersProvider
                                                  .getDataPerfil()
                                                  .then((_) {
                                                setState(() {
                                                  nameController.text =
                                                      ordersProvider
                                                          .dataClient.nombre;
                                                  phoneController.text =
                                                      ordersProvider
                                                          .dataClient.telefono;
                                                  emailController.text =
                                                      ordersProvider
                                                          .dataClient.correo;
                                                });
                                              });
                                              passNewController.text = "";
                                              passOldController.text = "";
                                              _onEditPass = !_onEditPass;
                                            } else {
                                              showCustomSnackBar(
                                                  scaffoldContext,
                                                  "Las contraseñas no pueden estar vacias",
                                                  isError: true);
                                            }
                                          });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                            AppColors.backgroundColor,
                                          ),
                                        ),
                                        child: const Text(
                                          'Guardar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : const Center()
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      //about section
                      // const aboutUs(),
                      const SizedBox(
                        height: 25,
                      ),
                      // logOutFunc(auth: auth)
                    ],
                  ),
                ),
              ));
  }
}
