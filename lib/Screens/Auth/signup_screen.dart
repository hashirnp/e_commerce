import 'dart:io';

import 'package:e_commerce/Models/user.dart';
import 'package:e_commerce/Providers/auth_provider.dart';
import 'package:e_commerce/Screens/home_screen.dart';
import 'package:e_commerce/Widgets/connectivity_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Utils/size.dart';

ValueNotifier<XFile> imageNotifier = ValueNotifier(XFile(''));

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void dispose() {
    imageNotifier.value=XFile('');
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final passwordController = TextEditingController();
    final mobileController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign Up',
                        style: GoogleFonts.aDLaMDisplay(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ValueListenableBuilder(
                            valueListenable: imageNotifier,
                            builder: (context, val, _) {
                              return GestureDetector(
                                onTap: () async {
                                  final image = await ImagePicker().pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 50);
                                  imageNotifier.value = image!;
                                },
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Colors.red,
                                  child: CircleAvatar(
                                    radius: 70,
                                    backgroundImage: val.path.isEmpty
                                        ? null
                                        : FileImage(File(val.path)),
                                  ),
                                ),
                              );
                            }),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Click Above to select Image',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      h10,
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter Name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Name',
                          suffixIcon: const Icon(
                            CupertinoIcons.person_fill,
                            color: Colors.black,
                          ),
                          contentPadding: const EdgeInsets.only(left: 10.0),
                        ),
                      ),
                      h10,
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
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 10) {
                            return 'Mobile Number Shoould be 10 Digits';
                          }
                  
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Mobile',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Mobile',
                          suffixIcon: const Icon(CupertinoIcons.phone,
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
                              if (imageNotifier.value.path.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Select Image')));
                                return;
                              }
                              try {
                                UserModel model = UserModel(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  uid: '',
                                  image: '',
                                  phone: mobileController.text.trim(),
                                );
                                final status = await context
                                    .read<MyAuthProvider>()
                                    .signUp(
                                        model: model,
                                        password: passwordController.text,
                                        image: imageNotifier.value);
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
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(e.toString()),
                                ));
                              }
                            }
                          },
                          child: const Text(
                            'Create Account',
                            style: TextStyle(color: Colors.white),
                          )),
                      h10,
                    ],
                  ),
                ),
              ),
            ));
      })),
    );
  }
}
