import 'package:flutter/material.dart';

class DeactivateButton extends StatefulWidget {
  final bool isActive;
  final VoidCallback onPressed;

  const DeactivateButton({
    super.key,
    required this.isActive,
    required this.onPressed,
  });

  @override
  State<DeactivateButton> createState() => _DeactivateButtonState();
}

class _DeactivateButtonState extends State<DeactivateButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.redAccent;
    final isEnabled = widget.isActive;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isEnabled ? 1.0 : 0.4,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: isEnabled ? widget.onPressed : null,
        onHighlightChanged: (pressed) {
          if (isEnabled) {
            setState(() => _isPressed = pressed);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: _isPressed ? baseColor : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: baseColor, width: 1.6),
          ),
          child: Text(
            'Deactivate',
            style: TextStyle(
              color: _isPressed ? Colors.white : baseColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
