import 'package:payment/services/custom_background.dart';

import 'package:payment/profile_page.dart';

import 'package:payment/screens/shop/check_out_page.dart';
import 'package:flutter/material.dart';

import 'package:payment/screens/categories.dart';
import 'package:payment/screens/home_screen.dart';

import 'components/custom_bottom_bar.dart';

class MainPage extends StatefulWidget {
  static const routeName = "/MainPage";
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin<MainPage> {
  late TabController tabController;
  late TabController bottomTabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    bottomTabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(controller: bottomTabController),
      body: CustomPaint(
        painter: MainBackground(),
        child: TabBarView(
          controller: bottomTabController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            HomeScreen(),
            CategoriesScreen(),
            CheckOutPage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
