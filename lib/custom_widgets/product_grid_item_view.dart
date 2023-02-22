import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import '../models/product_models.dart';
import '../pages/product_details_page.dart';
import '../utils/constants.dart';

class ProductGridItemView extends StatelessWidget {
  final ProductModel productModel;

  const ProductGridItemView({
    Key? key,
    required this.productModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ProductDetailsPage.routeName,
            arguments: productModel);
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(45.0)),
        child: Card(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CachedNetworkImage(
                      imageUrl:
                          productModel.thumbnailImageModel.imageDownloadUrl,
                      height: 200,
                      width: 200,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Text(
                    productModel.productName,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$currencySymbol${productModel.auctionPrice}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
