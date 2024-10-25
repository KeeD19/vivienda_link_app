import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/Auth_provider.dart';
import '../../utils/SpinnerLoader.dart';
import '../register/Register.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showLoginPage;

  const LoginPage({Key? key, required this.showLoginPage}) : super(key: key);

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
      // backgroundColor: Theme.of(context).colorScheme.surface,
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
                //   // child: Image.asset('assets/images/intro_logo.png'),
                //   // child: Text(
                //   //   'Vivienda Link',
                //   //   style: GoogleFonts.lato(
                //   //     fontSize: 26,
                //   //     fontWeight: FontWeight.w700,
                //   //     color: Colors.deepPurple[500],
                //   //   ),
                //   // ),
                // ),

                //container
                Positioned(
                  top: 120,
                  left: 10,
                  right: 10,
                  bottom: 0,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Container(
                      // height: MediaQuery.of(context).size.height *
                      //     0.9, //chnage old was 700

                      width: 250,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/logoVivienda.jpeg',
                                // scale: 0.3,
                                fit: BoxFit.contain,
                                width: 100,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "Ingresa tus credenciales",
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          //email textfield
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextField(
                              cursorColor: Colors.white,
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
                                labelText: " Email ",
                                labelStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              onChanged: (value) =>
                                  authProvider.username = value,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //password textfield
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextField(
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
                                    authProvider.password = value),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          //remember--forget row
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
                                    isRember
                                        ? Icons.check_box_outline_blank
                                        : Icons.check_box,
                                  ),
                                ),
                                const Text(
                                  'Remember me',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.symmetric(horizontal: 0),
                                //   child: Row(
                                //     children: [
                                //       GestureDetector(
                                //         onTap: () {
                                //           Navigator.push(
                                //             context,
                                //             MaterialPageRoute(
                                //               builder: (context) =>
                                //                   const ForgetPassPage(),
                                //             ),
                                //           );
                                //         },
                                //         child: const Text(
                                //           "Forget Password ?",
                                //           style: TextStyle(
                                //             color: Colors.blue,
                                //             fontWeight: FontWeight.w400,
                                //             fontSize: 16,
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            // Consumer<AuthProvider>(
            //   builder: (context, authProvider, child) {
            //     return authProvider.errorMessage.isNotEmpty
            //         ? Text(
            //             authProvider.errorMessage,
            //             style: TextStyle(color: Colors.red),
            //           )
            //         : Container();
            //   },
            // ),
            authProvider.isLoading
                ? Center(child: Spinner())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: GestureDetector(
                      onTap: () async {
                        await Provider.of<AuthProvider>(context, listen: false)
                            .login();
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
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/ic_button.png',
                          ),
                          Text(
                            "Iniciar Sesión",
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
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿No tienes una cuenta?',
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
                      MaterialPageRoute(
                          builder: (context) =>
                              RegisterPage(showSignUpPage: () {
                                print("Register page shown");
                              })),
                    );

                    if (result != null) {
                      // Aquí podrías mostrar un mensaje o hacer alguna acción con el resultado
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(result),
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.green[400],
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                      ));
                    }
                  },
                  child: Text(
                    "Registrarme",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
