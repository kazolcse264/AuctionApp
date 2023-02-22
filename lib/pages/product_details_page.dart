import 'package:auction_app/providers/user_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../models/bid_price_model.dart';
import '../models/product_models.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/product_details_page';

  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductProvider productProvider;
  late UserProvider userProvider;
  late ProductModel product;
  final focusNode = FocusNode();
  final bidPriceController = TextEditingController();

  @override
  void didChangeDependencies() {
    productProvider = Provider.of<ProductProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
    product = ModalRoute.of(context)!.settings.arguments as ProductModel;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: product.thumbnailImageModel.imageDownloadUrl,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          ListTile(
            title: const Text(
              'Product Name ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              product.productName,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 20,
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Auction Price ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              '$currencySymbol${product.auctionPrice}',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 20,
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Product Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              product.description,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 20,
              ),
            ),
          ),
          (product.userId == AuthService.currentUser!.uid)
              ? const ListTile(
                  title: Text(
                    'Your are not eligible to Biding this product because you are owner !!!! ',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                  /*subtitle: Text(
                    '$currencySymbol${product.bidPrice.toString()}',style: const TextStyle(color: Colors.blue,fontSize: 20,),),
                  trailing: FloatingActionButton.extended(
                    label: const Text(
                      'Edit Me',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    // <-- Text
                    backgroundColor: Colors.tealAccent.withOpacity(0.5),
                    icon: const Icon(
                      // <-- Icon
                      Icons.edit,
                      size: 20.0,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      showSingleTextFieldInputDialog(
                        context: context,
                        title: 'Please re-enter your biding price',
                        onSubmit: (value) {
                          productProvider.updateProductField(product.productId!,
                              productFieldBidPrice, num.parse(value));
                        },
                      );
                    },
                  ),*/
                )
              : Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Add Your Bid Price',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextField(
                            focusNode: focusNode,
                            controller: bidPriceController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () async {
                            if (bidPriceController.text.isEmpty) return;
                            EasyLoading.show(status: 'Please wait');
                            final bidPriceModel = BidPriceModel(
                              bidUserModel: userProvider.userModel!,
                              productId: product.productId!,
                              bidPrice: num.parse(bidPriceController.text),
                            );
                            productProvider.addBidPrice(bidPriceModel);
                            EasyLoading.dismiss();
                            focusNode.unfocus();
                            setState(() {
                              bidPriceController.clear();
                            });
                            if (mounted) {
                              showMsg(context,
                                  'Thanks for your Biding. Waiting for the final result');
                            }
                          },
                          child: const Text(
                            'SUBMIT',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'All Biding information to this product',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black,),
            ),
          ),
          FutureBuilder<List<BidPriceModel>>(
            future:
            productProvider.getBidPriceByProduct(product.productId!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final commentList = snapshot.data!;
                if (commentList.isEmpty) {
                  return const Center(
                    child: Text('No biding information found'),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: commentList
                        .map((comment) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(comment.bidUserModel.displayName??
                              comment.bidUserModel.email),
                          subtitle: Text('$currencySymbol${comment.bidPrice.toString()}',style: const TextStyle(color: Colors.blue),),
                          leading: comment.bidUserModel.imageUrl == null
                              ? const Icon(Icons.person)
                              : CachedNetworkImage(
                            width: 70,
                            height: 100,
                            fit: BoxFit.fill,
                            imageUrl: comment.bidUserModel.imageUrl!,
                            placeholder: (context, url) => const Center(
                                child:
                                CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                          ),
                        ),
                      ],
                    ))
                        .toList(),
                  );
                }
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Failed to load biding'));
              }
              return const Center(
                child: Text('Loading biding'),
              );
            },
          )
        ],
      ),
    );
  }
}
