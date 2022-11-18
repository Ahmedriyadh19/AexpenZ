// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:aexpenz/model/transaction_record_model.dart';
import 'package:aexpenz/model/profile_model.dart';

class AdminModel {
  String userName;
  String userID;
  String password;
  String phone;
  String? pic;
  String? email;
  List<ProfileModel?> profiles = [];
  List<String?> friendsIDs = [];
  List<TransactionRecordModel?> transactionRecords = [];

  AdminModel({
    required this.userName,
    required this.userID,
    required this.password,
    required this.phone,
    this.pic,
    this.email,
    required this.profiles,
    required this.friendsIDs,
    required this.transactionRecords,
  });

  AdminModel copyWith({
    String? userName,
    String? userID,
    String? password,
    String? phone,
    String? pic,
    String? email,
    List<ProfileModel?>? profiles,
    List<String?>? friendsIDs,
    List<TransactionRecordModel?>? transactionRecords,
  }) {
    return AdminModel(
      userName: userName ?? this.userName,
      userID: userID ?? this.userID,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      pic: pic ?? this.pic,
      email: email ?? this.email,
      profiles: profiles ?? this.profiles,
      friendsIDs: friendsIDs ?? this.friendsIDs,
      transactionRecords: transactionRecords ?? this.transactionRecords,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'userID': userID,
      'password': password,
      'phone': phone,
      'pic': pic,
      'email': email,
      'profiles': profiles.map((x) => x?.toMap()).toList(),
      'friendsIDs': friendsIDs,
      'transactionRecords': transactionRecords.map((x) => x?.toMap()).toList(),
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      userName: map['userName'] as String,
      userID: map['userID'] as String,
      password: map['password'] as String,
      phone: map['phone'] as String,
      pic: map['pic'] != null ? map['pic'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      profiles: List<ProfileModel?>.from((map['profiles'] as List<int>).map<ProfileModel?>((x) => ProfileModel.fromMap(x as Map<String,dynamic>),),),
      friendsIDs: List<String?>.from((map['friendsIDs'] as List<String?>)),
      transactionRecords: List<TransactionRecordModel?>.from((map['transactionRecords'] as List<int>).map<TransactionRecordModel?>((x) => TransactionRecordModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminModel.fromJson(String source) =>
      AdminModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AdminModel(userName: $userName, userID: $userID, password: $password, phone: $phone, pic: $pic, email: $email, profiles: $profiles, friendsIDs: $friendsIDs, transactionRecords: $transactionRecords)';
  }

  @override
  bool operator ==(covariant AdminModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.userName == userName &&
      other.userID == userID &&
      other.password == password &&
      other.phone == phone &&
      other.pic == pic &&
      other.email == email &&
      listEquals(other.profiles, profiles) &&
      listEquals(other.friendsIDs, friendsIDs) &&
      listEquals(other.transactionRecords, transactionRecords);
  }

  @override
  int get hashCode {
    return userName.hashCode ^
      userID.hashCode ^
      password.hashCode ^
      phone.hashCode ^
      pic.hashCode ^
      email.hashCode ^
      profiles.hashCode ^
      friendsIDs.hashCode ^
      transactionRecords.hashCode;
  }
}
