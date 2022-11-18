import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:aexpenz/model/category_model.dart';

class ProfileModel {
  String profileID;
  String profileName;
  String? profileDescription;
  List<CategoryModel?> categoriesModel = [];
  ProfileModel({
    required this.profileID,
    required this.profileName,
    this.profileDescription,
    required this.categoriesModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profileID': profileID,
      'profileName': profileName,
      'profileDescription': profileDescription,
      'categoriesModel': categoriesModel.map((x) => x?.toMap()).toList(),
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      profileID: map['profileID'] as String,
      profileName: map['profileName'] as String,
      profileDescription: map['profileDescription'] != null
          ? map['profileDescription'] as String
          : null,
      categoriesModel: List<CategoryModel?>.from(
        (map['categoriesModel'] as List<int>).map<CategoryModel?>(
          (x) => CategoryModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProfileModel(profileID: $profileID, profileName: $profileName, profileDescription: $profileDescription, categoriesModel: $categoriesModel)';
  }

  @override
  bool operator ==(covariant ProfileModel other) {
    if (identical(this, other)) return true;

    return other.profileID == profileID &&
        other.profileName == profileName &&
        other.profileDescription == profileDescription &&
        listEquals(other.categoriesModel, categoriesModel);
  }

  @override
  int get hashCode {
    return profileID.hashCode ^
        profileName.hashCode ^
        profileDescription.hashCode ^
        categoriesModel.hashCode;
  }

  ProfileModel copyWith({
    String? profileID,
    String? profileName,
    String? profileDescription,
    List<CategoryModel?>? categoriesModel,
  }) {
    return ProfileModel(
      profileID: profileID ?? this.profileID,
      profileName: profileName ?? this.profileName,
      profileDescription: profileDescription ?? this.profileDescription,
      categoriesModel: categoriesModel ?? this.categoriesModel,
    );
  }
}
