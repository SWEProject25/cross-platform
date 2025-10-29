import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:lam7a/features/messaging/ui/view/conversations_screen.dart';

class NavigationHomeScreen extends StatelessWidget {
  static const String routeName = "navigation";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AuthenticationConstants.success)),
      body: Consumer(
        builder: (context, ref, child){
          final authController = ref.watch(authenticationProvider.notifier);
          return Column(
            children: [
              Expanded(child: Container(color: Colors.red)),
              ElevatedButton(
                onPressed: () async {
                  await authController.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    FirstTimeScreen.routeName,
                    (route) => false,
                  );
                },
                child: Text("logout"),
              ),

              ElevatedButton(
                onPressed: () {
                  ref.read(authenticationImplRepositoryProvider).test();
                },
                child: Text("test"),
              ),

              ElevatedButton(
                onPressed:() => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ConversationsScreen(),
                  ),
                ),
                child: Text("DMS"),
              ),
            ],
          );
        },
      ),
    );
  }
}
