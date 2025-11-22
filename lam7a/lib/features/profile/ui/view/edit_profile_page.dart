// lib/features/profile/ui/view/edit_profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';
import '../widgets/edit_profile_form.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final ProfileModel profile;
  const EditProfilePage({super.key, required this.profile});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final GlobalKey<EditProfileFormState> _formKey = GlobalKey<EditProfileFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
        actions: [
          TextButton(
            onPressed: () async {
              final updated = await _formKey.currentState?.saveProfile();
              if (updated != null && mounted) {
                Navigator.pop(context, updated);
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: EditProfileForm(key: _formKey, profile: widget.profile),
    );
  }
}
