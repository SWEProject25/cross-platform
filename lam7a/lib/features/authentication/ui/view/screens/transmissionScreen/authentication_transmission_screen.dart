import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/ui/view/screens/interests_screen/interests_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/profile_picture/profile_picture.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/navigation/ui/view/navigation_home_screen.dart';
import 'package:path/path.dart';

class AuthenticationTransmissionScreen extends StatelessWidget {
  static const String routeName = 'transmission';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey("transmissionAfterLogin"),
      appBar: AppBar(
        title: SvgPicture.asset(
          AppAssets.xIcon,
          width: 32,
          height: 32,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        ),
      ),
      // replaces currentCo)),
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
                child: Text(
                  "See Who's on X",
                  style: GoogleFonts.outfit(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
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
                    Icon(
                      Icons.people,
                      size: 40,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "you decide who to follow",
                      style: GoogleFonts.outfit(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 20,
                      ),
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
                          InterestsScreen.routeName,
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
