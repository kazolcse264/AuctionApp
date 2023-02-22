
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/bid_price_model.dart';
import '../models/image_model.dart';
import '../models/product_models.dart';
import '../utils/constants.dart';


class ProductProvider extends ChangeNotifier {
  List<ProductModel> auctionProductList = [];
  List<num> bidPriceList = [];
  Future<void> addAuction(ProductModel productModel) =>
      DbHelper.addAuction(productModel);

  Future<void> addBidPrice(BidPriceModel bidPriceModel) {
    return DbHelper.addBidPrice(bidPriceModel);
  }


  Future<List<BidPriceModel>> getBidPriceByProduct(String proId) async {
    final snapshot = await DbHelper.getBidPriceByProduct(proId);
    final bidPriceList = List.generate(snapshot.docs.length,
            (index) => BidPriceModel.fromMap(snapshot.docs[index].data()));
    return bidPriceList;
  }
  getAllAuctionProducts(){
    DbHelper.getAllAuctionProducts().listen((snapshots) {
      auctionProductList = List.generate(snapshots.docs.length,
              (index) => ProductModel.fromMap(snapshots.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> updateProductField(
      String productId, String field, dynamic value) {
    return DbHelper.updateProductField(productId, {field: value});
  }

  Future<ImageModel> uploadImage(String path) async {
    final imageName = 'pro_${DateTime.now().millisecondsSinceEpoch}';
    final imageRef = FirebaseStorage.instance
        .ref()
        .child('$firebaseStorageProductImageDir/$imageName');
    final uploadTask = imageRef.putFile(File(path));
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return ImageModel(title: imageName, imageDownloadUrl: downloadUrl);
  }

}
