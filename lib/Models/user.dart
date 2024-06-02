import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  String phone;
  String image;
  String uid;

  UserModel({required this.name, required this.email, required this.phone, required this.image, required this.uid});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    return UserModel(
      name: doc['name'] as String,
      email: doc['email'] as String,
      phone: doc['phone'] as String,
      image: doc['image'] as String,
      uid: doc.id,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'uid': uid,
    };
  }
}
