import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lam7a/core/theme/app_pallete.dart';

// ignore: must_be_immutable
class AuthenticationStepButton extends StatefulWidget {
  String label;
  bool isValid;
  Function onPressedEffect;
  Color bgColor;
  Color textColor;
  bool enable;
  bool isBorder;
  AuthenticationStepButton({
    super.key,
    required this.label,
    this.isValid = false,
    required this.onPressedEffect,
    this.bgColor = Pallete.blackColor,
    this.textColor = Pallete.whiteColor,
    this.enable = false,
    this.isBorder = false,
  });

  @override
  State<AuthenticationStepButton> createState() =>
      _AuthenticationStepButtonState();
}

class _AuthenticationStepButtonState extends State<AuthenticationStepButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return ElevatedButton(
          onPressed: () {
            if (widget.enable) {
              widget.onPressedEffect();
            }
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20),
            backgroundColor: widget.enable
                ? widget.bgColor
                : const Color.fromARGB(141, 100, 98, 98),
            foregroundColor: widget.textColor,
            elevation: 0,
            shadowColor: Pallete.transparentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(
                color: !widget.isBorder
                    ? Pallete.transparentColor
                    : Pallete.blackColor,
              ),
            ),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.cabin(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        );
      },
    );
  }
}
