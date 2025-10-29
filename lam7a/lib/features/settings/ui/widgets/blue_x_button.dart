import 'package:flutter/material.dart';

class BlueXButton extends StatelessWidget {
  final bool isActive;
  final bool isLoading;
  final VoidCallback? onPressed;

  const BlueXButton({
    super.key,
    required this.isActive,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0, right: 0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: isActive && !isLoading ? onPressed : null,
              child: Ink(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.blueAccent
                      : const Color.fromARGB(141, 68, 137, 255),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
