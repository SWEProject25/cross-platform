import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/profile_picture/profile_picture.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/navigation/view/screens/navigation_home_screen.dart';
import 'package:path/path.dart';

class AuthenticationTransmissionScreen extends StatelessWidget {
  static const String routeName = 'transmission';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const ImageIcon(AssetImage(AppAssets.xIcon))),
      body: Consumer(
        builder: (context, ref, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.transmissionScreenHeaderImg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: const Text(
                  "See Who's on X",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Pallete.blackColor,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: const Text(
                  "syncing your contacts helps you to see the world from another side it's better for you and any Lam7a user",
                  style: TextStyle(color: Pallete.subtitleText),
                ),
              ),
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Icon(Icons.people, size: 50, color: Pallete.blackColor),
                    SizedBox(width: 20),
                    const Text(
                      "you decide who to follow",
                      style: TextStyle(color: Pallete.blackColor, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Row(
                children: [
                  Spacer(flex: 1),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          NavigationHomeScreen.routeName,
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.whiteColor,
                        elevation: 0,
                        shadowColor: Pallete.transparentColor,
                        overlayColor: Pallete.greyColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.all(
                            Radius.circular(50),
                          ),
                          side: BorderSide(
                            color: Pallete.inactiveBottomBarItemColor,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        "continue",
                        style: TextStyle(color: Pallete.blackColor),
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                ],
              ),
              SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
