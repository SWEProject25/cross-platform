import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/search_result_state.dart';
import '../../viewmodel/search_results_viewmodel.dart';
import '../../../../common/widgets/user_tile.dart';

class PeopleTab extends ConsumerStatefulWidget {
  final SearchResultState data;
  final SearchResultsViewmodel vm;
  const PeopleTab({super.key, required this.data, required this.vm});

  static const Key contentKey = Key('people_tab_content');

  @override
  ConsumerState<PeopleTab> createState() => _PeopleTabState();
}

class _PeopleTabState extends ConsumerState<PeopleTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    print("People Tab rebuilt");
    super.build(context);

    final theme = Theme.of(context);
    final data = widget.data;

    if (data.isPeopleLoading && data.searchedPeople.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
      );
    }

    if (data.searchedPeople.isEmpty && !data.isPeopleLoading) {
      return Center(
        child: Text(
          "No users found",
          style: TextStyle(
            color: theme.brightness == Brightness.light
                ? Colors.black
                : Colors.white54,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      key: PeopleTab.contentKey,
      padding: const EdgeInsets.only(top: 12),
      itemCount: data.searchedPeople.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: UserTile(user: data.searchedPeople[i]),
        );
      },
    );
  }
}
