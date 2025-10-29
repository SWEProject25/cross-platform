import 'package:flutter/material.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
////////////////////////////////////////////////////////////////////////////////
//       this concerns in the buttons that have images in it or not          //
//////////////////////////////////////////////////////////////////////////////
class IconedButtonCentered extends StatelessWidget {
  String? imgPath;
  String buttonLabel;
  Color backGroundColor;
  Color textColor;
  Function? pressEffect = (){};
  IconedButtonCentered({super.key, 
    this.imgPath,
    required this.buttonLabel,
    required this.backGroundColor,
    required this.textColor,
    this.pressEffect,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4, top: 4),
      child: Row(
        children: [
          Spacer(flex: 1,),
          Expanded(
            flex: 8,
            child: ElevatedButton(
              onPressed: (){pressEffect!();},
              style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                backgroundColor: backGroundColor,
                enableFeedback:  false,
                elevation: 0,
                shadowColor: Pallete.transparentColor,
                overlayColor: Pallete.inactiveBottomBarItemColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(50)),
                  side: BorderSide(
                    color: Pallete.inactiveBottomBarItemColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (imgPath != null)
                      ? Image.asset(imgPath!, width: 50, height: 25)
                      : Container(),
                  Text(buttonLabel, style: TextStyle(color: textColor)),
                ],
              ),
            ),
          ),
          Spacer(flex: 1,)
        ],
      ),
    );
  }
}
