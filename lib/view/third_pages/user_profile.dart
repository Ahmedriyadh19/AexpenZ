import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:aexpenz/model/admin_model.dart';
import 'package:aexpenz/view/main_pages/home_page.dart';

class UserAccount extends StatefulWidget {
  final int holdIndex;
  const UserAccount({
    Key? key,
    required this.holdIndex,
  }) : super(key: key);

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  AdminModel a = HomePageState.adminModel;
  late int _holdIndex;
  late final bool _isDark;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isDark = HomePageState.isDark;
      _holdIndex = widget.holdIndex;
    });
  }

  Container upBar({required double h, required double w}) {
    return Container(
      margin: EdgeInsets.only(top: h / 18, bottom: 0),
      padding: EdgeInsets.only(left: w / 20, right: w / 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        backBtn(h: h, w: w),
        AnimatedTextKit(
          repeatForever: true,
          stopPauseOnTap: true,
          animatedTexts: [
            WavyAnimatedText('Account',
                textStyle:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                speed: const Duration(seconds: 1)),
          ],
        ),
        const SizedBox(
          height: 20,
          width: 20,
        )
      ]),
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
                        adminModel: a,
                        isDark: _isDark,
                        initialIndex: _holdIndex,
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
                    adminModel: a,
                    isDark: _isDark,
                    initialIndex: _holdIndex,
                  )),
        ) ??
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
            children: [upBar(h: myHeight, w: myWidth)],
          ),
        ));
  }
}
