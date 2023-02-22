const String imageFieldOfferId = 'offerId';
const String imageFieldOfferTitle = 'title';
const String imageFieldImageDownloadUrl = 'imageDownloadUrl';

class ImageModel {
  String? offerId;
  String title;
  String imageDownloadUrl;

  ImageModel({
    this.offerId,
    required this.title,
    required this.imageDownloadUrl,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        imageFieldOfferId: offerId,
        imageFieldOfferTitle: title,
        imageFieldImageDownloadUrl: imageDownloadUrl,
      };

  factory ImageModel.fromMap(Map<String, dynamic> map) => ImageModel(
        offerId: map[imageFieldOfferId],
        title: map[imageFieldOfferTitle],
        imageDownloadUrl: map[imageFieldImageDownloadUrl],
      );
}
