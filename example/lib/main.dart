import 'package:awesome_bottom_navigation/awesome_bottom_navigation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Nav Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  @override
  _ExampleHomePageState createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  int selectedIndex = 0;
  final _bgColor = Color(0xFFF6F6F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: _bgColor,
        child: Center(
          child: Text("Selected Page: $selectedIndex"),
        ),
      ),
      bottomNavigationBar: AwesomeBottomNav(
        icons: [
          Icons.home_outlined,
          Icons.shopping_cart_outlined,
          Icons.category_outlined,
          Icons.account_circle_outlined,
          // Icons.settings_outlined,
        ],
        highlightedIcons: [
          Icons.home,
          Icons.shopping_cart,
          Icons.category,
          Icons.account_circle,
          // Icons.settings,
        ],
        onTapped: (int value) {
          setState(() {
            selectedIndex = value;
          });
        },
        bodyBgColor: _bgColor,
        highlightColor: Color(0xFFFF9944),
        navFgColor: Colors.grey.withOpacity(0.5),
        navBgColor: Colors.white,
      ),
    );
  }
}
