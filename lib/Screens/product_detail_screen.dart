import 'dart:io';

import 'package:e_commerce/Models/product_model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        product.title ?? 'Product Details',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        overflow: TextOverflow.ellipsis,
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (product.image != null)
                Center(
                  child: Hero(
                    transitionOnUserGestures: true,
                    tag: 'image ${product.id}',
                    child: Image.network(
                      product.image!,
                      height: 200,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes !=
                                    null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                product.title ?? 'No Title',
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${product.price?.toStringAsFixed(2) ?? 'No Price'}',
                style: const TextStyle(fontSize: 24, color: Colors.green),
              ),
              // const SizedBox(height: 16),
              if (product.rating != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      placeholderBuilder: (context, heroSize, child) {
                        return Container(
                          width: 50,
                          height: 50,
                          color: Colors.transparent,
                        );
                      },
                      tag: 'rating ${product.rating!.rate}',
                      child: SmoothStarRating(
                        allowHalfRating: true,
                        starCount: 5,
                        rating: product.rating!.rate ?? 0.0,
                        size: 25.0,
                        // isReadOnly: true,
                        color: Colors.amber,
                        borderColor: Colors.amber,
                      ),
                    ),
                    Text(
                      'Rating: ${product.rating!.rate?.toStringAsFixed(1) ?? 'No Rating'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '(${product.rating!.count ?? 0} reviews)',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              Text(
                product.description ?? 'No Description',
                style: const TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              Text(
                'Category: ${product.category ?? 'No Category'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse(product.image!);
                  final response = await http.get(url);
                  Directory appDocDir =
                      await getApplicationDocumentsDirectory();
                  String appDocPath = appDocDir.path;
                  final file = await File('$appDocPath/myItem.png')
                      .writeAsBytes(response.bodyBytes);
                  final text =
                      "${product.title} \n${product.description} \nPrice: ${product.price}";
                  await Share.shareXFiles([XFile(file.path)], text: text);
                  // Share.share(product.description ?? 'No Description');
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
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
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Share',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(CupertinoIcons.share)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
