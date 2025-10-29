import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/repository/authentication_repository.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';

class NavigationHomeScreen extends StatelessWidget {
  static const String routeName = "navigation";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(success)),
      body: Consumer(
        builder: (context, ref, child) {
          final authController = ref.watch(authenticationProvider.notifier);
          final repo = AuthenticationRepositoryImpl();
          return Column(
            children: [
              Expanded(child: Container(color: Colors.red)),
              ElevatedButton(
                onPressed: () async {
                  await authController.logout(ref);
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
                  repo.test(ref);
                },
                child: Text("test"),
              ),
            ],
          );
        },
      ),
    );
  }
}
