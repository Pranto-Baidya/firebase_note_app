
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final List<Color> colors;
  final Alignment begin;
  final Alignment end;
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
        borderRadius: BorderRadius.circular(30.r),
        child: Container(
          width: width.w,
          height: height.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: begin,
              end: end,
            ),
            borderRadius: BorderRadius.circular(30.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}

