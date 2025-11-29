import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/model/user_to_follow_dto.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/users_to_follow_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/loading_circle.dart';
import 'package:lam7a/features/authentication/ui/widgets/user_to_follow_widget.dart';
import 'package:lam7a/features/navigation/ui/view/navigation_home_screen.dart';

class FollowingScreen extends ConsumerStatefulWidget {
  static const String routeName = "following_screen";
  @override
  ConsumerState<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends ConsumerState<FollowingScreen> {
  @override
  Widget build(BuildContext context) {
    final usersToFollowAsync = ref.watch(usersToFollowViewmodelProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
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
      body: Column(
        children: [
          usersToFollowAsync.when(
            data: (usersToFollow) {
              return Expanded(
                child: ListView.separated(
                  itemCount: usersToFollow.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    return UserToFollowWidget(
                      myUserToFollow: usersToFollow[index],
                    );
                  },
                ),
              );
            },
            loading: () => Expanded(child: LoadingCircle()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),
          Column(
            spacing: 0,
            children: [
              Container(height: 1, color: Pallete.greyColor, margin: EdgeInsets.only(bottom: 3),),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: AuthenticationStepButton(
                    key: Key("interestsNextButton"),
                    enable: findoneFollowing(usersToFollowAsync.value ?? []),
                    label: "Next",
                    bgColor: Theme.of(context).colorScheme.onSurface,
                    textColor: Theme.of(context).colorScheme.surface,
                    onPressedEffect: () async {
                      if (findoneFollowing(usersToFollowAsync.value ?? []) && ref.read(authenticationProvider).isAuthenticated) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          NavigationHomeScreen.routeName,
                          (route) => false,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  bool findoneFollowing(List<UserToFollowDto> users){
    print(users);
    for(var user in users){
      if(user.isFollowing == true){
        return true;
      }
    }
    return false;
  }
}
