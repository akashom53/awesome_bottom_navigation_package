import 'consts.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class BottomNavClipper extends CustomClipper<Path> {
  final int numberOfTabs;
  final double notchHeight = kNavSize - 28;
  final topPaddingFactor = 0.0;
  final BuildContext context;

  final double animatedIndex;
  late double paddingW;

  BottomNavClipper({
    required this.numberOfTabs,
    required this.animatedIndex,
    required this.context,
  }) {
    final size = MediaQuery.of(context).size;
    final totalPadding = size.width - (kNavSize * numberOfTabs);
    paddingW = totalPadding / (numberOfTabs + 1);
  }

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    final sectionWidth = (size.width - paddingW) / numberOfTabs;
    final curveControlOffset = sectionWidth * 0.4;

    final topPadding = topPaddingFactor * size.height;
    path.lineTo(
        (animatedIndex * sectionWidth + paddingW / 2) - curveControlOffset, 0);

    final firstControlPoint =
        Offset((animatedIndex * sectionWidth + paddingW / 2), 0);

    final secondControlPoint =
        Offset((animatedIndex * sectionWidth + paddingW / 2), notchHeight);
    final secondEndPoint = Offset(
        (animatedIndex * sectionWidth + paddingW / 2) + curveControlOffset,
        notchHeight);

    path.cubicTo(
        firstControlPoint.dx,
        firstControlPoint.dy,
        secondControlPoint.dx,
        secondControlPoint.dy,
        secondEndPoint.dx,
        secondEndPoint.dy);

    path.lineTo(
        ((animatedIndex + 1) * sectionWidth + paddingW / 2) -
            curveControlOffset,
        notchHeight);
    final thirdControlPoint = Offset(
        ((animatedIndex + 1) * sectionWidth + paddingW / 2), notchHeight);

    final fourthControlPoint =
        Offset(((animatedIndex + 1) * sectionWidth + paddingW / 2), 0);
    final fourthEndPoint = Offset(
        ((animatedIndex + 1) * sectionWidth + paddingW / 2) +
            curveControlOffset,
        0);

    path.cubicTo(
        thirdControlPoint.dx,
        thirdControlPoint.dy,
        fourthControlPoint.dx,
        fourthControlPoint.dy,
        fourthEndPoint.dx,
        fourthEndPoint.dy);
    path.lineTo(size.width, 0);

    path =
        path.transform(Matrix4.translation(Vector3(0, topPadding, 0)).storage);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant BottomNavClipper oldClipper) {
    return oldClipper.animatedIndex != animatedIndex;
  }
}
