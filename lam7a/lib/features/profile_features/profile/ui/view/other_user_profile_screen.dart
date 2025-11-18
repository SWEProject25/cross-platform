import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/profile_header_viewmodel.dart';
import '../widgets/other_profile_header_widget.dart';
import '../widgets/other_profile_tab_bar.dart';   


class OtherUserProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const OtherUserProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<OtherUserProfileScreen> createState() =>
      _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState
    extends ConsumerState<OtherUserProfileScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileHeaderViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
        /// ADD APPBAR HERE
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == "mute") {
                debugPrint("User muted");
              } else if (value == "block") {
                debugPrint("User blocked");
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "mute",
                child: Text("Mute"),
              ),
              const PopupMenuItem(
                value: "block",
                child: Text("Block"),
              ),
            ],
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (profile) {
          return NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    OtherProfileHeaderWidget(profile: profile),
                    const SizedBox(height: 10),

                    /// -------- TABS --------
                    OtherProfileTabBar(
                      selectedIndex: selectedIndex,
                      onTabSelected: (i) {
                        setState(() => selectedIndex = i);
                      },
                    ),

                    const Divider(height: 1),
                  ],
                ),
              ),
            ],

            /// ---------- SCROLLABLE TAB CONTENT ----------
            body: _buildTabContent(),
          );
        },
      ),
    );
  }

  /// ------------------------------------------
  ///         TAB CONTENT BUILDER
  /// ------------------------------------------
  Widget _buildTabContent() {
    switch (selectedIndex) {
      case 0:
        return _buildListPlaceholder("Posts from this user");
      case 1:
        return _buildListPlaceholder("User replies");
      case 2:
        return _buildListPlaceholder("Media shared by user");
      default:
        return const Center(child: Text("Unknown tab"));
    }
  }

  /// ------------------------------------------
  ///       TEMP PLACEHOLDER LIST VIEW
  /// (Scroll-friendly, no overflow problems)
  /// ------------------------------------------
  Widget _buildListPlaceholder(String title) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 15,
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "$title - Item #$index",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}

