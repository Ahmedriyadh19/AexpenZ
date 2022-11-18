import 'package:aexpenz/controller/init_data.dart';
import 'package:aexpenz/model/contact_model.dart';
import 'package:aexpenz/model/transaction_record_model.dart';
import 'package:aexpenz/model/unique_id_model.dart';
import 'package:aexpenz/view/content/transaction_record_person_history.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:aexpenz/model/admin_model.dart';
import 'package:aexpenz/view/main_pages/home_page.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

class SelectedPerson extends StatefulWidget {
  final int index;
  const SelectedPerson({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<SelectedPerson> createState() => _SelectedPersonState();
}

class _SelectedPersonState extends State<SelectedPerson> {
  final Color _darkColor = const Color.fromARGB(255, 66, 66, 66);
  final Color _lightColor = Colors.blue;
  final NumberFormat _oCcy = NumberFormat('#,##0.00');
  late AdminModel _admin;
  late bool _isDark;
  late bool _isReceivedGreater;
  late bool _isEqual;
  late double _receivedAmount;
  late double _sentAmount;
  late int _index;
  late List<ContactModel> _contacts;
  String? errorField;
  List<TextEditingController> controllers =
      List.generate(2, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    setState(() {
      _admin = HomePageState.adminModel;
      _isDark = HomePageState.isDark;
      _index = widget.index;
      _contacts = IntiData.userContacts;
      refresh();
    });
  }

  void refresh() {
    setState(() {
      _receivedAmount = _contacts[_index].contactModelReceivedAmount;
      _sentAmount = _contacts[_index].contactModelSentAmount;
      _isReceivedGreater = _receivedAmount > _sentAmount;
      _isEqual = _sentAmount == _receivedAmount;
    });
  }

  Column upBar({required double h, required double w}) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: h / 15, bottom: 0),
          padding: EdgeInsets.only(left: w / 20, right: w / 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            backBtn(h: h, w: w),
            Text(_contacts[_index].contactModelName,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
              width: 20,
            )
          ]),
        ),
        SizedBox(
          width: w / 1.1,
          child: Column(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                    color: _isReceivedGreater
                        ? Colors.redAccent
                        : _isEqual
                            ? Colors.blueGrey
                            : Colors.greenAccent,
                    borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.all(3),
                child: Center(
                  child: Text(
                      _isReceivedGreater
                          ? 'You should pay     ${_oCcy.format(_receivedAmount - _sentAmount)}'
                          : _isEqual
                              ? 'Everything is settled     ${_oCcy.format(_receivedAmount - _sentAmount)}'
                              : 'Should pay you     ${_oCcy.format(_sentAmount - _receivedAmount)}',
                      style: const TextStyle(color: Colors.black)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        transactionMoney(isSend: false);
                      });
                    },
                    child: moneyBar(
                      amount: _contacts[_index].contactModelReceivedAmount,
                      amountType: 0,
                    ),
                  )),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        transactionMoney(isSend: true);
                      });
                    },
                    child: moneyBar(
                        amount: _contacts[_index].contactModelSentAmount,
                        amountType: 1),
                  ))
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Container moneyBar({
    required double amount,
    required int amountType,
  }) {
    return Container(
      height: 40,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: amountType == 0 ? Colors.greenAccent : Colors.redAccent,
          borderRadius: BorderRadius.horizontal(
              left: amountType == 0 ? const Radius.circular(15) : Radius.zero,
              right:
                  amountType == 0 ? Radius.zero : const Radius.circular(15))),
      child: Center(
        child: Text(
            amountType == 0
                ? 'Received     ${_oCcy.format(amount)}'
                : 'Sent     ${_oCcy.format(amount)}',
            style: const TextStyle(color: Colors.black)),
      ),
    );
  }

  Align backBtn({required double h, required double w}) {
    return Align(
      alignment: Alignment.topLeft,
      child: Tooltip(
        message: 'Home',
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (_) => HomePage(
                        adminModel: _admin,
                        isDark: _isDark,
                        initialIndex: 3,
                      )),
            );
          },
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (_) => HomePage(
                    adminModel: _admin,
                    isDark: _isDark,
                    initialIndex: 3,
                  )),
        ) ??
        false;
  }

  Padding actionBtns() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: SpeedDial(
        icon: Icons.more_horiz_rounded,
        backgroundColor: _isDark ? _darkColor : _lightColor,
        foregroundColor: _isDark ? Colors.white : Colors.black,
        activeIcon: Icons.close,
        activeBackgroundColor: _isDark ? _darkColor : _lightColor,
        activeForegroundColor: _isDark ? Colors.white : Colors.black,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        animationDuration: const Duration(milliseconds: 400),
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          mySpeedLItem(
            icon: Icons.arrow_downward_rounded,
            label: 'Receive Money',
            mainColor: Colors.greenAccent,
            isSend: false,
          ),
          mySpeedLItem(
              icon: Icons.arrow_upward_rounded,
              label: 'Send Money',
              mainColor: Colors.redAccent,
              isSend: true),
        ],
      ),
    );
  }

  SpeedDialChild mySpeedLItem(
      {required IconData icon,
      required Color mainColor,
      required String label,
      required bool isSend}) {
    return SpeedDialChild(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      backgroundColor: mainColor,
      foregroundColor: _isDark ? Colors.white : Colors.black,
      label: label,
      onTap: () {
        setState(() {
          transactionMoney(isSend: isSend ? true : false);
        });
      },
    );
  }

  Future transactionMoney({required bool isSend}) {
    setDefault();
    return showDialog(
      barrierColor: isSend
          ? Colors.redAccent.withOpacity(0.3)
          : Colors.greenAccent.withOpacity(0.3),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              scrollable: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title:
                  Center(child: Text(isSend ? 'Send Money' : 'Receive Money')),
              actions: [
                TextButton(
                    child: Text('Cancel',
                        style: TextStyle(
                            color: _isDark ? Colors.white : Colors.blue)),
                    onPressed: () {
                      setState(() => Navigator.of(context).pop());
                    }),
                TextButton(
                    child: Text('Submit',
                        style: TextStyle(
                            color: _isDark ? Colors.white : Colors.blue)),
                    onPressed: () {
                      setState(() {
                        isSend
                            ? processMoney(processType: isSend, ctx: ctx)
                            : processMoney(processType: isSend, ctx: ctx);
                      });
                    })
              ],
              content: SizedBox(
                height: 140,
                child: Column(
                  children: [
                    inputText(
                        isAmount: true,
                        label: isSend ? 'Send amount' : 'Receive amount',
                        setState: setState),
                    inputText(
                        isAmount: false,
                        label: 'Description',
                        setState: setState)
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Expanded inputText(
      {required String label,
      required bool isAmount,
      required Function setState}) {
    return Expanded(
      child: TextField(
        autocorrect: true,
        decoration: inputDecor(lab: label, error: isAmount ? errorField : null),
        keyboardType: isAmount ? TextInputType.number : TextInputType.multiline,
        expands: true,
        maxLines: null,
        minLines: null,
        inputFormatters: isAmount
            ? [CurrencyTextInputFormatter(symbol: '', decimalDigits: 2)]
            : null,
        controller: isAmount ? controllers[0] : controllers[1],
        onChanged: isAmount
            ? (value) {
                setState(() {
                  String temp = value.split(',').join();
                  double? hold = double.tryParse(temp);
                  hold ?? 0;
                  if (value.trim().isEmpty ||
                      (value.trim().isNotEmpty && hold! <= 0)) {
                    errorField = 'Invalid';
                  } else {
                    errorField = null;
                  }
                });
              }
            : null,
      ),
    );
  }

  InputDecoration inputDecor({required String lab, String? error}) {
    return InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        label: Text(lab),
        errorText: error);
  }

  AwesomeDialog dialogSubmitted({required String title}) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: 'Success',
        desc: 'The process of $title money has been recorded successfully',
        btnCancelOnPress: () {},
        btnOkOnPress: () {})
      ..show();
  }

  void processMoney({required bool processType, required BuildContext ctx}) {
    setState(() {
      if (controllers[0].text.trim().isNotEmpty) {
        String amount = controllers[0].text.split(',').join();
        TransactionRecordModel data = TransactionRecordModel(
            adminID: _admin.userID,
            amount: double.parse(amount),
            dateTime: DateTime.now(),
            transactionRecordID: UniqueID.generateID(),
            receiverID: IntiData.userContacts[_index].contactModelID,
            description: controllers[1].text.trim().isEmpty
                ? 'N/A'
                : controllers[1].text,
            isPayment: processType);
        processType
            ? {
                IntiData.userContacts[_index].contactModelSentAmount +=
                    double.parse(amount),
                IntiData.userContacts[_index].transactionRecords.add(data),
                _admin.transactionRecords.add(data)
              }
            : {
                IntiData.userContacts[_index].contactModelReceivedAmount +=
                    double.parse(amount),
                IntiData.userContacts[_index].transactionRecords.add(data),
                _admin.transactionRecords.add(data)
              };
        Navigator.of(ctx).pop();
        setDefault();
        dialogSubmitted(title: processType ? 'Sending' : 'Receiving');
        refresh();
      } else {
        errorField = 'Correct your data';
      }
    });
  }

  void setDefault() {
    setState(() {
      for (var element in controllers) {
        element.clear();
      }
      errorField = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async => _onBackPressed(),
        child: Scaffold(
            body: Column(children: [
              upBar(h: myHeight, w: myWidth),
              Expanded(child: TransactionRecordPersonHistory(index: _index)),
            ]),
            floatingActionButton: actionBtns()));
  }
}
