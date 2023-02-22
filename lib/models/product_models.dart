import 'date_model.dart';
import 'image_model.dart';

const String collectionProducts = 'Products';
const String productFieldProductId = 'productId';
const String productFieldUserId = 'userId';
const String productFieldProductName = 'productName';
const String productFieldDescription = 'description';
const String productFieldAuctionPrice = 'auctionPrice';
const String productFieldThumbnail = 'thumbnail';
const String productFieldAuctionExpiredDateModel = 'auctionExpiredDateModel';

class ProductModel {
  String? productId;
  String userId;
  String productName;
  String description;
  num auctionPrice;
  ImageModel thumbnailImageModel;
  DateModel auctionExpiredDateModel;

  ProductModel({
    this.productId,
    required this.userId,
    required this.productName,
    required this.description,
    required this.auctionPrice,
    required this.thumbnailImageModel,
    required this.auctionExpiredDateModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      productFieldProductId: productId,
      productFieldUserId: userId,
      productFieldProductName: productName,
      productFieldDescription: description,
      productFieldAuctionPrice: auctionPrice,
      productFieldThumbnail: thumbnailImageModel.toMap(),
      productFieldAuctionExpiredDateModel: auctionExpiredDateModel.toMap(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
        productId: map[productFieldProductId],
        userId: map[productFieldUserId],
        productName: map[productFieldProductName],
        description: map[productFieldDescription],
        auctionPrice: map[productFieldAuctionPrice],
        thumbnailImageModel: ImageModel.fromMap(map[productFieldThumbnail]),
        auctionExpiredDateModel:
            DateModel.fromMap(map[productFieldAuctionExpiredDateModel]),
      );
}
