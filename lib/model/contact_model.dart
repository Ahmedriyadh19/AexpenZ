import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:aexpenz/model/transaction_record_model.dart';

class ContactModel {
  String contactModelID;
  String contactModelName;
  String adminID;
  String? contactModelPic = '';
  double contactModelSentAmount;
  double contactModelReceivedAmount;
  List<String?> contactModelPhone = [];
  List<TransactionRecordModel?> transactionRecords = [];
  List<String?> contactModelEmail = [];

  ContactModel({
    required this.contactModelID,
    required this.contactModelName,
    required this.adminID,
    this.contactModelPic,
    this.contactModelSentAmount = 0.0,
    this.contactModelReceivedAmount = 0.0,
    required this.contactModelPhone,
    required this.transactionRecords,
    required this.contactModelEmail,
  });

  ContactModel copyWith({
    String? contactModelID,
    String? contactModelName,
    String? adminID,
    String? contactModelPic,
    double? contactModelSentAmount,
    double? contactModelReceivedAmount,
    List<String?>? contactModelPhone,
    List<TransactionRecordModel?>? transactionRecords,
    List<String?>? contactModelEmail,
  }) {
    return ContactModel(
      contactModelID: contactModelID ?? this.contactModelID,
      contactModelName: contactModelName ?? this.contactModelName,
      adminID: adminID ?? this.adminID,
      contactModelPic: contactModelPic ?? this.contactModelPic,
      contactModelSentAmount:
          contactModelSentAmount ?? this.contactModelSentAmount,
      contactModelReceivedAmount:
          contactModelReceivedAmount ?? this.contactModelReceivedAmount,
      contactModelPhone: contactModelPhone ?? this.contactModelPhone,
      transactionRecords: transactionRecords ?? this.transactionRecords,
      contactModelEmail: contactModelEmail ?? this.contactModelEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'contactModelID': contactModelID,
      'contactModelName': contactModelName,
      'adminID': adminID,
      'contactModelPic': contactModelPic,
      'contactModelSentAmount': contactModelSentAmount,
      'contactModelReceivedAmount': contactModelReceivedAmount,
      'contactModelPhone': contactModelPhone,
      'transactionRecords': transactionRecords.map((x) => x?.toMap()).toList(),
      'contactModelEmail': contactModelEmail,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
        contactModelID: map['contactModelID'] as String,
        contactModelName: map['contactModelName'] as String,
        adminID: map['adminID'] as String,
        contactModelPic: map['contactModelPic'] != null
            ? map['contactModelPic'] as String
            : null,
        contactModelSentAmount: map['contactModelSentAmount'] as double,
        contactModelReceivedAmount: map['contactModelReceivedAmount'] as double,
        contactModelPhone:
            List<String?>.from((map['contactModelPhone'] as List<String?>)),
        transactionRecords: List<TransactionRecordModel?>.from(
          (map['transactionRecords'] as List<int>).map<TransactionRecordModel?>(
            (x) => TransactionRecordModel.fromMap(x as Map<String, dynamic>),
          ),
        ),
        contactModelEmail: List<String?>.from(
          (map['contactModelEmail'] as List<String?>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) =>
      ContactModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ContactModel(contactModelID: $contactModelID, contactModelName: $contactModelName, adminID: $adminID, contactModelPic: $contactModelPic, contactModelSentAmount: $contactModelSentAmount, contactModelReceivedAmount: $contactModelReceivedAmount, contactModelPhone: $contactModelPhone, transactionRecords: $transactionRecords, contactModelEmail: $contactModelEmail)';
  }

  @override
  bool operator ==(covariant ContactModel other) {
    if (identical(this, other)) return true;

    return other.contactModelID == contactModelID &&
        other.contactModelName == contactModelName &&
        other.adminID == adminID &&
        other.contactModelPic == contactModelPic &&
        other.contactModelSentAmount == contactModelSentAmount &&
        other.contactModelReceivedAmount == contactModelReceivedAmount &&
        listEquals(other.contactModelPhone, contactModelPhone) &&
        listEquals(other.transactionRecords, transactionRecords) &&
        listEquals(other.contactModelEmail, contactModelEmail);
  }

  @override
  int get hashCode {
    return contactModelID.hashCode ^
        contactModelName.hashCode ^
        adminID.hashCode ^
        contactModelPic.hashCode ^
        contactModelSentAmount.hashCode ^
        contactModelReceivedAmount.hashCode ^
        contactModelPhone.hashCode ^
        transactionRecords.hashCode ^
        contactModelEmail.hashCode;
  }
}
