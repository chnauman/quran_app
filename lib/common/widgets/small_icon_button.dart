import 'package:flutter/material.dart';
import 'package:quran_app/common/constants/color_pallate.dart';

class SmallIconButton extends StatelessWidget {
  const SmallIconButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.isSelected});

  final VoidCallback onPressed;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      style: IconButton.styleFrom(
          fixedSize: const Size(50, 50),
          backgroundColor:
              isSelected ? Colors.blue[900] : ColorPallate.primaryColor),
    );
  }
}
