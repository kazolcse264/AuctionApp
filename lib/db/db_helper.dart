
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bid_price_model.dart';
import '../models/date_model.dart';
import '../models/product_models.dart';
import '../models/user_model.dart';

class DbHelper {
  static const String collectAdmin = 'Admins';
  static final _db = FirebaseFirestore.instance;

  static Future<bool> doesUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUsers).doc(uid).get();
    return snapshot.exists;
  }

  static Future<void> addUser(UserModel userModel) {
    final doc = _db.collection(collectionUsers).doc(userModel.userId);
    return doc.set(userModel.toMap());
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(
          String uid) =>
      _db.collection(collectionUsers).doc(uid).snapshots();

  static Future<void> addAuction(ProductModel productModel) {
    final wb = _db.batch(); //write batch
    final productDoc = _db
        .collection(collectionProducts)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    productModel.productId = productDoc.id;
    wb.set(productDoc, productModel.toMap());
    return wb.commit();
  }

  static Future<void> addBidPrice(BidPriceModel bidPriceModel) {
    final doc = _db
        .collection(collectionProducts)
        .doc(bidPriceModel.productId)
        .collection(collectionBidPrices)
        .doc();
    bidPriceModel.bidingId = doc.id;
    return doc.set(bidPriceModel.toMap());
  }
  static Future<QuerySnapshot<Map<String, dynamic>>> getBidPriceByProduct(
      String proId) =>
      _db
          .collection(collectionProducts)
          .doc(proId)
          .collection(collectionBidPrices)
          .get();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllAuctionProducts() {
    final collectionRef = _db.collection(collectionProducts).where(
          '$productFieldAuctionExpiredDateModel.$dateFieldTimestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(
            DateTime.now(),
          ),
        );
    return collectionRef.snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsByUserId(
          String userId) =>
      _db
          .collection(collectionProducts)
          .where(productFieldUserId, isEqualTo: userId)
          .snapshots();

  static Future<void> updateProductField(
      String productId, Map<String, dynamic> map) {
    return _db.collection(collectionProducts).doc(productId).update(map);
  }

  static Future<void> updateUserProfileField(
      String uid, Map<String, dynamic> map) {
    return _db.collection(collectionUsers).doc(uid).update(map);
  }

  static Future<void> removeFromList(String productId) {
    return _db.collection(collectionProducts).doc(productId).delete();
  }
}
