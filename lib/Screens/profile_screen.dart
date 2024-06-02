import 'dart:developer';
import 'dart:io';

import 'package:e_commerce/Providers/auth_provider.dart';
import 'package:e_commerce/Utils/size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

ValueNotifier<XFile> profileImageNotifier = ValueNotifier(XFile(""));
ValueNotifier<bool> isUpdateNotifier = ValueNotifier(false);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void dispose() {
    super.dispose();
    profileImageNotifier.value = XFile("");
    isUpdateNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MyAuthProvider>(context, listen: false).getUser();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: const [],
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.back)),
      ),
      body: Consumer<MyAuthProvider>(builder: (context, provider, _) {
        if (provider.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SafeArea(
            child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10),
          children: [
            ValueListenableBuilder(
                valueListenable: profileImageNotifier,
                builder: (context, val, _) {
                  return GestureDetector(
                    onTap: () async {
                      final image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      profileImageNotifier.value = image!;
                      isUpdateNotifier.value = true;
                    },
                    child: CircleAvatar(
                      radius: 80,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: val.path.isEmpty ? Colors.red : null,
                        backgroundImage: val.path.isNotEmpty
                            ? FileImage(File(val.path))
                            : provider.userModel!.image.isNotEmpty
                                ? NetworkImage(
                                    provider.userModel!.image,
                                  ) as ImageProvider
                                : null,
                      ),
                    ),
                  );
                }),
            h10,
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      final controller =
                          TextEditingController(text: provider.userModel!.name);
                      final key = GlobalKey<FormState>();
                      return AlertDialog(
                          title: const Text('Update Name'),
                          content: Form(
                            key: key,
                            child: TextFormField(
                              controller: controller,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'enter Name';
                                }

                                return null;
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  if (key.currentState!.validate()) {
                                    provider.userModel!.name = controller.text;

                                    isUpdateNotifier.value = true;
                                    provider.updateStat();
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text('Update'))
                          ]);
                    });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(1, 1),
                        blurRadius: 5,
                        spreadRadius: 3,
                      )
                    ]),
                child: Row(
                  children: [
                    const Text(
                      'Name : ',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      provider.userModel!.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            // h10,
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(1, 1),
                        blurRadius: 5,
                        spreadRadius: 3,
                      )
                    ]),
                child: Row(
                  children: [
                    const Text(
                      'Email : ',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      provider.userModel!.email,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      final mobileController = TextEditingController(
                          text: provider.userModel!.phone);
                      final key = GlobalKey<FormState>();
                      return AlertDialog(
                          title: const Text('Update Mobile Number'),
                          content: Form(
                            key: key,
                            child: TextFormField(
                              controller: mobileController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty || value.length != 10) {
                                  return 'Mobile Number should be 10 digits';
                                }
                                return null;
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  if (key.currentState!.validate()) {
                                    provider.userModel!.phone =
                                        mobileController.text;

                                    isUpdateNotifier.value = true;
                                    log(provider.userModel!.phone);
                                    provider.updateStat();
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text('Update'))
                          ]);
                    });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(1, 1),
                        blurRadius: 5,
                        spreadRadius: 3,
                      )
                    ]),
                child: Row(
                  children: [
                    const Text(
                      'Mobile : ',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      provider.userModel!.phone,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            h10,
            const Text(
              'You can update image, name, mobile number by clicking them',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                height: 1,
              ),
              textAlign: TextAlign.center,
            ),
            h10,
            ValueListenableBuilder(
                valueListenable: isUpdateNotifier,
                builder: (context, val, _) {
                  if (val) {
                    return ElevatedButton(
                      onPressed: () {
                        log(FirebaseAuth.instance.currentUser!.uid);
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          Provider.of<MyAuthProvider>(context, listen: false)
                              .updateUser(
                                  model: provider.userModel!,
                                  image: profileImageNotifier.value.path != " "
                                      ? profileImageNotifier.value
                                      : null);
                          isUpdateNotifier.value = false;
                        });
                      },
                      child: const Text(
                        'Update Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          ],
        ));
      }),
    );
  }
}
