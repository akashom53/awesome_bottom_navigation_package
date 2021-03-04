# Awesome Bottom Navigation

Custom bottom navigation bar using flutter. UI inspiration from [Dribble](https://dribbble.com/shots/6005981-Tab-Bar-Animation-nr-2).

![Preview](https://media.giphy.com/media/bDaJZ80hHPRyJsBGfB/giphy.gif)

## Getting Started

Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  ...
  awesome_bottom_navigation: ^0.0.1
```

## Basic Usage

Import the package

```dart
import 'package:awesome_bottom_navigation/awesome_bottom_navigation.dart';
```

Use it in your app

```dart
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
```
