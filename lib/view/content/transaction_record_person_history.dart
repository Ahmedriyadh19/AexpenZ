import 'package:aexpenz/controller/init_data.dart';
import 'package:aexpenz/model/transaction_record_model.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionRecordPersonHistory extends StatefulWidget {
  final int index;
  const TransactionRecordPersonHistory({Key? key, required this.index})
      : super(key: key);

  @override
  State<TransactionRecordPersonHistory> createState() =>
      _TransactionRecordPersonHistoryState();
}

class _TransactionRecordPersonHistoryState
    extends State<TransactionRecordPersonHistory> {
  late final int _index;
  late List<TransactionRecordModel?> _selectedContact = [];
  final NumberFormat _oCcy = NumberFormat('#,##0.00');

  @override
  void initState() {
    super.initState();
    _index = widget.index;
    _selectedContact = IntiData.userContacts[_index].transactionRecords;
  }

  Padding transactionRecord({required double w}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: title(),
          ),
          Expanded(
              child: _selectedContact.isEmpty
                  ? const Center(
                      child: Text('No record'),
                    )
                  : buildTable()),
        ],
      ),
    );
  }

  AnimatedTextKit title() {
    return AnimatedTextKit(
      repeatForever: true,
      stopPauseOnTap: true,
      animatedTexts: [
        WavyAnimatedText('History',
            textStyle:
                const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            speed: const Duration(seconds: 1)),
      ],
    );
  }

  DataTable2 buildTable() {
    return DataTable2(
        columnSpacing: 4,
        horizontalMargin: 4,
        dividerThickness: 4,
        columns: const [
          DataColumn2(
            label: Text('Date & Time'),
          ),
          DataColumn2(
            label: Text('Amount'),
          ),
          DataColumn2(
            label: Text('Description'),
          ),
          DataColumn2(
            label: Text('Transaction'),
          ),
        ],
        rows: List<DataRow2>.generate(
            _selectedContact.length,
            (index) => DataRow2(
                    color: _selectedContact[index]!.isPayment
                        ? MaterialStateProperty.all(
                            Colors.redAccent.withOpacity(0.08))
                        : MaterialStateProperty.all(
                            Colors.greenAccent.withOpacity(0.08)),
                    cells: [
                      DataCell(Text(buildDate(
                          dateTime: _selectedContact[index]!.dateTime))),
                      DataCell(
                          Text(_oCcy.format(_selectedContact[index]!.amount))),
                      DataCell(Text(_selectedContact[index]!.description)),
                      DataCell(
                          buildIcon(isPay: _selectedContact[index]!.isPayment)),
                    ])).reversed.toList());
  }

  String buildDate({required DateTime dateTime}) {
    return DateFormat.yMMMEd().add_jms().format(dateTime);
  }

  Icon buildIcon({required bool isPay}) {
    if (isPay) {
      return const Icon(Icons.arrow_upward_rounded, color: Colors.redAccent);
    }
    return const Icon(Icons.arrow_downward_rounded, color: Colors.greenAccent);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return transactionRecord(w: w);
  }
}
