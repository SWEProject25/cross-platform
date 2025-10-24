import 'package:flutter/material.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';

class NavigationHomeScreen extends StatelessWidget{
  static const String routeName = "navigation";
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(success),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
  }

}