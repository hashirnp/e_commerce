import 'package:e_commerce/Models/user.dart';
import 'package:e_commerce/Services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class MyAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? get currentUser => _authService.currentUser;

  Stream<User?> get user => _authService.user;
  bool _loading = false;
  UserModel? _userModel;

  bool get loading => _loading;
  UserModel? get userModel => _userModel;

  Future<String> signIn(
      {required String email, required String password}) async {
    _loading = true;
    notifyListeners();
    final status = await _authService.signIn(email, password);
    _loading = false;
    notifyListeners();
    return status;
  }

  Future<String> signUp(
      {required UserModel model,
      required String password,
      required XFile image}) async {
    _loading = true;
    notifyListeners();
    final status = await _authService.createUser(model, password, image);
    _loading = false;
    notifyListeners();
    return status;
  }

  Future<String> signOut()async{
    _loading = true;
    notifyListeners();
    final status = await _authService.signOut();
    _loading = false;
    notifyListeners();
    return status;
  }

  Future<void> getUser() async {
    _loading = true;
    notifyListeners();
    final user = await _authService.getUser(FirebaseAuth.instance.currentUser!.uid);
    _userModel = user;
    _loading = false;
    notifyListeners();
  }

  Future<String> updateUser({required UserModel model,  XFile? image}) async {
    _loading = true;
    notifyListeners();
    final status = await _authService.updateUser(model: model, image: image!);
    _loading = false;
    notifyListeners();
    if (status == "success") {
      getUser();
      return "success";
    } else {
      return status;
    }
  }

  updateStat(){
    notifyListeners();
  }
}
