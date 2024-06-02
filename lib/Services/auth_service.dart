import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future<String> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        return "success ${userCredential.user!.uid}";
      } else {
        return 'Something Error';
      }
    } on FirebaseAuthException catch (e) {
      log("error ${e.message.toString()}");
      return e.code;
    }
  }

  Future<String> createUser(
      UserModel user, String password, XFile image) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      if (userCredential.user != null) {
        final imageStatus =
            await addImage(file: image, uid: userCredential.user!.uid);
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': user.email,
          'uid': userCredential.user!.uid,
          'name': user.name,
          'phone': user.phone,
          'image': imageStatus.split(' ')[1]
        });
        return "success ${userCredential.user!.uid}";
      } else {
        return 'Something Error';
      }
    } on FirebaseAuthException catch (e) {
      log(e.message!.toString());
      return e.code;
    }
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();
      return 'success';
    } on FirebaseAuthException catch (e) {
      log(e.message!.toString());
      return e.code;
    }
  }

  Future<String> addImage({required XFile file, required String uid}) async {
    try {
      final ref = FirebaseStorage.instance.ref().child("users/$uid.jpg");
      final task = ref.putFile(File(file.path));
      final snapshot = await task.whenComplete(() {});
      String getDownloadURL = await snapshot.ref.getDownloadURL();

      return "success $getDownloadURL";
    } on FirebaseException catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    } else {
      return null;
    }
  }

  Future<String> updateUser({required UserModel model, XFile? image}) async {
    try {
      if (image!.path!= " ") {
        log("adding Image ${model.uid}");
        final status = await addImage(file: image, uid: model.uid);
        model.image = status.split(" ")[1];
      }
      await firestore
          .collection('users')
          .doc(model.uid)
          .set(model.toFirestore());
      return "success";
    } catch (e) {
      rethrow;
    }
  }
}
