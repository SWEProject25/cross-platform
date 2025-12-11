import 'package:flutter/material.dart';
import 'package:lam7a/core/theme/app_pallete.dart';

// ignore: must_be_immutable
class TextInputField extends StatefulWidget {
  String labelTextField;
  bool isLimited;
  bool isPassword;
  bool isValid;
  bool isDate;
  int flex;
  Function onChangeEffect;
  TextInputType textType;
  String content;
  bool enabled;
  bool isLoginField;
  String errorText;
  TextInputField({
    super.key,
    required this.labelTextField,
    this.isLimited = false,
    required this.flex,
    required this.textType,
    this.isPassword = false,
    this.isDate = false,
    required this.isValid,
    required this.onChangeEffect,
    this.content = "",
    this.enabled = true,
    this.isLoginField = false,
    this.errorText = "",
  });

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool isVisible = false;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;
  @override
  void initState() {
    super.initState();
    _controller.text = widget.content;
    _focusNode.addListener(() {
      setState(() {
        print('Focus changed: ${_focusNode.hasFocus}');
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.isLimited ? 2 : 25),
      child: Row(
        children: [
          Spacer(flex: 1),
          Expanded(
            flex: widget.flex,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  child: TextFormField(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                    enabled: widget.enabled,
                    onChanged: (value) {
                      widget.onChangeEffect(value);
                      // setState(() {});
                    },
                    obscureText: (widget.isPassword && !isVisible),
                    keyboardType: widget.textType,
                    onTap: () {
                      if (widget.isDate) selectDate(context);
                    },
                    controller: _controller,
                    focusNode: _focusNode,

                    maxLength: 50,
                    buildCounter:
                        (
                          context, {
                          required int currentLength,
                          required bool isFocused,
                          required int? maxLength,
                        }) {
                          if (widget.isLimited) {
                            return Text("$currentLength/$maxLength");
                          }
                          return null;
                        },
                    cursorColor: Theme.of(context).colorScheme.onSurface,
                    autofocus: false,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: widget.labelTextField,
                      labelStyle: TextStyle(color: Pallete.subtitleText),
                      helperText:  _isFocused ? widget.errorText : "",
                      helperStyle: TextStyle(color: Pallete.errorColor,),
                      helperMaxLines: 10,
                      floatingLabelStyle: (_isFocused)
                          ? TextStyle(
                              color:
                                  (widget.isValid || _controller.text.isEmpty)
                                  ? Pallete.borderHover
                                  : Pallete.errorColor,
                            )
                          : TextStyle(color: Pallete.subtitleText),

                      fillColor: Theme.of(context).colorScheme.surface,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Pallete.subtitleText),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Pallete.subtitleText),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: (widget.isValid || _controller.text.isEmpty)
                              ? Pallete.borderHover
                              : Pallete.errorColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),

                      // focusedBorder:
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.isPassword
                        ? Container(
                            margin: EdgeInsets.only(top: 5),
                            child: isVisible
                                ? IconButton(
                                    icon: Icon(Icons.visibility_sharp),
                                    onPressed: () {
                                      isVisible = !isVisible;
                                      setState(() {});
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(Icons.visibility_off_sharp),
                                    onPressed: () {
                                      isVisible = !isVisible;
                                      setState(() {});
                                    },
                                  ),
                          )
                        : Container(),
                    (_controller.text.isNotEmpty && !widget.isLoginField)
                        ? ((widget.isValid)
                              ? Container(
                                  margin: EdgeInsets.only(
                                    right: 5,
                                    top: !widget.isPassword ? 15 : 7,
                                  ),
                                  child: Icon(
                                    Icons.check_circle_sharp,
                                    color: Pallete.greenColor,
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(
                                    right: 5,
                                    top: !widget.isPassword ? 15 : 7,
                                  ),
                                  child: Icon(
                                    Icons.error,
                                    color: Pallete.errorColor,
                                  ),
                                ))
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
          Spacer(flex: 1),
        ],
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1930, 1, 1),
      lastDate: DateTime.now(),
      initialDate: DateTime(2000, 1, 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
                    primary: Colors.blue, // Header background & selected date
                    onPrimary: Colors.white, // Header text color
                    surface: const Color.fromARGB(
                      255,
                      44,
                      44,
                      44,
                    )!, // Calendar background
                    onSurface: const Color.fromARGB(255, 165, 165, 165),
                  )
                : Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      String formattedText =
          "${pickedDate.year}-${pickedDate.month < 10 ? "0" : ""}${pickedDate.month}-${pickedDate.day < 10 ? "0" : ""}${pickedDate.day}";
      _controller.text = formattedText;
      widget.onChangeEffect(formattedText);
    }
  }
}
