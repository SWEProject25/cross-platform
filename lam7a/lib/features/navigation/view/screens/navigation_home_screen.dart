import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';

class NavigationHomeScreen extends StatefulWidget {
  static const String routeName = "navigation";

  @override
  State<NavigationHomeScreen> createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  int _currentIndex = 0;
  bool _isVisible = true;
  double _lastOffset = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AuthenticationConstants.success),
        backgroundColor: Pallete.whiteColor,
        animateColor: false,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          List<Widget> pages = [
            Center(child: ElevatedButton(onPressed: () async {
              await ref.read(authenticationProvider.notifier).logout();
              setState(() {
                
              });
            }, child: Text("Logout"),)),
            Center(child: Text("Search Screen")),
            Center(child: Text("Friends Screen")),
            Center(child: Text("Notifications Screen")),
            Center(child: Text("Messages Screen")),
          ];
          return NotificationListener<ScrollNotification>(
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
          );
        },
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        height: _isVisible ? 70 : 0,
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
                    icon: ImageIcon(AssetImage(AppAssets.friendsIcon)),
                    label: "friends",
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage(AppAssets.notificationsIcon)),
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
  }
}
