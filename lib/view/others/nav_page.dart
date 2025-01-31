import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weeklydish/view/menu_page/menu_page.dart';
import 'package:weeklydish/view/settings_page/settings_page.dart';
import 'package:weeklydish/view/shopping_page/shopping_page.dart';
import '../planner_page/menu_planner_page.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  // Current Index
  int currentIndex = 0;

  // Pages
  final List<Widget> pages = [
    const MenuPage(),
    MenuPlannerPage(),
    const ShoppingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Weekly Dish",
            style: GoogleFonts.birthstone(
              fontSize: 30,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            )),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SettingsPage();
              }));
            },
          ),
        ],
      ),

      // Body
      body: pages[currentIndex],

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.menu_book_rounded), label: "menu".tr()),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_outlined),
            label: "list".tr(),
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              label: "shoppingList".tr()),
        ],
      ),
    );
  }
}
