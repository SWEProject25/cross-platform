import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recent_searchs_view.dart';
import '../../viewmodel/search_viewmodel.dart';
import 'search_autocomplete_view.dart';
import '../search_result_page.dart';
import '../../viewmodel/search_results_viewmodel.dart';

class SearchMainPage extends ConsumerStatefulWidget {
  final String? initialQuery;

  const SearchMainPage({super.key, this.initialQuery});

  static const Key scaffoldKey = Key('search_scaffold');
  static const Key appBarKey = Key('search_app_bar');
  static const Key backButtonKey = Key('search_back_button');
  static const Key textFieldKey = Key('search_text_field');
  static const Key clearButtonKey = Key('search_clear_button');
  static const Key animatedSwitcherKey = Key('search_animated_switcher');

  @override
  ConsumerState<SearchMainPage> createState() => _SearchMainPageState();
}

class _SearchMainPageState extends ConsumerState<SearchMainPage> {
  @override
  void initState() {
    super.initState();

    final initial = widget.initialQuery;
    if (initial != null && initial.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final vm = ref.read(searchViewModelProvider.notifier);
        vm.insertSearchedTerm(initial);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(searchViewModelProvider);
    final vm = ref.read(searchViewModelProvider.notifier);
    ThemeData theme = Theme.of(context);

    final searchController = vm.searchController;

    return Scaffold(
      key: SearchMainPage.scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: _buildAppBar(context, searchController, vm),
      body: Column(
        children: [
          const Divider(color: Colors.white10, height: 1),

          Expanded(
            child: AnimatedSwitcher(
              key: SearchMainPage.animatedSwitcherKey,
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
    final theme = Theme.of(context);
    return AppBar(
      key: SearchMainPage.appBarKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      titleSpacing: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            key: SearchMainPage.backButtonKey,
            icon: Icon(
              Icons.arrow_back,
              color: theme.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              size: 26,
            ),
            onPressed: () => Navigator.pop(context),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 18),
              alignment: Alignment.center,
              child: TextField(
                key: SearchMainPage.textFieldKey,
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
                  hintStyle: TextStyle(
                    color: theme.brightness == Brightness.light
                        ? Colors.black54
                        : Colors.white54,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  fillColor: theme.scaffoldBackgroundColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),

                  suffixIcon: (controller?.text.isNotEmpty ?? false)
                      ? IconButton(
                          key: SearchMainPage.clearButtonKey,
                          icon: Icon(
                            Icons.close,
                            color: theme.brightness == Brightness.light
                                ? Colors.black54
                                : Colors.white54,
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
    if (trimmed.length < 3) return;

    final vm = ref.read(searchViewModelProvider.notifier);
    vm.pushAutocomplete(trimmed);

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
    return const SearchAutocompleteView(key: ValueKey("autocomplete_view"));
  }
}
