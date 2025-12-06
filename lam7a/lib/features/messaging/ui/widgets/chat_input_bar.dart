import 'package:flutter/material.dart';
import 'package:lam7a/core/utils.dart';
import 'package:lam7a/features/messaging/ui_keys.dart';

class ChatInputBar extends StatefulWidget {
  final String draftMessage;
  final void Function()? onSend;
  final void Function(String message)? onUpdate;

  const ChatInputBar({Key? key, required this.draftMessage, this.onSend, this.onUpdate}) : super(key: key);

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar>
    with TickerProviderStateMixin {
  static const int _fadeDurationMs = 200;
  static const int _slideDurationMs = 150;
  static const int _expandDelayMs = 200;

  final FocusNode _smallFocus = FocusNode();
  final FocusNode _largeFocus = FocusNode();
  bool _isFocused = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _fadeOutAnimation;
  late Animation<Offset> _slideInAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _fadeDurationMs),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _slideDurationMs),
    );

    _fadeOutAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideInAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _smallFocus.addListener(() {
      if (_smallFocus.hasFocus) {
        _handleExpand();
      }
    });

    _largeFocus.addListener(() {
      if (!_largeFocus.hasFocus) {
        _handleCollapse();
      }
    });
  }

  void _handleExpand() {
    if (!mounted) return;
    setState(() => _isFocused = true);
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: _expandDelayMs), () {
      if (mounted) {
        _slideController.forward();
        FocusScope.of(context).requestFocus(_largeFocus);
      }
    });
  }

  void _handleCollapse() {
    _slideController.reverse();
    _fadeController.reverse();
    Future.delayed(const Duration(milliseconds: _expandDelayMs), () {
      if (mounted) setState(() => _isFocused = false);
    });
  }

  @override
  void dispose() {
    _smallFocus.dispose();
    _largeFocus.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AnimatedSize(
      duration: const Duration(milliseconds: _expandDelayMs),
      curve: Curves.easeInOut,
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.light? hexToColor("eef2f5") : hexToColor("21282e"),
          //  Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isFocused)
              SlideTransition(
                position: _slideInAnimation,
                child: _buildTextField(_largeFocus, true),
              ),
            Row(
              children: [
                Expanded(
                  child: FadeTransition(
                    opacity: ReverseAnimation(_fadeOutAnimation),
                    child: !_isFocused
                        ? _buildMessagePreviewText(theme)
                        : const SizedBox.shrink(),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 18,
                  child: IconButton(
                    key: Key(MessagingUIKeys.chatInputSendButton),
                    onPressed: 
                        widget.draftMessage.trim().isEmpty
                        ? null
                        : () {
                            widget.onSend?.call();
                          },
                    icon: Icon(Icons.send, size: 22),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildMessagePreviewText(ThemeData theme) {
    return GestureDetector(
      key: Key("chat_input_gesture_detector"),
      onTap: () => setState(() {
        _handleExpand();
      }),
      child: Text(
        widget.draftMessage.isEmpty
            ? "Start a message..."
            : widget.draftMessage.replaceAll(RegExp(r'\s+'), ' ').trim(),
        style: theme.inputDecorationTheme.hintStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  TextField _buildTextField(FocusNode focusNode, bool isExpanded) {
    return TextField(
      key: Key(MessagingUIKeys.chatInputTextField),
      focusNode: focusNode,
      style: const TextStyle(fontSize: 14),
      decoration: const InputDecoration(
        hintText: 'Start a message...',
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        isDense: true,
        fillColor: Colors.transparent,
      ),
      // controller: TextEditingController.fromValue(
      //   TextEditingValue(
      //     text: widget.draftMessage,
      //   ),
      // ),
      controller: TextEditingController.fromValue(TextEditingValue(
        text: widget.draftMessage,
        selection: TextSelection.collapsed(offset: widget.draftMessage.length),
      )),
      onChanged: (value) => widget.onUpdate?.call(value),
      minLines: 1,
      maxLines: isExpanded ? 3 : 1,
    );
  }
}
