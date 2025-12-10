import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/user_dto.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/navigation/utils/models/user_main_data.dart';
import 'package:lam7a/features/profile/ui/widgets/profile_card.dart';

class ProfileBlock extends StatelessWidget {
  ProfileBlock();
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authenticationProvider);
        UserModel? userData = authState.user;

        return Container(
          padding: EdgeInsets.all(40),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                        Navigator.pushNamed(
                context,
                '/profile',
                arguments: {"username": userData?.username ?? ""},
              );
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: userData?.profileImageUrl != null
                          ? NetworkImage(userData!.profileImageUrl!)
                          : AssetImage(AppAssets.userPlaceholderIcon)
                                as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    userData?.name ?? "User Name",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    "@${userData?.username ?? "username"}",
                    style: TextStyle(fontSize: 16, color: Pallete.greyColor),
                  ),
                  SizedBox(height: 7),
                  Row(
                    children: [
                      Text(
                       '${userData?.followingCount ?? 0}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        " Following",
                        style: TextStyle(color: Pallete.greyColor),
                      ),
                      SizedBox(width: 20),
                      Text(
                         '${userData?.followersCount ?? 0}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        " Followers",
                        style: TextStyle(color: Pallete.greyColor),
                      ),
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
      },
    );
  }
}
