// import 'package:flutter/material.dart';

// class AppOutlinedButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final Color backgroundColor;
//   final Color borderColor;
//   final Color textColor;
//   final double borderRadius;
//   final EdgeInsetsGeometry padding;

//   const AppOutlinedButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.backgroundColor = Colors.white,
//     this.borderColor = const Color.fromRGBO(197, 200, 202, 1),
//     this.textColor = Colors.black,
//     this.borderRadius = 20,
//     this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: backgroundColor,
//         foregroundColor: textColor,
//         elevation: 0,
//         padding: padding,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(borderRadius),
//           side: BorderSide(color: borderColor, width: 1),
//         ),
//       ),
//       child: Text(text, style: TextStyle(color: textColor)),
//     );
//   }
// }
import 'package:flutter/material.dart';

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final FontWeight fontWeight;

  const AppOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color.fromRGBO(207, 217, 222, 1),
    this.textColor = Colors.black,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        side: BorderSide(color: borderColor, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
