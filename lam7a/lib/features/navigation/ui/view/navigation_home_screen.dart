import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:lam7a/features/messaging/ui/view/conversations_screen.dart';
import 'package:lam7a/features/navigation/ui/viewmodel/navigation_viewmodel.dart';
import 'package:lam7a/features/navigation/ui/widgets/list_memeber.dart';
import 'package:lam7a/features/navigation/ui/widgets/profile_block.dart';
import 'package:lam7a/features/navigation/utils/models/user_main_data.dart';
import 'package:lam7a/features/notifications/ui/views/notifications_screen.dart';
import 'package:lam7a/features/settings/ui/view/main_settings_page.dart';
import 'package:lam7a/features/tweet/ui/view/pages/tweet_home_screen.dart';
class NavigationHomeScreen extends StatefulWidget {
  static const String routeName = "navigation";

  @override
  State<NavigationHomeScreen> createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  int _currentIndex = 0;
  int valueFromDropdown = 0;
  bool _isVisible = true;
  double _lastOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final viewmodel = ref.watch(navigationViewModelProvider.notifier);
        UserModel? user = ref.watch(authenticationProvider).user;
        List<Widget> pages = [
          Center(child: Text("Home Screen")),
          Center(child: Text("Search Screen")),
          Center(child: NotificationsScreen()),
          Center(child: ConversationsScreen()),
        ];
        List<Widget> drawerItems = [
          ListMember("Profile", () {}, iconPath: AppAssets.ProfileIcon),
          ListMember("Chat", () {}, iconPath: AppAssets.chatIcon),
          ListMember(
            "Logout",
            () async {
              bool isloggedOut = await viewmodel.logoutButtonPressed();
              if (isloggedOut) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  FirstTimeScreen.routeName,
                  (route) => false,
                );
              }
            },
            icon: Icons.logout,
            color: Pallete.errorColor,
          ),
        ];

        return Scaffold(
          appBar: AppBar(
            title: const ImageIcon(AssetImage(AppAssets.xIcon)),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.account_circle_outlined),
                );
              },
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.settings_outlined)),
            ],
          ),
          drawer: Drawer(
            width: 300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 50),
                ProfileBlock(
                  Usermaindata(
                    name: user?.name,
                    userName: user?.username,
                    profileImageUrl: user?.profileImageUrl,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return drawerItems[index];
                    },
                    itemCount: drawerItems.length,
                  ),
                ),

                ExpansionTile(
                  collapsedBackgroundColor: Pallete.transparentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: BorderSide.none,
                  ),
                  title: Text("Settinga&Care"),
                  children: [
                    ListMember("Settings and privacy", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (ctx) => MainSettingsPage()),
                      );
                    }, icon: Icons.settings),
                    ListMember("Help Center", () {}, icon: Icons.help_center),
                  ],
                ),
                SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 20),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TweetHomeScreen(),
                    ),
                  );
                     },
                    icon: Icon(Icons.light_mode_outlined, size: 35),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),

          body: NotificationListener<ScrollNotification>(
            child: pages[_currentIndex],
            onNotification: (scroll) {
              if (scroll is UserScrollNotification) {
                _isVisible = true;
              } else if (scroll is ScrollUpdateNotification) {
                final currentOffset = scroll.metrics.pixels;
                if (currentOffset > _lastOffset + 5 && _isVisible) {
                  setState(() => _isVisible = false);
                } else if (currentOffset < _lastOffset - 5 && !_isVisible) {
                  setState(() => _isVisible = true);
                }

                _lastOffset = currentOffset;
              }
              return true;
            },
          ),
          bottomNavigationBar: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            height: _isVisible ? MediaQuery.of(context).size.height * 0.07 : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              opacity: _isVisible ? 1.0 : 0.0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: const Color.fromARGB(255, 190, 190, 190),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Theme(
                  data: ThemeData(
                    canvasColor: Pallete.whiteColor,
                    splashColor: Colors.transparent,
                  ),
                  child: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: Pallete.blackColor,
                    unselectedItemColor: Pallete.greyColor,
                    elevation: 0,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    onTap: (index) {
                      _currentIndex = index;
                      setState(() {
                        _isVisible = true;
                      });
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: ImageIcon(AssetImage(AppAssets.homeIcon)),
                        label: "home",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        label: "search",
                      ),
                      BottomNavigationBarItem(
                        icon: ImageIcon(
                          AssetImage(AppAssets.notificationsIcon),
                        ),
                        label: "notifications",
                      ),
                      BottomNavigationBarItem(
                        icon: ImageIcon(AssetImage(AppAssets.messagesIcon)),
                        label: "messages",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
