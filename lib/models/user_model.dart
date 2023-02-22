import 'package:cloud_firestore/cloud_firestore.dart';

const String collectionUsers = 'Users';
const String userFieldUserId = 'userId';
const String userFieldDisplayName = 'displayName';
const String userFieldUserImageUrl = 'imageUrl';
const String userFieldGender = 'gender';
const String userFieldPhone = 'phone';
const String userFieldEmail = 'email';
const String userFieldAge = 'age';
const String userFieldUserCreationTime = 'userCreationTime';

class UserModel {
  String? userId;
  String? displayName;
  String? imageUrl;
  String? gender;
  String? phone;
  String email;
  String? age;
  Timestamp? userCreationTime;

  UserModel({
    this.userId,
    this.displayName,
    this.imageUrl,
    this.gender,
    this.phone,
    required this.email,
    this.age,
    this.userCreationTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      userFieldUserId: userId,
      userFieldDisplayName: displayName,
      userFieldUserImageUrl: imageUrl,
      userFieldGender: gender,
      userFieldPhone: phone,
      userFieldEmail: email,
      userFieldAge: age,
      userFieldUserCreationTime: userCreationTime,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        userId: map[userFieldUserId],
        displayName: map[userFieldDisplayName],
        imageUrl: map[userFieldUserImageUrl],
        gender: map[userFieldGender],
        phone: map[userFieldPhone],
        email: map[userFieldEmail],
        age: map[userFieldAge],
        userCreationTime: map[userFieldUserCreationTime],
      );
}
