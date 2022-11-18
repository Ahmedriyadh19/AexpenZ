import 'dart:convert';

class TransactionRecordModel {
  String transactionRecordID;
  String adminID;
  String receiverID;
  String description;
  bool isPayment;
  double amount;
  DateTime dateTime;

  TransactionRecordModel({
    required this.transactionRecordID,
    required this.adminID,
    required this.receiverID,
    required this.description,
    required this.isPayment,
    required this.amount,
    required this.dateTime,
  });

  TransactionRecordModel copyWith({
    String? transactionRecordID,
    String? adminID,
    String? receiverID,
    String? description,
    bool? isPayment,
    double? amount,
    DateTime? dateTime,
  }) {
    return TransactionRecordModel(
      transactionRecordID: transactionRecordID ?? this.transactionRecordID,
      adminID: adminID ?? this.adminID,
      receiverID: receiverID ?? this.receiverID,
      description: description ?? this.description,
      isPayment: isPayment ?? this.isPayment,
      amount: amount ?? this.amount,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transactionRecordID': transactionRecordID,
      'adminID': adminID,
      'receiverID': receiverID,
      'description': description,
      'isPayment': isPayment,
      'amount': amount,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory TransactionRecordModel.fromMap(Map<String, dynamic> map) {
    return TransactionRecordModel(
      transactionRecordID: map['transactionRecordID'] as String,
      adminID: map['adminID'] as String,
      receiverID: map['receiverID'] as String,
      description: map['description'] as String,
      isPayment: map['isPayment'] as bool,
      amount: map['amount'] as double,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionRecordModel.fromJson(String source) =>
      TransactionRecordModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransactionRecordModel(transactionRecordID: $transactionRecordID, adminID: $adminID, receiverID: $receiverID, description: $description, isPayment: $isPayment, amount: $amount, dateTime: $dateTime)';
  }

  @override
  bool operator ==(covariant TransactionRecordModel other) {
    if (identical(this, other)) return true;

    return other.transactionRecordID == transactionRecordID &&
        other.adminID == adminID &&
        other.receiverID == receiverID &&
        other.description == description &&
        other.isPayment == isPayment &&
        other.amount == amount &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode {
    return transactionRecordID.hashCode ^
        adminID.hashCode ^
        receiverID.hashCode ^
        description.hashCode ^
        isPayment.hashCode ^
        amount.hashCode ^
        dateTime.hashCode;
  }
}
