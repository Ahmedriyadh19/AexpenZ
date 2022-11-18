import 'package:aexpenz/model/admin_model.dart';
import 'package:aexpenz/view/main_pages/home_page.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Container> show = [];
  late bool _isDark;
  AdminModel a = HomePageState.adminModel;
  late int profiles;

  @override
  void initState() {
    _isDark = HomePageState.isDark;
    profiles = a.profiles.length;
    for (int i = 0; i < profiles; i++) {
      show.add(
          buildShow(color: i.toDouble(), name: a.profiles[i]!.profileName));
    }
    super.initState();
  }

  Container buildShow({required double color, required String name}) {
    return Container(
      color: _isDark ? Colors.grey : Colors.blue,
      child: Center(child: Text(name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return show[index];
              },
              itemCount: profiles,
              itemWidth: w / 1.2,
              itemHeight: h / 1.5,
              layout: SwiperLayout.STACK,
              autoplay: true,
              autoplayDelay: 10000,
            ),
          ),
        ],
      ),
    );
  }
}
