import 'package:flutter/material.dart';
import 'package:quran_app/common/constants/color_pallate.dart';

class LargeButton extends StatelessWidget {
  const LargeButton(
      {super.key,
      required this.child,
      required this.onPressed,
      required this.color});

  final Widget child;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
        child: Center(child: child),
      ),
    );
  }
}
