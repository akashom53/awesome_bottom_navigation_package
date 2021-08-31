import 'package:flutter/material.dart';
import 'clipper.dart';
import 'consts.dart';
import 'shadow_painter.dart';
import 'custom_extension.dart';

/// A Bottom Navigation Bar that comes with beautiful animation stylish curves.
///
/// The design is inspired from a [dribble post](https://dribbble.com/shots/6005981-Tab-Bar-Animation-nr-2)
/// {@tool snippet}
///
/// This is a basic usage in a Scaffold
/// ```dart
/// Scaffold(
///   body: Container(
///     color: _bgColor,
///     child: Center(
///       child: Text("Selected Page: $selectedIndex"),
///     ),
///   ),
///   bottomNavigationBar: AwesomeBottomNav(
///     icons: [
///       Icons.home_outlined,
///       Icons.shopping_cart_outlined,
///       Icons.category_outlined,
///       Icons.account_circle_outlined,
///       // Icons.settings_outlined,
///     ],
///     highlightedIcons: [
///       Icons.home,
///       Icons.shopping_cart,
///       Icons.category,
///       Icons.account_circle,
///       // Icons.settings,
///     ],
///     onTapped: (int value) {
///       setState(() {
///         selectedIndex = value;
///       });
///     },
///     bodyBgColor: _bgColor,
///     highlightColor: Color(0xFFFF9944),
///     navFgColor: Colors.grey.withOpacity(0.5),
///     navBgColor: Colors.white,
///   ),
/// );
/// ```
class AwesomeBottomNav extends StatefulWidget {
  /// List of icons of type [IconData] to be shown in the bottom navigation in unselected state.
  // final List<IconData> icons;

  /// List of icons of type [IconData] to be shown in the bottom navigation in selected state.
  final List<Widget> highlightedIcons;

  // final List<String> iconText;

  final List<Widget> menuItems;

  /// Color of highlight
  final Color? highlightColor;
  final BoxDecoration? boxDecoration;

  final Color bodyBgColor;
  final Color navBgColor;
  final Color navFgColor;
  final ValueSetter<int> onTapped;

  const AwesomeBottomNav({
    Key? key,
    // required this.icons,
    required this.highlightedIcons,
    required this.menuItems,
    this.highlightColor,
    required this.onTapped,
    required this.bodyBgColor,
    required this.navBgColor,
    required this.navFgColor,
    this.boxDecoration,
    // required this.iconText,
  }) : super(key: key);

  @override
  _AwesomeBottomNavState createState() => _AwesomeBottomNavState();
}

class _AwesomeBottomNavState extends State<AwesomeBottomNav>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _posXAnimation;
  late Animation<double> _sinkAnimation;
  late Animation<double> _riseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _posXAnimation =
        Tween<double>(begin: 0.0, end: (_selectedIndex + 1) * 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );
    _sinkAnimation =
        Tween(begin: -40.0, end: kNavSize.toDouble()).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.25, curve: Curves.easeInOutSine),
    ));
    _riseAnimation =
        Tween(end: -40.0, begin: kNavSize.toDouble()).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.75, 1.0, curve: Curves.easeInOutSine),
    ));
  }

  void _tapped(int index) {
    if (_selectedIndex == index) return;
    _animationController.reset();
    _posXAnimation =
        Tween<double>(begin: _selectedIndex * 1.0, end: index * 1.0)
            .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutSine,
    ));
    _animationController.forward();
    setState(() {
      _selectedIndex = index;
    });
    widget.onTapped(index);
  }

  double _getMainCircleTop() {
    if (!_animationController.isAnimating) {
      return -40;
    }

    if (_animationController.value < 0.5) {
      return _sinkAnimation.value;
    } else {
      return _riseAnimation.value;
    }
  }

  double _getMainCircleLeft(Size size) {
    final totalPadding = size.width - (kNavSize * widget.highlightedIcons.length);
    final singlePadding = totalPadding / (widget.highlightedIcons.length + 1);
    return ((_animationController.isAnimating
                ? _posXAnimation.value
                : _selectedIndex) *
            kNavSize) +
        (singlePadding *
            ((_animationController.isAnimating
                    ? _posXAnimation.value
                    : _selectedIndex) +
                1));
  }

  Widget _buildCircle(Size _size) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Positioned(
        top: _getMainCircleTop(),
        left: _getMainCircleLeft(_size),
        child: SizedBox(
          height: kNavSize,
          width: kNavSize,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kNavSize),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: widget.boxDecoration,
              // type: MaterialType.circle,
              // elevation: 2,
              child: widget.highlightedIcons[_selectedIndex],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => CustomPaint(
        painter: BottomNavShadowPainter(
          context: context,
          animatedIndex: _animationController.isAnimating
              ? _posXAnimation.value
              : _selectedIndex * 1.0,
          numberOfTabs: widget.highlightedIcons.length,
        ),
        child: ClipPath(
          clipBehavior: Clip.antiAlias,
          clipper: BottomNavClipper(
            context: context,
            animatedIndex: _animationController.isAnimating
                ? _posXAnimation.value
                : _selectedIndex * 1.0,
            numberOfTabs: widget.highlightedIcons.length,
          ),
          child: Container(
            height: kNavSize + MediaQuery.of(context).padding.bottom,
            child: Material(
              color: widget.navBgColor,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.menuItems.mapIndexed((e, i) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _tapped(widget.menuItems.indexOf(widget.menuItems[i]));
                    },
                    child: Container(
                      height: 64,
                      child: Center(
                        child: widget.menuItems[i],
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      color: widget.bodyBgColor,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildBar(context),
          _buildCircle(_size),
        ],
      ),
    );
  }
}
