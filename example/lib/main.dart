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
        menuItems: _getMenuItems(),
        highlightedIcons: _getHighlightedIcons(),
        onTapped: (int value) {
          setState(() {
            selectedIndex = value;
          });
        },
        bodyBgColor: _bgColor,
        // highlightColor: Color(0xFFFF9944),
        boxDecoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff0464EF),
                Color(0xE40464EF),
                Color(0xff51F5EA),
              ],
              stops: [
                0, 0.5, 1
              ]
          ),
        ),
        navFgColor: Colors.grey.withOpacity(0.5),
        navBgColor: Colors.white,
      ),
    );
  }

  List<Widget> _getHighlightedIcons() {
    final List<Icon> _items = List<Icon>.empty(growable: true);
    _items.add(Icon(Icons.home,));
    _items.add(Icon(Icons.shopping_cart,));
    _items.add(Icon(Icons.category,));
    _items.add(Icon(Icons.account_circle,));
    return _items;
  }

  List<Widget> _getMenuItems() {
    final List<Widget> items = List<Widget>.empty(growable: true);
    items.add(_getMenu(Icons.home_outlined, "Home"));
    items.add(_getMenu(Icons.shopping_cart_outlined, "Cart"));
    items.add(_getMenu(Icons.category_outlined, "Help"));
    items.add(_getMenu(Icons.account_circle_outlined, "Profile"));
    return items;
  }

  Widget _getMenu(final IconData icon, final String text) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.black),
        )
      ],
    );
  }
}
