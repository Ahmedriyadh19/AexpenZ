import 'package:aexpenz/model/admin_model.dart';
import 'package:aexpenz/model/category_model.dart';
import 'package:aexpenz/model/transaction_record_model.dart';
import 'package:aexpenz/model/unique_id_model.dart';
import 'package:aexpenz/view/main_pages/home_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final AdminModel _admin = HomePageState.adminModel;
  final List<bool> _isActives = List.generate(4, ((index) => false));
  final Color _darkColor = const Color.fromARGB(255, 66, 66, 66);
  final Color _lightColor = Colors.blue;
  final bool _isDark = HomePageState.isDark;
  bool _isDone = false;
  int _currentStep = 0;
  int _profileIndex = 0;
  int _categoryIndex = 0;
  double _amount = 0.0;
  String _description = '';
  List<String> profileTitles = [];
  List<String> categoryTitles = [];
  String _selectedProfile = '';
  String _selectedCategory = '';
  String? _errorAmountField;
  List<TextEditingController> controllers =
      List.generate(2, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    setDefault();
  }

  void buildProfileTitles() {
    profileTitles.clear();
    for (var element in _admin.profiles) {
      profileTitles.add(element!.profileName);
    }
    _selectedProfile = profileTitles[0];
  }

  void buildCategoryTitles({required int targetIndex}) {
    categoryTitles.clear();
    for (var element in _admin.profiles[targetIndex]!.categoriesModel) {
      categoryTitles.add(element!.categoryName);
    }
    _selectedCategory = categoryTitles[0];
  }

  Padding buildDropMenuSelection({required double w, required isProfile}) {
    return Padding(
      padding: const EdgeInsets.only(right: 100),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: isProfile ? _selectedProfile : _selectedCategory,
          items: isProfile
              ? profileTitles.map(buildMenuItem).toList()
              : categoryTitles.map(buildMenuItem).toList(),
          onChanged: (value) {
            setState(() {
              if (isProfile) {
                _selectedProfile = value;
                for (int i = 0; i < _admin.profiles.length; i++) {
                  if (_selectedProfile == _admin.profiles[i]!.profileName) {
                    _profileIndex = i;
                    buildCategoryTitles(targetIndex: _profileIndex);
                  }
                }
              } else {
                _selectedCategory = value;
                for (int i = 0;
                    i < _admin.profiles[_profileIndex]!.categoriesModel.length;
                    i++) {
                  if (_selectedCategory ==
                      _admin.profiles[_profileIndex]!.categoriesModel[i]!
                          .categoryName) {
                    _categoryIndex = i;
                  }
                }
              }
            });
          },
        ),
      ),
    );
  }

  DropdownMenuItem buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      );

  List<Step> steps({required double myWidth}) {
    return [
      Step(
          subtitle: Text.rich(TextSpan(text: 'Select a profile ', children: [
            TextSpan(
                text: _selectedProfile,
                style: const TextStyle(fontWeight: FontWeight.bold))
          ])),
          title: const Text('Profile'),
          content: buildDropMenuSelection(w: myWidth, isProfile: true),
          isActive: _isActives[0]),
      Step(
          subtitle:
              Text.rich(TextSpan(text: 'Select a category from ', children: [
            TextSpan(
                text: _selectedProfile,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: _isActives[1] ? ' Category selected is ' : ''),
            TextSpan(
                text: _isActives[1] ? _selectedCategory : '',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ])),
          title: const Text('Category'),
          content: buildDropMenuSelection(w: myWidth, isProfile: false),
          isActive: _isActives[1]),
      Step(
          subtitle: Text.rich(TextSpan(text: 'Enter the Amount', children: [
            TextSpan(
                text: controllers[0].text.trim().isEmpty ? ' eg 10.00' : ''),
            TextSpan(
                text: controllers[0].text.trim().isNotEmpty
                    ? ' Your Amount is ${controllers[0].text}'
                    : '',
                style: const TextStyle(fontWeight: FontWeight.bold))
          ])),
          title: const Text('Amount'),
          content: Center(
              child: inputText(
            isAmount: true,
            label: 'Amount',
          )),
          isActive: _isActives[2]),
      Step(
          subtitle: const Text('Write your description'),
          title: const Text('Description'),
          content: Center(
              child: inputText(
            isAmount: false,
            label: 'Description',
          )),
          isActive: _isActives[3]),
    ];
  }

  TextField inputText({required String label, required bool isAmount}) {
    return TextField(
      autocorrect: true,
      decoration:
          inputDecor(lab: label, error: isAmount ? _errorAmountField : null),
      keyboardType: isAmount ? TextInputType.number : TextInputType.multiline,
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
                  _errorAmountField = 'Invalid';
                  _isDone = false;
                } else {
                  _errorAmountField = null;
                  _isDone = true;
                }
              });
            }
          : null,
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

  Stepper myStepper({required double w}) {
    return Stepper(
        elevation: 20,
        controlsBuilder: (context, details) {
          return Row(
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        _isDark ? _darkColor : _lightColor)),
                onPressed: details.onStepContinue,
                child: const Text('Continue'),
              ),
              const SizedBox(width: 25),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        _isDark ? _darkColor : _lightColor)),
                onPressed: details.onStepCancel,
                child: const Text('Back'),
              ),
            ],
          );
        },
        currentStep: _currentStep,
        onStepCancel: _currentStep > 0
            ? () {
                setState(() {
                  _isActives[_currentStep] = false;
                  _currentStep -= 1;
                });
              }
            : null,
        onStepContinue: _currentStep < _isActives.length - 1
            ? () {
                setState(() {
                  _currentStep += 1;
                  _isActives[_currentStep] = true;
                });
              }
            : null,
        steps: steps(myWidth: w));
  }

  Container submitBtn({required double w}) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: w / 4),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(_isDark ? _darkColor : _lightColor)),
        onPressed: () {
          setState(() {
            if (controllers[0].text.trim().isNotEmpty) {
              CategoryModel targetedCategory = _admin
                  .profiles[_profileIndex]!.categoriesModel[_categoryIndex]!;
              _amount = double.parse(controllers[0].text.split(',').join());
              _description = controllers[1].text.trim().isEmpty
                  ? 'N/A'
                  : controllers[1].text.trim();
              TransactionRecordModel hold = TransactionRecordModel(
                  adminID: _admin.userID,
                  dateTime: DateTime.now(),
                  description: _description,
                  transactionRecordID: UniqueID.generateID(),
                  amount: _amount,
                  receiverID: targetedCategory.categoryID,
                  isPayment: true);
              _admin.profiles[_profileIndex]!.categoriesModel[_categoryIndex]!
                  .transactionRecords
                  .add(hold);
            }
            HomePageState.adminModel = _admin;
            setDefault();
            dialogSubmitted();
          });
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.save_rounded),
              SizedBox(width: 5),
              Text('Save')
            ]),
      ),
    );
  }

  void setDefault() {
    setState(() {
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].clear();
      }
      for (int i = 0; i < _isActives.length; i++) {
        _isActives[i] = false;
      }
      _amount = 0.0;
      _currentStep = 0;
      _categoryIndex = 0;
      _profileIndex = 0;
      _description = '';
      _errorAmountField = null;
      _isDone = false;
      _isActives[0] = true;
      buildProfileTitles();
      buildCategoryTitles(targetIndex: 0);
    });
  }

  AwesomeDialog dialogSubmitted() {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: 'Success',
        desc: 'The process of payment money has been recorded successfully',
        btnCancelOnPress: () {},
        btnOkOnPress: () {})
      ..show();
  }

  @override
  Widget build(BuildContext context) {
    double myWidth = MediaQuery.of(context).size.width;
    return Center(
        child: ListView(shrinkWrap: true, children: [
      myStepper(w: myWidth),
      if (_isDone && _isActives[2]) submitBtn(w: myWidth)
    ]));
  }
}
