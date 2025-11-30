import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/providers/theme_provider.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/model/interest_dto.dart';

class InterestWidget extends StatelessWidget {
  bool isSelected;
  InterestDto interest;
  GestureTapCallback onTap;
  InterestWidget({
    super.key,
    required this.isSelected,
    required this.interest,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF635BFF)
                      : Theme.of( context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.tertiary
                      : Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? Color(0xFF1C478B)
                        : Pallete.transparentColor,
                    width: isSelected ? 1 : 0,
                  ),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(interest.icon!, style: TextStyle(fontSize: 40)),
                      Text(
                        interest.name!,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Theme.of( context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        
                      ),
                      Text(
                        interest.description!,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color.fromARGB(255, 122, 122, 122),
                          fontWeight: FontWeight.normal,
                          
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
              isSelected ? Positioned(
                top: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: const Color(0xFF635BFF)
                  ),
                ),
              ) : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}
