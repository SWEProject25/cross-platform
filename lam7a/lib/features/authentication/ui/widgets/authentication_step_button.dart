import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/app_pallete.dart';

class AuthenticationStepButton extends StatefulWidget {
  String label;
  bool isValid;
  Function onPressedEffect;
  Color bgColor;
  Color textColor;
  bool enable;
  AuthenticationStepButton({super.key, 
    required this.label,
    this.isValid = false,
    required this.onPressedEffect,
    this.bgColor = Pallete.blackColor,
    this.textColor = Pallete.whiteColor,
    this.enable = false
  });

  @override
  State<AuthenticationStepButton> createState() => _AuthenticationStepButtonState();
}

class _AuthenticationStepButtonState extends State<AuthenticationStepButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return ElevatedButton(
          
          onPressed: () {
            widget.onPressedEffect();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:widget.enable ?  widget.bgColor : const Color.fromARGB(141, 100, 98, 98),
            foregroundColor: widget.textColor,
            elevation: 0,
            shadowColor: Pallete.transparentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30,),
            ),
          ),
          child: Text(widget.label),
        );
      },
    );
  }
}
