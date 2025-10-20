import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/app_pallete.dart';

class NextButton extends StatefulWidget {
  String label;
  bool isValid;
  Function onPressedEffect;
  Color bgColor;
  Color textColor;
  NextButton({
    required this.label,
    this.isValid = false,
    required this.onPressedEffect,
    this.bgColor = Pallete.blackColor,
    this.textColor = Pallete.whiteColor
  });

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return ElevatedButton(
          onPressed: () {
            widget.onPressedEffect();
          },
          child: Text(widget.label),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.bgColor,
            foregroundColor: widget.textColor,
            elevation: 0,
            shadowColor: Pallete.transparentColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Pallete.blackColor),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        );
      },
    );
  }
}
