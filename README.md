# Awesome Bottom Navigation

Custom bottom navigation bar using flutter. UI inspiration from [Dribble](https://dribbble.com/shots/6005981-Tab-Bar-Animation-nr-2).

![Preview](https://media.giphy.com/media/bDaJZ80hHPRyJsBGfB/giphy.gif)

## Basic Usage

```dart
bottomNavigationBar: AwesomeBottomNav(
    icons: [
        Icons.home_outlined,
        Icons.shopping_cart_outlined,
        Icons.category_outlined,
        Icons.account_circle_outlined,
    ],
    highlightedIcons: [
        Icons.home,
        Icons.shopping_cart,
        Icons.category,
        Icons.account_circle,
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
```
