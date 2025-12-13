import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lam7a/core/theme/app_pallete.dart';

////////////////////////////////////////////////////////////////////////////////
//       this concerns in the buttons that have images in it or not          //
//////////////////////////////////////////////////////////////////////////////
class IconedButtonCentered extends StatelessWidget {
  String? imgPath;
  String buttonLabel;
  Color backGroundColor;
  Color textColor;
  Function? pressEffect = () {};
  bool isBorder;
  IconedButtonCentered({
    super.key,
    this.imgPath,
    required this.buttonLabel,
    required this.backGroundColor,
    required this.textColor,
    this.pressEffect,
    this.isBorder = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1, top: 1),
      child: Row(
        children: [
          Spacer(flex: 1),
          Expanded(
            flex: 5,
            child: ElevatedButton(
              key: key,
              onPressed: () {
                pressEffect!();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 8,),
                alignment: Alignment.center,
                backgroundColor: backGroundColor,
                enableFeedback: false,
                elevation: 0,
                shadowColor: Pallete.transparentColor,
                overlayColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(70)),
                  side: BorderSide(
                    color: !isBorder ? backGroundColor : const Color.fromARGB(255, 109, 137, 146),
                    width: 1.2,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (imgPath != null)
                      ? Image.asset(imgPath!, width: 50, height: 25)
                      : Container(),
                  Text(
                    buttonLabel,
                    style: GoogleFonts.manrope(
                      // or Satoshi / Outfit
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(flex: 1),
        ],
      ),
    );
  }
}
