import 'package:e_commerce/Models/product_model/product_model.dart';
import 'package:e_commerce/Screens/product_detail_screen.dart';
import 'package:e_commerce/Utils/size.dart';
import 'package:e_commerce/Widgets/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => ConnectivityWrapper(
                  child: ProductDetailsScreen(
                    product: product,
                  ),
                ))),
        child: Container(
            width: double.infinity,
            height: 350,
            alignment: Alignment.center,
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
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Hero(
                    transitionOnUserGestures: true,
                    tag: 'image ${product.id}',
                    child: Image.network(
                      product.image!,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
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
                      // height: 100,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              h10,
              Text(
                product.title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "INR ${product.price!} /-",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (product.rating != null)
                    Hero(
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
                ],
              ),
            ])));
  }
}
