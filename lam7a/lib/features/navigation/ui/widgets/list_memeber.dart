import 'package:flutter/material.dart';
import 'package:lam7a/core/theme/app_pallete.dart';

class ListMember extends StatelessWidget{

  String title;
  Function TapEffect;
  Color color = Pallete.blackColor;
  IconData? icon;
  String? iconPath;
  ListMember(
    this.title,
    this.TapEffect, {
    this.color = Pallete.blackColor,
    this.icon,
    this.iconPath,
  });

  
  @override
  Widget build(BuildContext context) {
    return Container(
    height: 70,
    child: ListTile(
      horizontalTitleGap: 20,

      iconColor: color,
      textColor: color,
      titleAlignment: ListTileTitleAlignment.center,
      contentPadding: EdgeInsets.only(left: 40),
      leading: iconPath != null
          ? ImageIcon(AssetImage(iconPath!), size: 20)
          : Icon(icon, size: 25),
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        TapEffect();
      },
    ),
  );
  }
}
