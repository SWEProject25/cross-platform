import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/navigation/utils/models/user_main_data.dart';

class ProfileBlock extends StatelessWidget {
  Usermaindata? userData;
  ProfileBlock(this.userData);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(
                  userData?.profileImageUrl ?? AppAssets.userPlaceholderIcon,
                ),
              ),
              SizedBox(height: 10),
              Text(
                userData?.name ?? "User Name",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                "@${userData?.userName ?? "username"}",
                style: TextStyle(fontSize: 16, color: Pallete.greyColor),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "100 ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text("Following", style: TextStyle(color: Pallete.greyColor)),
                  SizedBox(width: 20),
                  Text(
                    "200 ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text("Followers", style: TextStyle(color: Pallete.greyColor)),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 25,
            height: 25,
            child: ElevatedButton(
              onPressed: () {},

              child: Icon(Icons.more_vert),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(
                  side: BorderSide(color: Pallete.blackColor, width: 1.5),
                ),
                padding: EdgeInsets.all(1),
                backgroundColor: Pallete.transparentColor,
                foregroundColor: Pallete.blackColor,
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
