library awesome_bottom_navigation;

import 'package:flutter/material.dart';
import 'clipper.dart';
import 'consts.dart';
import 'shadow_painter.dart';

class AwesomeBottomNav extends StatefulWidget {
  final List<IconData> icons;
  final List<IconData> highlightedIcons;
  final Color highlightColor;
  final Color bodyBgColor;
  final Color navBgColor;
  final Color navFgColor;
  final ValueSetter<int> onTapped;

  const AwesomeBottomNav({
    Key key,
    @required this.icons,
    @required this.highlightedIcons,
    @required this.highlightColor,
    @required this.onTapped,
    @required this.bodyBgColor,
    @required this.navBgColor,
    @required this.navFgColor,
  }) : super(key: key);

  @override
  _AwesomeBottomNavState createState() => _AwesomeBottomNavState();
}

class _AwesomeBottomNavState extends State<AwesomeBottomNav>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  AnimationController _animationController;
  Animation<double> _posXAnimation;
  Animation<double> _sinkAnimation;
  Animation<double> _riseAnimation;

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
        Tween(begin: -20.0, end: kNavSize.toDouble()).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.25, curve: Curves.easeInOutSine),
    ));
    _riseAnimation =
        Tween(end: -20.0, begin: kNavSize.toDouble()).animate(CurvedAnimation(
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
      return -20;
    }

    if (_animationController.value < 0.5) {
      return _sinkAnimation.value;
    } else {
      return _riseAnimation.value;
    }
  }

  double _getMainCircleLeft(Size size) {
    final totalPadding = size.width - (kNavSize * widget.icons.length);
    final singlePadding = totalPadding / (widget.icons.length + 1);
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

  Widget buildCircle(Size _size) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Positioned(
        top: _getMainCircleTop(),
        left: _getMainCircleLeft(_size),
        child: SizedBox(
          height: kNavSize,
          width: kNavSize,
          child: Material(
            color: widget.highlightColor,
            clipBehavior: Clip.antiAlias,
            type: MaterialType.circle,
            elevation: 2,
            child: Icon(
              widget.highlightedIcons[_selectedIndex],
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBar(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => CustomPaint(
        painter: BottomNavShadowPainter(
          context: context,
          animatedIndex: _animationController.isAnimating
              ? _posXAnimation.value
              : _selectedIndex * 1.0,
          numberOfTabs: widget.icons.length,
        ),
        child: ClipPath(
          clipBehavior: Clip.antiAlias,
          clipper: BottomNavClipper(
            context: context,
            animatedIndex: _animationController.isAnimating
                ? _posXAnimation.value
                : _selectedIndex * 1.0,
            numberOfTabs: widget.icons.length,
          ),
          child: Container(
            height: kNavSize + MediaQuery.of(context).padding.bottom,
            child: Material(
              color: widget.navBgColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.icons
                    .map<Widget>((icon) => InkWell(
                          borderRadius: BorderRadius.circular(kNavSize),
                          onTap: () {
                            _tapped(widget.icons.indexOf(icon));
                          },
                          child: Container(
                            height: 64,
                            width: 56,
                            child: Center(
                              child: Icon(
                                icon,
                                size: 30,
                                color: widget.navFgColor,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
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
        overflow: Overflow.visible,
        children: [
          buildCircle(_size),
          buildBar(context),
        ],
      ),
    );
  }
}
