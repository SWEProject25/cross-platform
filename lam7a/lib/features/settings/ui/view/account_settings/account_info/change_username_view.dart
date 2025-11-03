// lib/features/settings/view/change_username_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodel/change_username_viewmodel.dart';
import '../../../widgets/settings_textfield.dart';
import '../../../widgets/blue_x_button.dart';

class ChangeUsernameView extends ConsumerStatefulWidget {
  const ChangeUsernameView({super.key});

  @override
  ConsumerState<ChangeUsernameView> createState() => _ChangeUsernameViewState();
}

class _ChangeUsernameViewState extends ConsumerState<ChangeUsernameView> {
  late final TextEditingController _newController;

  @override
  void initState() {
    super.initState();
    _newController = TextEditingController();
  }

  @override
  void dispose() {
    _newController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changeUsernameProvider);
    final vm = ref.read(changeUsernameProvider.notifier);
    final theme = Theme.of(context);

    // Keep controller text synced with state
    if (_newController.text != state.newUsername) {
      _newController.text = state.newUsername;
      _newController.selection = TextSelection.fromPosition(
        TextPosition(offset: _newController.text.length),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Change username', style: theme.textTheme.titleLarge!),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current',
              style: theme.textTheme.bodySmall!.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF212426))),
              ),
              child: Text(
                state.currentUsername,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 28),
            SettingsTextField(
              label: 'New',
              hint: '@username',
              controller: _newController,
              onChanged: vm.updateUsername,
              obscureText: false,
            ),
          ],
        ),
      ),

      // 👇 Replace bottomNavigationBar with floating button
      floatingActionButton: BlueXButton(
        isActive: state.isValid,
        isLoading: state.isLoading,
        onPressed: () async {
          await vm.saveUsername();
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Username updated')));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
