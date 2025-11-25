import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lam7a/core/utils/app_assets.dart';

class LoadingCircle extends StatelessWidget {
  LoadingCircle({super.key});
  static const double size = 95;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface,
              strokeWidth: 2,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppAssets.xIcon,
                width: 30,
                height: 30,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
              // replaces currentCo,
              Text(
                "Loading",
                style: TextStyle(
                  fontSize: size * 0.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
