
import 'dart:ffi';

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final List<Color> colors;
  final Alignment begin;
  final Alignment end;
  final double borderRadius;
  final EdgeInsets padding;
  final double width;
  final double height;
  final double elevation;

  const CustomButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.colors = const [Color(0xFFe68f50),Color(0xFFd49d6e)],
    this.begin = Alignment.topLeft,
    this.end = Alignment.topRight,
    this.borderRadius = 30,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    required this.width,
    required this.height,
    this.elevation = 1.5
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Material(
        elevation: elevation,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: begin,
              end: end,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}

