import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recent_searchs_view.dart';
import '../../viewmodel/search_viewmodel.dart';
import 'search_autocomplete_view.dart';
import '../search_result_page.dart';
import '../../viewmodel/search_results_viewmodel.dart';

class SearchMainPage extends ConsumerStatefulWidget {
  const SearchMainPage({super.key});

  @override
  ConsumerState<SearchMainPage> createState() => _SearchMainPageState();
}

class _SearchMainPageState extends ConsumerState<SearchMainPage> {
  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(searchViewModelProvider);
    final vm = ref.read(searchViewModelProvider.notifier);

    final state = asyncState.value;

    final searchController = vm.searchController;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(context, searchController, vm),
      body: Column(
        children: [
          const Divider(color: Colors.white10, height: 1),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _buildSwitcherChild(searchController),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------------------------------------
  /// AppBar with back + search bar + clear button
  /// ---------------------------------------------
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    TextEditingController? controller,
    SearchViewModel vm,
  ) {
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
              padding: const EdgeInsets.only(left: 18),
              alignment: Alignment.center,
              child: TextField(
                controller: controller,
                cursorColor: const Color(0xFF1DA1F2),
                style: const TextStyle(
                  color: Color(0xFF1DA1F2),
                  fontSize: 16,
                  height: 1.2,
                ),
                // Ensure the IME shows a search icon/action
                textInputAction: TextInputAction.search,

                // Primary handler: when pressing the search action on keyboard
                onSubmitted: (query) {
                  _onSearchSubmitted(context, query);
                },

                decoration: InputDecoration(
                  hintText: "Search X",
                  hintStyle: const TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  fillColor: Colors.black,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),

                  suffixIcon: (controller?.text.isNotEmpty ?? false)
                      ? IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            controller?.clear();
                            vm.onChanged("");
                            setState(() {});
                          },
                        )
                      : null,
                ),

                onChanged: (value) {
                  vm.onChanged(value);
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSearchSubmitted(BuildContext context, String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    // Push a new page with its own provider instance so each SearchResultPage
    // has its own SearchResultsViewmodel instance and state.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProviderScope(
          // overrideWith is used to create a fresh SearchResultsViewmodel for this page
          overrides: [
            searchResultsViewModelProvider.overrideWith(
              // create new instance for each pushed page
              () => SearchResultsViewmodel(),
            ),
          ],
          child: SearchResultPage(hintText: trimmed),
        ),
      ),
    );
  }

  /// ---------------------------------------------
  /// Placeholder for AnimatedSwitcher child
  /// ---------------------------------------------
  Widget _buildSwitcherChild(TextEditingController? controller) {
    final text = controller?.text.trim() ?? "";
    if (text.isEmpty) {
      return const RecentView(key: ValueKey("recent_view"));
    }

    // When the user types → show autocomplete + suggested users
    return const SearchAutocompleteView(key: ValueKey("autocomplete_view"));
  }
}
