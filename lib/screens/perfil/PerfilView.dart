import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/Auth_provider.dart';
import '../../providers/Orders_provider.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';
import '../../providers/Provedor_provider.dart';
import '../../utils/HeadUtil.dart';
import '../../utils/ScaffoldMessengerUtil.dart';
import '../../utils/SpinnerLoader.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

import 'Sos_Screeen_Config.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PerfilViewState createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  bool _onChngePassword = false;
  final ImagePicker _picker = ImagePicker();
  bool isObscure = true;
  // final _formKey = GlobalKey<FormState>();
  String? _imageBase64;
  bool _onEdit = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController nameCompanyController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController passOldController = TextEditingController();
  TextEditingController passNewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  Future<void> loadData() async {
    try {
      final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
      final provProvider = Provider.of<ProvedorProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.getTypeUser();
      if (authProvider.typeUser == 3) {
        await ordersProvider.getContact("Cliente");
        await ordersProvider.getDataPerfil();
        final client = ordersProvider.dataClient;

        if (client != null) {
          setState(() {
            nameController.text = client.nombre ?? '';
            phoneController.text = client.telefono ?? '';
            emailController.text = client.correo ?? '';
            _imageBase64 = client.selfie;
          });
        }
      } else {
        await ordersProvider.getContact("Proveedor");
        await provProvider.getDataPerfil();

        if (provProvider.dataClient != null) {
          final client = provProvider.dataClient;
          setState(() {
            nameController.text = client.nombre ?? '';
            nameCompanyController.text = client.nombreEmpresarial ?? '';
            phoneController.text = client.telefono ?? '';
            emailController.text = client.correo ?? '';
            _imageBase64 = client.selfie;
            debugPrint("Datos cargados correctamente");
          });
        }
      }
    } catch (e) {
      debugPrint("Error cargando los datos: $e");
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    var phone = phoneNumber.replaceAll(" ", "");
    final Uri callUri = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('No se pudo realizar la llamada. Verifica la configuración del dispositivo.');
    }
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
    final provProvider = Provider.of<ProvedorProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final client = ordersProvider.dataClient ?? provProvider.dataClient;
    final contact = ordersProvider.contactSOS;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final typeClient = authProvider.typeUser;
    return Scaffold(
        appBar: const HeadUtil(),
        backgroundColor: AppColors.backgroundSecondColor,
        // body: ordersProvider.isLoading || contact == null || client == null || provProvider.isLoading
        body: ordersProvider.isLoading || client == null || provProvider.isLoading
            ? const Center(child: Spinner())
            : SingleChildScrollView(
                child: Container(
                  color: AppColors.backgroundSecondColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Container(
                          height: _onEdit ? screenHeight * 0.7 : screenHeight * 0.25,
                          width: screenWidth * 1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: _onEdit ? _buildEditForm(typeClient) : _buildProfileView(),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Container(
                            // alignment: Alignment.centerLeft,
                            height: _onChngePassword ? screenHeight * 0.4 : screenHeight * 0.085,
                            width: screenWidth * 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: _onChngePassword ? _buildEditPassForm(typeClient) : _buildPasswordView()),
                      ),
                      // typeClient == 3 ? const SizedBox(height: 5) : const Center(),
                      typeClient == 3
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Container(
                                height: _onChngePassword ? screenHeight * 0.4 : 60,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    // crossAxisAlignment: ,
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        const Icon(Icons.article),
                                        const Text(
                                          'Cambiar Plan',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.expand_more, size: 35),
                                          onPressed: () {
                                            // setState(() {
                                            //   _onChngePassword =
                                            //       !_onChngePassword;
                                            // });
                                          },
                                        )
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const Center(),
                      // const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: InkWell(
                          onTap: () {
                            if (contact['nombreContacto'] != null) {
                              _makePhoneCall(contact['telefono']);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactoEmergenciaPage(
                                          typeUser: typeClient,
                                        )),
                              );
                            }
                          },
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.call),
                                Text(
                                  contact['nombreContacto'] ?? 'Agregar contacto de emergencia',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                contact['nombreContacto'] == null
                                    ? const Icon(Icons.arrow_forward_ios)
                                    : IconButton(
                                        onPressed: () async {
                                          await ordersProvider.deleteContacto(contact['idContacto']);

                                          if (ordersProvider.errorMessage.isEmpty) {
                                            // ignore: use_build_context_synchronously
                                            showCustomSnackBar(context, 'Se eliminó correctamente', isError: false);
                                            await loadData();
                                          } else {
                                            // ignore: use_build_context_synchronously
                                            showCustomSnackBar(context, ordersProvider.errorMessage, isError: true);
                                          }
                                        },
                                        icon: const Icon(Icons.delete_forever),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }

  Widget _buildProfileView() {
    debugPrint('Imagen perfil: $_imageBase64');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipOval(
          child: _imageBase64 != null
              ? Image.memory(
                  base64Decode(_imageBase64!),
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'assets/images/user.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nameController.text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              Text(emailController.text),
              Text("Teléfono: ${phoneController.text}"),
              nameCompanyController.text != "" ? Text("Nombre Empresarial: ${nameCompanyController.text}") : const Center(),
              GestureDetector(
                onTap: () => setState(() => _onEdit = true),
                child: const Text(
                  "Editar",
                  style: TextStyle(color: AppColors.bluePrimaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.lock_outline, size: 28),
          const Text(
            'Cambiar Contraseña',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          IconButton(
            icon: Icon(
              _onChngePassword ? Icons.close : Icons.expand_more,
              size: 35,
            ),
            onPressed: () {
              setState(() {
                _onChngePassword = !_onChngePassword;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEditPassForm(int typeClient) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0), // Agrega padding para evitar solapamiento
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: passOldController,
                  label: "Contraseña anterior",
                  isObscure: isObscure,
                  toggleObscure: () {
                    setState(() => isObscure = !isObscure);
                  },
                ),
                const SizedBox(height: 15),
                _buildPasswordField(
                  controller: passNewController,
                  label: "Nueva Contraseña",
                  isObscure: isObscure,
                  toggleObscure: () {
                    setState(() => isObscure = !isObscure);
                  },
                ),
                const SizedBox(height: 20),
                _buildSaveButton(context, typeClient)
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: const Icon(Icons.close, size: 35, color: Colors.black),
            onPressed: () {
              setState(() {
                _onChngePassword = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm(int typeClient) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0), // Agrega padding para evitar solapamiento
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: _imageBase64 != null
                          ? Image.memory(
                              base64Decode(_imageBase64!),
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/user.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: () => _showImageSourceOptions(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orangeColor, // Cambia el fondo del botón
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Define qué tan redondeado será
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Ajusta el padding
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del Row al contenido
                        children: [
                          Text(
                            "Cambiar Foto",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(width: 10), // Espacio entre el texto y el ícono
                          Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.white,
                          ), // Ícono de cámara
                        ],
                      ),
                    ),
                  ],
                ),
                _buildTextField("Nombre", nameController),
                _buildTextField("Correo", emailController, isEmail: true),
                _buildTextField("Teléfono", phoneController, isPhone: true),
                nameCompanyController.text != "" ? _buildTextField("Nombre Empresarial", nameCompanyController) : const Center(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => {_saveProfile(typeClient)},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bluePrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Define qué tan redondeado será
                      ),
                    ),
                    child: const Text(
                      "Guardar",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: const Icon(Icons.close, size: 35, color: Colors.black),
            onPressed: () {
              setState(() {
                _onEdit = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isEmail = false, bool isPhone = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : isPhone
              ? TextInputType.phone
              : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label no puede estar vacío";
        }
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Ingrese un correo válido";
        }
        if (isPhone && value.length < 10) {
          return "Ingrese un teléfono válido";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _saveProfile(int typeClient) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final provProvider = Provider.of<ProvedorProvider>(context, listen: false);
    if (_formKey.currentState?.validate() ?? false) {
      // Guardar cambios
      setState(() async {
        // Simula el guardado en un proveedor o base de datos
        if (typeClient == 3) {
          await ordersProvider.updateClient(nameController.text, phoneController.text, emailController.text, _imageBase64);
          if (ordersProvider.errorMessage.isEmpty == true) {
            // ignore: use_build_context_synchronously
            showCustomSnackBar(context, ordersProvider.successMessage, isError: false);
          } else {
            // ignore: use_build_context_synchronously
            showCustomSnackBar(context, ordersProvider.errorMessage, isError: true);
          }
        } else {
          await provProvider.updateProvedor(nameController.text, nameCompanyController.text, phoneController.text, emailController.text, _imageBase64);
          if (provProvider.errorMessage.isEmpty == true) {
            // ignore: use_build_context_synchronously
            showCustomSnackBar(context, provProvider.successMessage, isError: false);
          } else {
            // ignore: use_build_context_synchronously
            showCustomSnackBar(context, provProvider.errorMessage, isError: true);
          }
        }
        loadData();
        _onEdit = false;
      });
    }
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isObscure,
    required VoidCallback toggleObscure,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          onPressed: toggleObscure,
          icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, int typeClient) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final provProvider = Provider.of<ProvedorProvider>(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (passOldController.text.isEmpty || passNewController.text.isEmpty) {
            showCustomSnackBar(context, "Las contraseñas no pueden estar vacías", isError: true);
            return;
          }
          if (typeClient == 3) {
            await ordersProvider.updatePass(passNewController.text, passOldController.text);
            if (ordersProvider.errorMessage.isEmpty == true) {
              // ignore: use_build_context_synchronously
              showCustomSnackBar(context, ordersProvider.successMessage, isError: false);
            } else {
              // ignore: use_build_context_synchronously
              showCustomSnackBar(context, ordersProvider.errorMessage, isError: true);
            }
          } else {
            await provProvider.updatePass(passNewController.text, passOldController.text);
            if (provProvider.errorMessage.isEmpty == true) {
              // ignore: use_build_context_synchronously
              showCustomSnackBar(context, provProvider.successMessage, isError: false);
            } else {
              // ignore: use_build_context_synchronously
              showCustomSnackBar(context, provProvider.errorMessage, isError: true);
            }
          }
          setState(() {
            _onChngePassword = false;
            passOldController.clear();
            passNewController.clear();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bluePrimaryColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Guardar',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
