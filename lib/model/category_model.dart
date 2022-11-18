import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:aexpenz/model/transaction_record_model.dart';
class CategoryModel {
  String categoryID;
  String categoryName;
  String? categoryDescription;
  double? amount = 0.0;
  List<TransactionRecordModel?> transactionRecords = [];
  CategoryModel({
    required this.categoryID,
    required this.categoryName,
    this.categoryDescription,
    this.amount,
    required this.transactionRecords,
  });

  CategoryModel copyWith({
    String? categoryID,
    String? categoryName,
    String? categoryDescription,
    double? amount,
    List<TransactionRecordModel?>? transactionRecords,
  }) {
    return CategoryModel(
      categoryID: categoryID ?? this.categoryID,
      categoryName: categoryName ?? this.categoryName,
      categoryDescription: categoryDescription ?? this.categoryDescription,
      amount: amount ?? this.amount,
      transactionRecords: transactionRecords ?? this.transactionRecords,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryID': categoryID,
      'categoryName': categoryName,
      'categoryDescription': categoryDescription,
      'amount': amount,
      'transactionRecords': transactionRecords.map((x) => x?.toMap()).toList(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryID: map['categoryID'] as String,
      categoryName: map['categoryName'] as String,
      categoryDescription: map['categoryDescription'] != null ? map['categoryDescription'] as String : null,
      amount: map['amount'] != null ? map['amount'] as double : null,
      transactionRecords: List<TransactionRecordModel?>.from((map['transactionRecords'] as List<int>).map<TransactionRecordModel?>((x) => TransactionRecordModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategoryModel(categoryID: $categoryID, categoryName: $categoryName, categoryDescription: $categoryDescription, amount: $amount, transactionRecords: $transactionRecords)';
  }

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;

    return other.categoryID == categoryID &&
        other.categoryName == categoryName &&
        other.categoryDescription == categoryDescription &&
        other.amount == amount &&
        listEquals(other.transactionRecords, transactionRecords);
  }

  @override
  int get hashCode {
    return categoryID.hashCode ^
        categoryName.hashCode ^
        categoryDescription.hashCode ^
        amount.hashCode ^
        transactionRecords.hashCode;
  }
}
