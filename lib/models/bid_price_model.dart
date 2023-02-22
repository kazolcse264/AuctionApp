import 'package:auction_app/models/user_model.dart';

const String collectionBidPrices = 'BidPrices';
const String bidPriceFieldBidingId = 'bidingId';
const String bidPriceFieldBidUserModel = 'bidUserModel';
const String bidPriceFieldProductId = 'productId';
const String bidPriceFieldBidPrice = 'bidPrice';
const String bidPriceFieldIsBiding = 'isBiding';

class BidPriceModel {
  String? bidingId;
  UserModel bidUserModel;
  String productId;
  num bidPrice;
  bool isBiding;

  BidPriceModel({
    this.bidingId,
    required this.bidUserModel,
    required this.productId,
    required this.bidPrice,
    this.isBiding = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      bidPriceFieldBidingId: bidingId,
      bidPriceFieldBidUserModel: bidUserModel.toMap(),
      bidPriceFieldProductId: productId,
      bidPriceFieldBidPrice: bidPrice,
      bidPriceFieldIsBiding: isBiding,
    };
  }

  factory BidPriceModel.fromMap(Map<String, dynamic> map) => BidPriceModel(
        bidingId: map[bidPriceFieldBidingId],
        bidUserModel: UserModel.fromMap(map[bidPriceFieldBidUserModel]),
        productId: map[bidPriceFieldProductId],
        bidPrice: map[bidPriceFieldBidPrice],
        isBiding: map[bidPriceFieldIsBiding],
      );
}
