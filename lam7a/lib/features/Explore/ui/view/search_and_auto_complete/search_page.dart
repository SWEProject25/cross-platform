import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchMainPage extends ConsumerStatefulWidget {
  const SearchMainPage({super.key});

  @override
  ConsumerState<SearchMainPage> createState() => _SearchMainPageState();
}

class _SearchMainPageState extends ConsumerState<SearchMainPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {}); // updates UI when text changes
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // Divider after appbar
          Divider(color: Colors.white10, height: 1),

          // Twitter Blue indicator bar
          Container(
            height: 3,
            color: const Color(0xFF1DA1F2), // Twitter blue
          ),

          const SizedBox(height: 10),

          // AnimatedSwitcher – YOU WILL PUT THE 2 VIEWS HERE
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _buildSwitcherChild(),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------------------------------------
  /// AppBar with back + search bar + clear button
  /// ---------------------------------------------
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
            onPressed: () => Navigator.pop(context),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: 40,
              alignment: Alignment.center,
              child: TextField(
                controller: _controller,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search X",
                  hintStyle: const TextStyle(color: Colors.white38),

                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,

                  isDense: true,
                  contentPadding: EdgeInsets.zero,

                  // --- "X" clear button ---
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.white54),
                          onPressed: () {
                            _controller.clear();
                            setState(() {});
                          },
                        )
                      : null,
                ),
                onChanged: (_) {
                  // later you will call viewmodel here
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------------------------------------
  /// PlaceHolder for AnimatedSwitcher child
  /// ---------------------------------------------
  Widget _buildSwitcherChild() {
    // Temporary placeholder
    return Container(
      key: const ValueKey("placeholder"),
      color: Colors.transparent,
      alignment: Alignment.topCenter,
      child: const Text(
        "Animated Switcher View Will Appear Here",
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
