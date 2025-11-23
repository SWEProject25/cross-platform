import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/messaging/ui/view/conversations_screen.dart';
import 'package:lam7a/features/navigation/ui/viewmodel/navigation_viewmodel.dart';
import 'package:lam7a/features/navigation/ui/widgets/list_memeber.dart';
import 'package:lam7a/features/navigation/ui/widgets/profile_block.dart';
import 'package:lam7a/features/navigation/ui/widgets/search_bar.dart';
import 'package:lam7a/features/navigation/utils/models/user_main_data.dart';
import 'package:lam7a/features/notifications/ui/views/notifications_screen.dart';
import 'package:lam7a/features/settings/ui/view/main_settings_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lam7a/features/tweet/ui/view/pages/tweet_home_screen.dart';

class NavigationHomeScreen extends StatefulWidget {
  static const String routeName = "navigation";

  const NavigationHomeScreen({super.key});

  @override
  State<NavigationHomeScreen> createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  int _currentIndex = 0;
  int valueFromDropdown = 0;
  bool _isVisible = true;
  bool _isAppBarVisible = true;
  double _lastOffset = 0;
  String? themeMode;

  // Define custom AppBar height
  final double _appBarHeight = 80.0; // Change this value to adjust height

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer(
      builder: (context, ref, child) {
        UserModel? user = ref.watch(authenticationProvider).user;
        List<Widget> pages = [
          Center(child: TweetHomeScreen()),
          Center(child: Text("Search Screen")),
          Center(child: NotificationsScreen()),
          Center(child: ConversationsScreen()),
        ];
        List<Widget> drawerItems = [
          ListMember(
            "Profile",
            () {},
            iconPath: AppAssets.ProfileIcon,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          ListMember(
            "Chat",
            () {},
            iconPath: AppAssets.chatIcon,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          ListMember(
            "Logout",
            () {
              showLogoutDialog(ref);
            },
            icon: Icons.logout,
            color: Pallete.errorColor,
          ),
        ];

        return Scaffold(
          key: ValueKey("homeScreen"),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(_appBarHeight),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: _isAppBarVisible ? _appBarHeight : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isAppBarVisible ? 1.0 : 0.0,
                child: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  toolbarHeight: _appBarHeight, // Set custom toolbar height
                  title: getCurrentAppbar(),
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
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.settings_outlined),
                    ),
                  ],
                ),
              ),
            ),
          ),
          drawer: Drawer(
            width: 300,
            backgroundColor: isDark
                ? Pallete.darkItemBackground
                : Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  title: Text("Settings&Care"),
                  children: [
                    ListMember(
                      "Settings and privacy",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => MainSettingsPage(),
                          ),
                        );
                      },
                      icon: Icons.settings,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    ListMember(
                      "Help Center",
                      () {},
                      icon: Icons.help_center,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                StatefulBuilder(
                  builder: (context, modelSetState) {
                    return Container(
                      width: 80,
                      padding: EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: () {
                          showThemeModeBottomSheet(isDark);
                        },
                        icon: Icon(Icons.light_mode_outlined, size: 35),
                        alignment: Alignment.center,
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          body: SafeArea(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scroll) {
                if (scroll.metrics.axis != Axis.vertical) {
                  return false;
                }
                if (scroll is ScrollUpdateNotification) {
                  final currentOffset = scroll.metrics.pixels;

                  // Scroll down - hide both bars
                  if (currentOffset > _lastOffset + 10 && _isVisible) {
                    setState(() {
                      _isVisible = false;
                      _isAppBarVisible = false;
                    });
                  }
                  // Scroll up - show both bars
                  else if (currentOffset < _lastOffset - 5 && !_isVisible) {
                    setState(() {
                      _isVisible = true;
                      _isAppBarVisible = true;
                    });
                  }

                  _lastOffset = currentOffset;
                }
                return false;
              },
              child: pages[_currentIndex],
            ),
          ),
          bottomNavigationBar: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: _isVisible ? 60 : 0.00,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
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
                    canvasColor: Theme.of(context).colorScheme.surface,
                    splashColor: Colors.transparent,
                  ),
                  child: IgnorePointer(
                    ignoring: !_isVisible,
                    child: SafeArea(
                      child: ClipRect(
                        child: Align(
                          heightFactor: _isVisible ? 1.0 : 0.0,
                          child: BottomNavigationBar(
                            
                            currentIndex: _currentIndex,
                            type: BottomNavigationBarType.fixed,
                            selectedItemColor: Theme.of(
                              context,
                            ).colorScheme.onSurface,
                            unselectedItemColor: Pallete.greyColor,
                            elevation: 0,
                            showSelectedLabels: false,
                            showUnselectedLabels: false,
                            onTap: (index) {
                              setState(() {
                                _currentIndex = index;
                                _isVisible = true;
                                _isAppBarVisible = true;
                              });
                            },
                            items: [
                              BottomNavigationBarItem(
                                icon: SvgPicture.asset(
                                  AppAssets.homeIcon,
                                  height: _isVisible ? 22 : 0,
                                  width: _isVisible ? 22 : 0,
                                  colorFilter: ColorFilter.mode(
                                    Pallete.greyColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                activeIcon: SvgPicture.asset(
                                  AppAssets.homeIcon,
                                  height: 22,
                                  width: 22,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onSurface,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                label: "home",
                              ),
                              BottomNavigationBarItem(
                                icon: Icon(Icons.search, size: _isVisible ? 22 : 0),
                                label: "search",
                              ),
                              BottomNavigationBarItem(
                                icon: SvgPicture.asset(
                                  AppAssets.notificationsIcon,
                                  height: _isVisible ? 22 : 0,
                                  width: _isVisible ? 22 : 0,
                                  colorFilter: ColorFilter.mode(
                                    Pallete.greyColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                activeIcon: SvgPicture.asset(
                                  AppAssets.notificationsIcon,
                                  height: 20,
                                  width: 20,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onSurface,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                label: "notifications",
                              ),
                              BottomNavigationBarItem(
                                icon: SvgPicture.asset(
                                  AppAssets.messagesIcon,
                                  height: _isVisible ? 22 : 0,
                                  width: _isVisible ? 22 : 0,
                                  colorFilter: ColorFilter.mode(
                                    Pallete.greyColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                activeIcon: SvgPicture.asset(
                                  AppAssets.messagesIcon,
                                  height: 20,
                                  width: 20,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onSurface,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                label: "messages",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getCurrentAppbar() {
    switch (_currentIndex) {
      case 0:
        return ImageIcon(AssetImage(AppAssets.xIcon));
      case 1:
        return SearchBarCustomized();
      case 2:
        return Text(
          "Notifications",
          style: GoogleFonts.outfit(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        );
      case 3:
        return SearchBarCustomized();
    }
    return ImageIcon(AssetImage(AppAssets.xIcon));
  }

  void showLogoutDialog(WidgetRef ref) {
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final viewmodel = ref.watch(navigationViewModelProvider.notifier);
    Widget dialog = AlertDialog(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 71, 71, 71)
          : Theme.of(context).colorScheme.surface,
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            bool isloggedOut = await viewmodel.logoutButtonPressed();
            if (isloggedOut) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                FirstTimeScreen.routeName,
                (route) => false,
              );
            }
          },
          child: Text('Logout', style: TextStyle(color: Pallete.errorColor)),
        ),
      ],
    );
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => dialog,
    );
  }

  void showThemeModeBottomSheet(bool isDark) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark
          ? const Color.fromARGB(255, 71, 71, 71)
          : Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select Theme Mode",
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 24),
                    RadioGroup<String>(
                      groupValue: themeMode,
                      onChanged: (value) {
                        modalSetState(() => themeMode = value);
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.dark_mode,
                                  color: Pallete.greyColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                const Text('Dark Mode'),
                              ],
                            ),
                            value: 'dark',
                          ),
                          RadioListTile<String>(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.light_mode,
                                  color: Pallete.greyColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                const Text('Light Mode'),
                              ],
                            ),
                            value: 'light',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}