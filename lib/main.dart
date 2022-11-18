import 'package:aexpenz/controller/init_data.dart';
import 'package:aexpenz/model/admin_model.dart';
import 'package:aexpenz/view/main_pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_manager/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences p = await SharedPreferences.getInstance();
  bool? temp = p.getBool('isDark') ?? true;
  runApp(MyApp(isDark: temp));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  const MyApp({
    Key? key,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminModel admin =
        IntiData.intiData(n: 'Ahmed', p: 'passwordControl.text');
    IntiData.fetchContactData(a: admin);
    return ThemeManager(
      defaultBrightnessPreference:
          isDark ? BrightnessPreference.dark : BrightnessPreference.light,
      data: (Brightness brightness) => ThemeData(
        primarySwatch: Colors.blue,
        brightness: brightness,
      ),
      loadBrightnessOnStart: true,
      themedWidgetBuilder: (BuildContext context, ThemeData theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: HomePage(adminModel: admin, initialIndex: 0, isDark: isDark),
        );
      },
    );
  }
}
