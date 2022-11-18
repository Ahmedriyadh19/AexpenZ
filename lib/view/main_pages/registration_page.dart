import 'package:aexpenz/view/main_pages/login_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  final bool isDark;
  const RegistrationPage({
    Key? key,
    required this.isDark,
  }) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _isHidden1 = true;
  bool _isHidden2 = true;
  bool _hasError = false;
  late final bool _isDark;
  final Color _darkColor = const Color.fromARGB(255, 66, 66, 66);
  final Color _lightColor = Colors.blue;
  List<String?> errors = List.generate(4, ((index) => null));
  List<TextEditingController> myController =
      List.generate(4, (i) => TextEditingController());
  String? errorText;

  @override
  void initState() {
    _isDark = widget.isDark;
    super.initState();
  }

  void setVisibility({required int password}) {
    setState(() {
      password == 1 ? _isHidden1 = !_isHidden1 : _isHidden2 = !_isHidden2;
    });
  }

  IconButton hidePassword(int x) {
    return IconButton(
        onPressed: () {
          setState(() {
            setVisibility(password: x);
          });
        },
        icon: x == 1
            ? _isHidden1
                ? const Icon(
                    Icons.visibility,
                  )
                : const Icon(
                    Icons.visibility_off,
                  )
            : _isHidden2
                ? const Icon(
                    Icons.visibility,
                  )
                : const Icon(
                    Icons.visibility_off,
                  ));
  }

  Padding passwordField({required int index, required bool passwordNumber}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        autocorrect: true,
        decoration: inputDecor(
            lab: index == 1 ? 'Password' : 'Confirm Password',
            icon: Icons.lock_person_rounded,
            isPassword: true,
            passwordN: index,
            error: errors[index]),
        controller: myController[index],
        keyboardType: TextInputType.visiblePassword,
        obscureText: passwordNumber,
        onChanged: (value) {
          setState(() {
            if (value.trim().isEmpty) {
              errors[index] = 'can\'t be empty';
              wrongData();
            } else {
              errors[index] = null;
              correctData();
            }
          });
        },
      ),
    );
  }

  InputDecoration inputDecor(
      {required String? lab,
      required IconData icon,
      required bool? isPassword,
      required int? passwordN,
      required String? error}) {
    return InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      label: Text(lab!),
      icon: Icon(icon),
      errorText: error,
      suffixIcon: isPassword! ? hidePassword(passwordN!) : null,
    );
  }

  Padding normalField({required int index}) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          autocorrect: true,
          decoration: inputDecor(
              lab: index == 0 ? 'User name' : 'Mobile number',
              icon: index == 0 ? Icons.person : Icons.phone_android_rounded,
              isPassword: false,
              passwordN: index,
              error: errors[index]),
          keyboardType: index == 0 ? TextInputType.name : TextInputType.number,
          onChanged: (value) {
            String pattern = r'^(?:[+0][1-9])?[0-9]{10,15}$';
            RegExp regExp = RegExp(pattern);

            bool isPhone = regExp.hasMatch(value);
            

            setState(() {
              if (value.trim().isEmpty) {
                errors[index] = 'can\'t be empty';
                wrongData();
              } else {
                errors[index] = null;
                correctData();
              }
              if (index == 3 && !isPhone) {
                errors[index] = 'Invalid';
                wrongData();
              }
            });
          },
        ));
  }

  Align backBtn({required double h, required double w}) {
    return Align(
      alignment: Alignment.topLeft,
      child: Tooltip(
        message: 'Back',
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginPage(isDark: _isDark)),
            );
          },
        ),
      ),
    );
  }

  Center regForm() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            normalField(index: 0),
            passwordField(index: 1, passwordNumber: _isHidden1),
            passwordField(index: 2, passwordNumber: _isHidden2),
            normalField(index: 3),
            if (_hasError)
              Center(
                child: Text(
                  errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Container submitBtn({required double w}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: w / 3),
      child: Tooltip(
        message: 'Register',
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  _isDark ? _darkColor : _lightColor)),
          onPressed: () {
            checkInput();
          },
          child: const Text('Register'),
        ),
      ),
    );
  }

  void checkInput() {
    int errorFound = 0;
    setState(() {
      for (var element in errors) {
        if (element != null) {
          errorFound++;
        }
      }
      if (errorFound != 0) {
        wrongData();
      } else {
        correctData();
      }
    });
  }

  void correctData() {
    setState(() {
      _hasError = false;
      errorText = null;
    });
  }

  void wrongData() {
    setState(() {
      _hasError = true;
      errorText = 'Correct your info';
    });
  }

  Container upBar({required double h, required double w}) {
    return Container(
      margin: EdgeInsets.only(top: h / 18, bottom: 0),
      padding: EdgeInsets.only(left: w / 20, right: w / 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        backBtn(h: h, w: w),
        regText(),
        const SizedBox(
          height: 20,
          width: 20,
        )
      ]),
    );
  }

  AnimatedTextKit regText() {
    return AnimatedTextKit(
      repeatForever: true,
      stopPauseOnTap: true,
      animatedTexts: [
        WavyAnimatedText('Registration',
            textStyle:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            speed: const Duration(seconds: 1)),
      ],
    );
  }

  Future<bool> _onBackPressed() async {
    return await Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => LoginPage(isDark: _isDark))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async => _onBackPressed(),
        child: Scaffold(
            body: Column(
          children: [
            upBar(h: myHeight, w: myWidth),
            Expanded(
                child: ListView(
              children: [
                Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _isDark
                            ? Colors.black.withOpacity(0.2)
                            : Colors.blue.withOpacity(0.2)),
                    child: Column(
                      children: [
                        regForm(),
                        submitBtn(w: myWidth),
                      ],
                    ))
              ],
            )),
          ],
        )));
  }
}
