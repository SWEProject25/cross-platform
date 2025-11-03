import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../profile/model/profile_model.dart';
import '../widgets/edit_profile_form.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final ProfileHeaderModel profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  // Key to access the form’s state (so we can trigger save from AppBar)
  final GlobalKey<EditProfileFormState> _formKey =
      GlobalKey<EditProfileFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () async {
              final updatedProfile = await _formKey.currentState?.saveProfile();
              if (updatedProfile != null && context.mounted) {
                Navigator.pop(context, updatedProfile);
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: EditProfileForm(
        key: _formKey,
        profile: widget.profile,
      ),
    );
  }
}
