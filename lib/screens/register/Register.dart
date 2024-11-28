// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/Colors_Utils.dart';
import '../../utils/ScaffoldMessengerUtil.dart';
import '../login/Login.dart';
import 'package:provider/provider.dart';
import '../../providers/Auth_provider.dart';
import '../../utils/SpinnerLoader.dart';
// import 'package:user_auth_crudd10/services/functions/user_data_store.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showSignUpPage;
  const RegisterPage({super.key, required this.showSignUpPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isObscure = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confromPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // validation
  bool checkPassowrd() {
    if (_passwordController.text.trim() == _confromPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value) ? 'Error' : null;
  }

  //method to create account
  Future signUp() async {
    if (checkPassowrd()) {
      if (validateEmail(_emailController.text) != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Ingresa un correo valido"),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red[300],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
          ),
        );
      } else {
        await Provider.of<AuthProvider>(context, listen: false).register();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Las contraseñas no coinsiden"),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red[300],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12),
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confromPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void validatePassword(value) {}

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 2.0,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logoVivienda.jpeg',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.backgroundColor,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "¡Crea una cuenta para continuar!",
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.activeBlack,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppColors.border),
                              ),
                              border: const OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppColors.border),
                                borderSide: const BorderSide(color: Colors.red, width: 0.8),
                              ),
                              labelText: " Nombre Completo ",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                              return null;
                            },
                            onChanged: (value) => authProvider.fullName = value),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          maxLength: 10,
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppColors.border),
                            ),
                            labelText: " Número de Telefono ",
                            border: const OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppColors.border),
                              borderSide: const BorderSide(color: Colors.red, width: 0.8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo es obligatorio';
                            }
                            return null;
                          },
                          onChanged: (value) => authProvider.phone = value,
                        ),
                      ),
                      const SizedBox(height: 10),
                      //email TextFormField
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppColors.border),
                            ),
                            border: const OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppColors.border),
                              borderSide: const BorderSide(color: Colors.red, width: 0.8),
                            ),
                            labelText: " Correo ",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo es obligatorio';
                            }
                            return null;
                          },
                          onChanged: (value) => authProvider.email = value,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: isObscure,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppColors.border),
                            ),
                            border: const OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppColors.border),
                              borderSide: const BorderSide(color: Colors.red, width: 0.8),
                            ),
                            labelText: " Password ",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                              icon: Icon(
                                isObscure ? Icons.lock : Icons.no_encryption_gmailerrorred_rounded,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo es obligatorio';
                            }
                            return null;
                          },
                          onChanged: (value) => authProvider.pass1 = value,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: _confromPasswordController,
                          obscureText: isObscure,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppColors.border),
                            ),
                            border: const OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppColors.border),
                              borderSide: const BorderSide(color: Colors.red, width: 0.8),
                            ),
                            labelText: " Confirm Password ",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                              icon: Icon(
                                isObscure ? Icons.lock : Icons.no_encryption_gmailerrorred_rounded,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Este campo es obligatorio';
                            }
                            return null;
                          },
                          onChanged: (value) => authProvider.pass2 = value,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 20),
              authProvider.isLoading
                  ? Center(child: Spinner())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await signUp();
                              // Después de que signUp haya finalizado, verificas si el registro fue exitoso
                              if (authProvider.successMessage.isNotEmpty) {
                                Navigator.pop(context, 'Registro exitoso');
                              } else {
                                // Aquí podrías manejar algún error o mostrar un mensaje
                                if (authProvider.errorMessage.isNotEmpty) {
                                  showCustomSnackBar(context, authProvider.errorMessage, isError: true);
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orangeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                          child: const Text(
                            "Iniciar sesión",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 50),
              //   child: GestureDetector(
              //     onTap: () async {
              //       // Llamas al método de registro y esperas su resultado
              //       await signUp();
              //       // Después de que signUp haya finalizado, verificas si el registro fue exitoso
              //       if (authProvider.successMessage.isNotEmpty == true) {
              //         Navigator.pop(context, 'Registro exitoso');
              //       } else {
              //         // Aquí podrías manejar algún error o mostrar un mensaje
              //         if (authProvider.errorMessage.isNotEmpty == true) {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             SnackBar(
              //               content: Text(authProvider.errorMessage),
              //               duration: const Duration(seconds: 3),
              //               backgroundColor: Colors.red[300],
              //               shape: const RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.vertical(
              //                   top: Radius.circular(12),
              //                 ),
              //               ),
              //             ),
              //           );
              //         }
              //       }
              //     },
              //     child: Stack(
              //       alignment: Alignment.center,
              //       children: [
              //         Image.asset(
              //           'assets/icons/ic_button.png',
              //         ),
              //         Text(
              //           "Registrarme",
              //           style: GoogleFonts.inter(
              //             fontSize: 17,
              //             fontWeight: FontWeight.w500,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes una cuenta?',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(showLoginPage: () {}),
                        ), // Llama a la pantalla de registro
                      );
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.purple,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ));
  }
}
