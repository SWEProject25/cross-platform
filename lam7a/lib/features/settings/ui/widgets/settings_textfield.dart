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
  final bool showToggleIcon;

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
    this.showToggleIcon = false,
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
    final error = widget.validator?.call(widget.controller?.text);
    final hasError = error != null && error.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.brightness == Brightness.light
                  ? const Color(0xFF53636E)
                  : const Color(0xFF8B98A5),
              fontSize: 15,
              height: 0.0,
            ),
          ),
        TextFormField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          obscureText: _isObscured,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.brightness == Brightness.light
                  ? const Color(0xFF53636E)
                  : const Color(0xFF8B98A5),
              fontSize: 16,
            ),
            isDense: true,
            filled: false,
            errorText: hasError ? '' : null,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF212426), width: 0.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
            ),
            errorBorder: hasError
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.5),
                  )
                : null,
            focusedErrorBorder: hasError
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 0,
            ),
            errorStyle: TextStyle(
              color: const Color(0xFFdf3c45),
              fontSize: 0,
              height: 1.2, // Add space between error and text field
            ),
            suffixIcon: widget.showToggleIcon
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                      size: 24,
                    ),
                    onPressed: _toggleVisibility,
                  )
                : null,
          ),
        ),
        // Manually display error message below the TextFormField
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              error ?? '',
              style: TextStyle(
                color: const Color(0xFFdf3c45),
                fontSize: 14,
                height: 1.2, // Ensure error message has enough space
              ),
              overflow: TextOverflow.visible, // Make sure it wraps properly
            ),
          ),
      ],
    );
  }
}
