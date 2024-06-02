import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_commerce/Models/product_model/product_model.dart';
import 'package:e_commerce/Utils/strings.dart';

class ProductService {
  Future<List<ProductModel>> getProducts() async {
    List<ProductModel> products = [];
    try {
      final dio = Dio();
      final response = await dio.get(productUrl);
      if (response.statusCode == 200) {
        products = (response.data as List).map((e) {
          return ProductModel.fromJson(e);
        }).toList();
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    return products;
  }
}
