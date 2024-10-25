// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // validation
  bool checkPassowrd() {
    if (_passwordController.text.trim() ==
        _confromPasswordController.text.trim()) {
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
        await ScaffoldMessenger.of(context).showSnackBar(
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
      await ScaffoldMessenger.of(context).showSnackBar(
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(90, 20, 0, 0),
                  child: Image.asset('assets/images/grad2.png'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                  child: Image.asset('assets/images/grad1.png'),
                ),
                // Positioned(
                //   top: 60,
                //   left: 150,
                //   child: Text(
                //     'Vivienda Link',
                //     style: GoogleFonts.lato(
                //       fontSize: 26,
                //       fontWeight: FontWeight.w700,
                //       color: Colors.deepPurple[500],
                //     ),
                //   ),
                // ),

                //container
                Positioned(
                  top: 110,
                  left: 10,
                  right: 10,
                  bottom: 0,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Container(
                      height: 1000,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Image.asset(
                                'assets/images/logoVivienda.jpeg',
                                fit: BoxFit.contain,
                                width: 100,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "¡Crea una cuenta para continuar!",
                              style: GoogleFonts.lato(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                  cursorColor: Colors.white,
                                  controller: _nameController,
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
                                        color: Colors.purpleAccent,
                                        width: 0.8,
                                      ),
                                    ),
                                    labelText: " Nombre Completo ",
                                    labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                  onChanged: (value) =>
                                      authProvider.fullName = value),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                maxLength: 10,
                                cursorColor: Colors.white,
                                controller: _phoneController,
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
                                      color: Colors.purpleAccent,
                                      width: 0.8,
                                    ),
                                  ),
                                  labelText: " Número de Telefono ",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                onChanged: (value) =>
                                    authProvider.phone = value,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //email textfield
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                cursorColor: Colors.white,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  // errorText: validatePassword(),
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
                                      color: Colors.purpleAccent,
                                      width: 0.8,
                                    ),
                                  ),
                                  labelText: " Correo ",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                onChanged: (value) =>
                                    authProvider.email = value,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //password textfield
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                cursorColor: Colors.white,
                                controller: _passwordController,
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
                                      color: Colors.purpleAccent,
                                      width: 0.8,
                                    ),
                                  ),
                                  labelText: " Password ",
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
                                ),
                                onChanged: (value) =>
                                    authProvider.pass1 = value,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //password textfield
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                cursorColor: Colors.white,
                                controller: _confromPasswordController,
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
                                      color: Colors.purpleAccent,
                                      width: 0.8,
                                    ),
                                  ),
                                  labelText: " Confirm Password ",
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
                                ),
                                onChanged: (value) =>
                                    authProvider.pass2 = value,
                              ),
                            ),

                            //login Button
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            authProvider.isLoading
                ? Center(child: Spinner())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: GestureDetector(
                      onTap: () async {
                        // Llamas al método de registro y esperas su resultado
                        await signUp();
                        // Después de que signUp haya finalizado, verificas si el registro fue exitoso
                        if (authProvider.successMessage.isNotEmpty == true) {
                          Navigator.pop(context, 'Registro exitoso');
                        } else {
                          // Aquí podrías manejar algún error o mostrar un mensaje
                          if (authProvider.errorMessage.isNotEmpty == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(authProvider.errorMessage),
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
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/ic_button.png',
                          ),
                          Text(
                            "Registrarme",
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            const SizedBox(
              height: 10,
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
                          builder: (context) => LoginPage(
                              showLoginPage:
                                  () {})), // Llama a la pantalla de registro
                    );
                  },
                  child: Text(
                    "Login",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
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
      ),
    );
  }
}
