import 'package:e_commerce/Screens/home_screen.dart';
import 'package:e_commerce/Screens/Auth/signup_screen.dart';
import 'package:e_commerce/Utils/size.dart';
import 'package:e_commerce/Widgets/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Providers/auth_provider.dart';

class SignInScreen extends StatelessWidget {
 const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(
      body:
          SafeArea(child: Consumer<MyAuthProvider>(builder: (context, val, _) {
        if (val.loading) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        }
        return Form(
            key: key,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: GoogleFonts.aDLaMDisplay(
                          fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'enter Email';
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'invalid Format';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'Email',
                        suffixIcon: const Icon(CupertinoIcons.mail_solid,
                            color: Colors.black),
                        contentPadding: const EdgeInsets.only(left: 10.0),
                      ),
                    ),
                    h10,
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Password should be at least 6 characters';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'Password',
                        suffixIcon: const Icon(CupertinoIcons.lock_fill,
                            color: Colors.black),
                        contentPadding: const EdgeInsets.only(left: 10.0),
                      ),
                    ),
                    h10,
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50)),
                        onPressed: () async {
                          if (key.currentState!.validate()) {
                            try {
                              final status =
                                  await context.read<MyAuthProvider>().signIn(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                              if (status.startsWith("success")) {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (ctx) => const ConnectivityWrapper(child: HomeScreen())));
                              } else {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(status),
                                ));
                              }
                            } on FirebaseAuthException catch (e) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(e.message ?? 'Error'),
                              ));
                            }
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        )),
                    h10,
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => const SignUpScreen()));
                          },
                          child: const Text(
                            'Create Account',
                            style: TextStyle(color: Colors.blue),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
      })),
    );

  }
}