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
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Theme.of(context).colorScheme.primary, // Cursor color
          selectionColor: Pallete.whiteColor,
           // Text selection highlight
          selectionHandleColor: Pallete.whiteColor, // Selection handles
        ),
      ),
      child: SearchBar(

        hintText: 'Search X',
        hintStyle: WidgetStatePropertyAll<TextStyle>(
          TextStyle(
            color: Pallete.greyColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.5,
          ),
        ),
        textStyle: WidgetStatePropertyAll<TextStyle>(
          TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.5,
          ),
        ),

        backgroundColor: WidgetStateColor.resolveWith(
          (callback) => !isDark ? Pallete.searchBarBackGround : const Color.fromARGB(255, 61, 61, 61),
        ),
        padding: const WidgetStatePropertyAll<EdgeInsets>(
          EdgeInsets.only(right: 5, top: 4, bottom: 4, left: 8),
        ),
        constraints: BoxConstraints(maxHeight: 50, maxWidth: 250),
      
        elevation: WidgetStatePropertyAll(0),

      ),
    );
  }
}
