import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/model/interest_dto.dart';
import 'package:lam7a/features/authentication/ui/view/screens/following_screen/following_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/interests_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/interest_widget.dart';
import 'package:lam7a/features/authentication/ui/widgets/loading_circle.dart';

class InterestsScreen extends ConsumerStatefulWidget {
  static const String routeName = "interests_screen";

  @override
  ConsumerState<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends ConsumerState<InterestsScreen> {
  final Set<int> selectedIndices = {};
  final List<int> selectedInterests = [];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final interestsAsynch = ref.watch(interestsViewModelProvider);
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
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        "What are you interested in?",
                        style: GoogleFonts.outfit(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),

                !isLoading
                    ? SliverPadding(
                        padding: const EdgeInsets.all(8),
                        sliver: interestsAsynch.when(
                          data: (interests) => SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              childCount: interests.length,
                              (context, index) {
                                final selected = selectedIndices.contains(
                                  index,
                                );
                                return InterestWidget(
                                  isSelected: selected,
                                  interest: interests[index],
                                  onTap: () {
                                    setState(() {
                                      if (selected) {
                                        selectedIndices.remove(index);
                                        selectedInterests.remove(
                                          interests[index].id,
                                        );
                                      } else {
                                        selectedIndices.add(index);
                                        selectedInterests.add(
                                          interests[index].id!,
                                        );
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.2,
                                ),
                          ),
                          error: (error, stackTrace) => SliverToBoxAdapter(
                            child: Center(
                              child: Text('Error loading interests'),
                            ),
                          ),
                          loading: () => SliverToBoxAdapter(
                            child: Center(child: LoadingCircle()),
                          ),
                        ),
                      )
                    :  SliverFillRemaining(
        child: Center(child: LoadingCircle()),
      ),
              ],
            ),
          ),

          Column(
            spacing: 0,
            children: [
              Container(
                height: 1,
                color: Pallete.greyColor,
                margin: EdgeInsets.only(bottom: 3),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: AuthenticationStepButton(
                    key: Key("interestsNextButton"),
                    enable: selectedInterests.isNotEmpty,
                    label: "Next",
                    bgColor: Theme.of(context).colorScheme.onSurface,
                    textColor: Theme.of(context).colorScheme.surface,
                    onPressedEffect: () async {
                      if (selectedInterests.isNotEmpty) {
                        isLoading = true;
                        setState(() {});
                        await ref
                            .read(interestsViewModelProvider.notifier)
                            .selectInterests(selectedInterests);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          FollowingScreen.routeName,
                          (route) => false,
                        );
                        isLoading = false;
                        setState(() {});
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
}
