// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vivienda_link_app/screens/home/Home.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';
import '../../providers/Auth_provider.dart';
import '../../utils/ScaffoldMessengerUtil.dart';
import '../../utils/SpinnerLoader.dart';
import '../planScreen/PlanView.dart';
import '../register/Register.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showLoginPage;

  const LoginPage({super.key, required this.showLoginPage});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isRember = false;
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    // EmailValidatorFlutter emailValidatorFlutter = EmailValidatorFlutter();
    return Scaffold(
      backgroundColor: AppColors.white,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Ingresa tus datos",
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.activeBlack,
              ),
            ),
          ),
          const SizedBox(height: 10),
          //email textfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              cursorColor: AppColors.activeBlack,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppColors.border),
                  borderSide: const BorderSide(
                    color: AppColors.grey,
                    width: 0.8,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppColors.border),
                ),
                labelText: " Correo electrónico ",
              ),
              onChanged: (value) => authProvider.username = value,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          //password textfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
                cursorColor: AppColors.activeBlack,
                obscureText: isObscure,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppColors.border),
                    borderSide: const BorderSide(
                      color: AppColors.grey,
                      width: 0.8,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppColors.border),
                  ),
                  labelText: " Contraseña ",
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
                onChanged: (value) => authProvider.password = value),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      isRember = !isRember;
                    });
                  },
                  icon: Icon(
                    isRember ? Icons.check_box_outline_blank : Icons.check_box,
                  ),
                ),
                const Text(
                  'Recordarme',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          authProvider.isLoading
              ? const Center(child: Spinner())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Provider.of<AuthProvider>(context, listen: false).login();
                        if (authProvider.errorMessage.isEmpty) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        }
                        if (authProvider.errorMessage.isNotEmpty == true) {
                          showCustomSnackBar(context, authProvider.errorMessage, isError: true);
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿No tienes cuenta?',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    // MaterialPageRoute(builder: (context) => MealsListView()),
                    MaterialPageRoute(
                        builder: (context) => RegisterPage(
                              showSignUpPage: () {},
                            )),
                  );

                  if (result != null) {
                    // Aquí podrías mostrar un mensaje o hacer alguna acción con el resultado
                    showCustomSnackBar(context, result, isError: false);
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //   content: Text(result),
                    //   duration: const Duration(seconds: 3),
                    //   backgroundColor: Colors.green[400],
                    //   shape: const RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.vertical(
                    //       top: Radius.circular(12),
                    //     ),
                    //   ),
                    // ));
                  }
                },
                child: Text(
                  "Registrate",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.purple,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
