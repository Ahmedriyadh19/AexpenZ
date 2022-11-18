import 'package:aexpenz/controller/init_data.dart';
import 'package:aexpenz/model/admin_model.dart';
import 'package:aexpenz/view/content/loading.dart';
import 'package:aexpenz/view/main_pages/home_page.dart';
import 'package:aexpenz/view/main_pages/registration_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final bool isDark;
  const LoginPage({Key? key, required this.isDark}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Color _darkColor = const Color.fromARGB(255, 66, 66, 66);
  final Color _lightColor = Colors.blue;
  late bool _isDark;
  bool _isHidden = true, _hasError = false;
  String? errorText, userNameError, passwordError;
  TextEditingController userNameControl = TextEditingController();
  TextEditingController passwordControl = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDark;
  }

  InputDecoration inputDecor(
      {required String? lab,
      required IconData icon,
      required bool? isPassword,
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
      suffixIcon: isPassword! ? hidePassword() : null,
    );
  }

  Padding userName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        autocorrect: true,
        decoration: inputDecor(
            lab: 'User name',
            icon: Icons.person,
            isPassword: false,
            error: userNameError),
        controller: userNameControl,
        onChanged: (value) {
          setState(() {
            if (value.trim().isEmpty) {
              userNameError = 'Can\'t be empty';
              wrongData();
            } else {
              userNameError = null;
              correctData();
            }
          });
        },
      ),
    );
  }

  void setVisibility() {
    setState(() {
      _isHidden = !_isHidden;
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

  IconButton hidePassword() {
    return IconButton(
        onPressed: setVisibility,
        icon: _isHidden
            ? const Icon(
                Icons.visibility,
              )
            : const Icon(
                Icons.visibility_off,
              ));
  }

  Padding password() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        autocorrect: true,
        decoration: inputDecor(
            lab: 'Password',
            icon: Icons.lock_person_rounded,
            isPassword: true,
            error: passwordError),
        controller: passwordControl,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _isHidden,
        onChanged: (value) {
          setState(() {
            if (value.trim().isEmpty) {
              passwordError = 'Can\'t be empty';
              wrongData();
            } else {
              passwordError = null;
              correctData();
            }
          });
        },
      ),
    );
  }

  Padding submitBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Tooltip(
        message: 'Login',
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  _isDark ? _darkColor : _lightColor)),
          onPressed: () {
            checkInput();
          },
          child: const Text('Login'),
        ),
      ),
    );
  }

  void setDefault() {
    setState(() {
      _isHidden = true;
      _hasError = false;
      userNameControl.clear();
      passwordControl.clear();
      passwordError = null;
      userNameError = null;
    });
  }

  void checkInput() async {
    bool ok = true;
    setState(() {
      if (userNameControl.text.trim().isEmpty || userNameControl.text.isEmpty) {
        wrongData();
        userNameError = 'Please input User Name';
        ok = false;
      } else {
        correctData();
        userNameError = null;
      }
      if (passwordControl.text.isEmpty) {
        wrongData();
        passwordError = 'Please input Password';
        ok = false;
      } else {
        correctData();
        passwordError = null;
      }
    });
    if (ok) {
      setState(() {
        correctData();
        _isLoading = true;
      });
      AdminModel a =
          IntiData.intiData(n: userNameControl.text, p: passwordControl.text);
      await IntiData.fetchContactData(a: a);
      setState(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (_) =>
                  HomePage(isDark: _isDark, adminModel: a, initialIndex: 0)),
        );
      });
    }
  }

  Padding regLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Don\'t have account!'),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  setDefault();
                });
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => RegistrationPage(isDark: _isDark)),
                );
              },
              child: const Text(
                'Register Here',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.double,
                    decorationColor: Colors.blue),
              ),
            ),
          )
        ],
      ),
    );
  }

  Column loginDesign({required double w}) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _isDark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.blue.withOpacity(0.2)),
            child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(children: [
                  userName(),
                  password(),
                  if (_hasError) errorPart(),
                  submitBtn()
                ]))),
        regLine()
      ],
    );
  }

  Center errorPart() {
    return Center(
      child: Text(
        errorText!,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  SizedBox upBar({required double h, required double w}) {
    return SizedBox(
      height: 30,
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        child: AnimatedTextKit(
          repeatForever: true,
          stopPauseOnTap: true,
          animatedTexts: [
            FadeAnimatedText('WELCOME',
                duration: const Duration(milliseconds: 2000)),
            FadeAnimatedText('WELCOME BACK',
                duration: const Duration(milliseconds: 2000))
          ],
        ),
      ),
    );
  }

  Center body({required double myHeight, required double myWidth}) {
    return Center(
        child: SingleChildScrollView(
      child: Column(
        children: [upBar(h: myHeight, w: myWidth), loginDesign(w: myWidth)],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    double myWidth = MediaQuery.of(context).size.width;
    double myHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
            body: _isLoading
                ? Loading(isDark: _isDark)
                : body(myHeight: myHeight, myWidth: myWidth)));
  }
}
