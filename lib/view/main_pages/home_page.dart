import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_manager/theme_manager.dart';
import 'package:aexpenz/model/admin_model.dart';
import 'package:aexpenz/view/main_pages/login_page.dart';
import 'package:aexpenz/view/second_pages/add_page.dart';
import 'package:aexpenz/view/second_pages/profiles_creator_page.dart';
import 'package:aexpenz/view/second_pages/dashboard_page.dart';
import 'package:aexpenz/view/second_pages/history_page.dart';
import 'package:aexpenz/view/second_pages/people_page.dart';
import 'package:aexpenz/view/third_pages/user_profile.dart';

class HomePage extends StatefulWidget {
  final bool isDark;
  final int initialIndex;
  final AdminModel adminModel;
  const HomePage({
    Key? key,
    required this.isDark,
    required this.initialIndex,
    required this.adminModel,
  }) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Color _darkColor = const Color.fromARGB(255, 66, 66, 66);
  final Color _tranColor = const Color.fromARGB(0, 0, 0, 0);
  final Color _lightColor = Colors.blue;
  static late bool isDark;
  static late AdminModel adminModel;
  int _indexPage = 0;
  final List<Widget> _pages = [];
  final List<String> _titles = [
    'Dashboard',
    'History',
    'Add',
    'People List',
    'Profiles'
  ];

  void rebuildInfo() {
    _pages.clear();
    _pages.add(const DashboardPage());
    _pages.add(const HistoryPage());
    _pages.add(const AddPage());
    _pages.add(const PeoplePage());
    _pages.add(const ProfilesCreatorPage());
  }

  @override
  void initState() {
    isDark = widget.isDark;
    adminModel = widget.adminModel;
    _indexPage = widget.initialIndex;
    rebuildInfo();
    super.initState();
  }

  Future setData() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setBool('isDark', isDark);
  }

  void setDark() {
    setData();
    setState(() {
      ThemeManager.of(context).setBrightnessPreference(
          isDark ? BrightnessPreference.dark : BrightnessPreference.light);
      _indexPage = 3;
    });
  }

  Tooltip darkBtn() {
    return Tooltip(
      message: isDark ? 'Light mode' : 'Dark mode',
      child: IconButton(
        icon: Icon(isDark ? Icons.sunny : FontAwesomeIcons.moon),
        onPressed: () {
          setState(() {
            isDark = !isDark;
            setDark();
            Navigator.of(context).pop();
          });
        },
      ),
    );
  }

  CurvedNavigationBar bottomBar() {
    return CurvedNavigationBar(
      index: _indexPage,
      items: const [
        Icon(Icons.dashboard, size: 30),
        Icon(Icons.history_rounded, size: 30),
        Icon(Icons.add, size: 30),
        Icon(Icons.groups_rounded, size: 30),
        Icon(Icons.call_split, size: 30)
      ],
      color: isDark ? _darkColor : _lightColor,
      buttonBackgroundColor: isDark ? _darkColor : _lightColor,
      backgroundColor: _tranColor,
      animationCurve: Curves.easeOutQuad,
      animationDuration: const Duration(seconds: 1),
      onTap: (index) {
        setState(() {
          rebuildInfo();
          _indexPage = index;
        });
      },
    );
  }

  Builder menuBtn() {
    return Builder(builder: (context) {
      return IconButton(
        icon: const FaIcon(FontAwesomeIcons.barsStaggered),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      );
    });
  }

  Drawer myDrawer({required double h, required double w}) {
    return Drawer(
      elevation: 20,
      child: Column(children: [myDrawerBody(h: h)]),
    );
  }

  SizedBox myDrawerBody({required double h}) {
    return SizedBox(
      height: h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: h / 4,
            width: double.maxFinite,
            color: isDark ? _darkColor : _lightColor,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [SizedBox(height: h / 20), titleDrawer()],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                signOutBtn(),
                darkBtn(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Align titleDrawer() {
    return Align(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, ${adminModel.userName}'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text('ID: '),
                  SizedBox(
                    child: SelectableText(
                      adminModel.userID,
                    ),
                  ),
                  copyIdBtn()
                ],
              ),
            ),
          ],
        ));
  }

  Builder copyIdBtn() {
    return Builder(builder: (context) {
      return IconButton(
        icon: const Icon(Icons.copy_rounded),
        onPressed: () {
          setState(() {
            Clipboard.setData(ClipboardData(text: adminModel.userID));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(milliseconds: 800),
              content: Text('Copied!', textAlign: TextAlign.center),
            ));
            Navigator.of(context).pop();
          });
        },
      );
    });
  }

  Tooltip signOutBtn() {
    return Tooltip(
      message: 'Logout',
      child: IconButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(isDark ? _darkColor : _lightColor)),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (_) => LoginPage(
                      isDark: isDark,
                    )),
          );
        },
        icon: const Icon(Icons.logout_rounded),
      ),
    );
  }

  Container upBar({required double h, required double w}) {
    return Container(
      margin: EdgeInsets.only(top: h / 18, bottom: 0),
      padding: EdgeInsets.only(left: w / 20, right: w / 20),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [menuBtn(), titleText(), userProfileBtn()]),
    );
  }

  Text titleText() {
    return Text(
      _titles[_indexPage],
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  IconButton userProfileBtn() {
    return IconButton(
      onPressed: () {
        setState(() {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (_) => UserAccount(
                      holdIndex: _indexPage,
                    )),
          );
        });
      },
      icon: const Icon(Icons.person),
    );
  }

  Column body({required double h, required double w}) {
    return Column(
      children: [
        Container(child: upBar(h: h, w: w)),
        Expanded(
          child: _pages[_indexPage],
        ),
      ],
    );
  }

  dynamic _onBackPressed() {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Exit',
      desc: 'You are going to exit the App.\nAre you Sure!',
      btnCancelOnPress: () {},
      btnOkOnPress: () =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => _onBackPressed(),
      child: Scaffold(
        bottomNavigationBar: bottomBar(),
        body: body(h: myHeight, w: myWidth),
        drawer: myDrawer(h: myHeight, w: myWidth),
      ),
    );
  }
}
