import 'package:flutter/material.dart';

class SettingsTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final String? errorText;
  final bool obscureText;
  final bool showToggleIcon; // 👈 new parameter

  const SettingsTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.errorText,
    this.obscureText = false,
    this.showToggleIcon = false, // 👈 default: false
  });

  @override
  State<SettingsTextField> createState() => _SettingsTextFieldState();
}

class _SettingsTextFieldState extends State<SettingsTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: theme.textTheme.bodySmall!.copyWith(fontSize: 14),
          ),
        TextFormField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          obscureText: _isObscured,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            isDense: true,
            filled: false,
            errorText: widget.errorText,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF212426)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4A90E2)),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 0,
            ),
            // 👇 Add suffix icon if showToggleIcon is true
            suffixIcon: widget.showToggleIcon
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: _toggleVisibility,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
