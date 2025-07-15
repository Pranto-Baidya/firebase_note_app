
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final Alignment begin;
  final Alignment end;

  const GradientBackground({super.key,
    required this.child,
    this.colors = const [Color(0xFFe68f50),Color(0xFFd49d6e)],
    this.begin = Alignment.topLeft,
    this.end = Alignment.topRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: colors,
            begin: begin,
            end: end
        )
      ),
      child: SizedBox.expand(
        child: child,
      ),
    );
  }
}
