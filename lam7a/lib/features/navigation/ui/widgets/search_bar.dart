import 'package:flutter/material.dart';
import 'package:lam7a/core/theme/app_pallete.dart';

class SearchBarCustomized extends StatefulWidget {
  @override
  State<SearchBarCustomized> createState() => _SearchBarCustomizedState();
}

class _SearchBarCustomizedState extends State<SearchBarCustomized> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        print('Focus changed: ${_focusNode.hasFocus}');
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Pallete.whiteColor, // Cursor color
          selectionColor: Pallete.whiteColor,
           // Text selection highlight
          selectionHandleColor: Pallete.whiteColor, // Selection handles
        ),
      ),
      child: SearchBar(
        hintText: 'Search',
        hintStyle: WidgetStatePropertyAll<TextStyle>(
          TextStyle(
            color: const Color.fromARGB(255, 158, 158, 158),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.5,
          ),
        ),
        textStyle: WidgetStatePropertyAll<TextStyle>(
          TextStyle(
            color: Pallete.whiteColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.5,
          ),
        ),

        backgroundColor: WidgetStateColor.resolveWith(
          (callback) => const Color.fromARGB(255, 105, 105, 105),
        ),
        padding: const WidgetStatePropertyAll<EdgeInsets>(
          EdgeInsets.only(right: 16.0, top: 2, bottom: 2, left: 16),
        ),
        constraints: BoxConstraints(maxHeight: 50, maxWidth: 400),
        leading: const Icon(
          Icons.search,
          color: Color.fromARGB(255, 158, 158, 158),
        ),
      ),
    );
  }
}
