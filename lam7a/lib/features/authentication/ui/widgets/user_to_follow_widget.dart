import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/model/user_to_follow_dto.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/users_to_follow_viewmodel.dart';

class UserToFollowWidget extends ConsumerStatefulWidget {
  UserToFollowDto myUserToFollow;
  UserToFollowWidget({super.key, required this.myUserToFollow});
  @override
  ConsumerState<UserToFollowWidget> createState() => _UserToFollowWidgetState();
}

class _UserToFollowWidgetState extends ConsumerState<UserToFollowWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage:
                    widget.myUserToFollow.profile!.profileImageUrl != null
                    ? NetworkImage(
                        widget.myUserToFollow.profile!.profileImageUrl!,
                      )
                    : AssetImage(AppAssets.userPlaceholderIcon)
                          as ImageProvider,
              ),
              SizedBox(width: 15),
              Expanded(
                flex: 10,
                child: Column(
                  spacing: 0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.myUserToFollow.profile!.name ?? "User Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1,
                      ),
                    ),
                    Text(
                      widget.myUserToFollow.username != null
                          ? "@${widget.myUserToFollow.username}"
                          : "@username",
                      style: TextStyle(
                        fontSize: 14,
                        color: Pallete.greyColor,
                        height: 1,
                      ),
                    ),
                    Text(
                      widget.myUserToFollow.profile!.bio ?? "Bio goes here",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.3,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          if (!widget.myUserToFollow.isFollowing) {
                            await ref
                                .read(usersToFollowViewmodelProvider.notifier)
                                .followUser(widget.myUserToFollow.id!);
                            widget.myUserToFollow.isFollowing = true;
                            UserModel myUser = ref
                                .watch(authenticationProvider)
                                .user!;
                            ref
                                .read(authenticationProvider.notifier)
                                .updateUser(
                                  myUser.copyWith(
                                    followingCount: myUser.followingCount + 1,
                                  ),
                                );
                          } else {
                            await ref
                                .read(usersToFollowViewmodelProvider.notifier)
                                .unfollowUser(widget.myUserToFollow.id!);
                            widget.myUserToFollow.isFollowing = false;
                            UserModel myUser = ref
                                .watch(authenticationProvider)
                                .user!;
                            ref
                                .read(authenticationProvider.notifier)
                                .updateUser(
                                  myUser.copyWith(
                                    followingCount: myUser.followingCount + 1,
                                  ),
                                );
                          }
                        } catch (e) {
                          print('Error: $e');
                        } finally {
                          if (mounted) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: Size(100, 36),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      )
                    : Text(
                        widget.myUserToFollow.isFollowing
                            ? "Following"
                            : "Follow",
                        style: TextStyle(
                          color: widget.myUserToFollow.isFollowing
                              ? Theme.of(context).colorScheme.surface
                              : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
