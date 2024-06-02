
import 'package:e_commerce/Models/product_model/product_model.dart';
import 'package:e_commerce/Services/product_service.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider extends ChangeNotifier {
  ProductService service = ProductService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  Future<void> getProducts() async {
    _isLoading = true;
    notifyListeners();
    _products = await service.getProducts();
    _isLoading = false;
    notifyListeners();
  }
}
