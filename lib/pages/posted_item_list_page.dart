import 'package:auction_app/pages/product_details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/helper_functions.dart';

class PostedItemListPage extends StatelessWidget {
  static const String routeName = '/posted_item_list';

  const PostedItemListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posted Item List'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.productList.length,
          itemBuilder: (context, index) {
            final productModel = provider.productList[index];
            final isExpired = productModel.auctionExpiredDateModel.timestamp.compareTo(Timestamp.fromDate(DateTime.now()),)  < 0 ? true: false;
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, ProductDetailsPage.routeName,
                      arguments: productModel);
                },
                child: Card(
                  child: ListTile(
                      leading: Image.network(
                        productModel.thumbnailImageModel.imageDownloadUrl,
                        width: 70,
                      ),
                      tileColor: Colors.tealAccent.shade100,
                      title:  (isExpired) ?  RichText(
                        text:  TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: productModel.productName, style: const TextStyle(color: Colors.black,fontSize: 18, fontWeight: FontWeight.bold,),),
                            const TextSpan(text: 'Expired', style: TextStyle(color: Colors.red,fontSize: 20,),)
                          ],
                        ),
                      ):Text(
                        productModel.productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Expired Date: ${getFormattedDate(productModel.auctionExpiredDateModel.timestamp.toDate())}',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          provider.removeFromList(productModel.productId!);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 30,
                        ),
                      )),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
