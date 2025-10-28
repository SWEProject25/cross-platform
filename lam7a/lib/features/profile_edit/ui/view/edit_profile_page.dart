import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../profile_header/model/profile_header_model.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final ProfileHeaderModel profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.displayName);
    _bioController = TextEditingController(text: widget.profile.bio);
    _locationController = TextEditingController(text: widget.profile.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }
  // does not work yet
  void _onSave() {
    // Build updated ProfileHeaderModel (you can also call ViewModel/repository here)
    final updated = widget.profile.copyWith(
      displayName: _nameController.text,
      bio: _bioController.text,
      location: _locationController.text,
    );

    // Return the updated profile to the previous screen
    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
        actions: [
          TextButton( // not the right position yet
            onPressed: _onSave,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // banner preview
            Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey[300],
              child: Image.network(
                widget.profile.bannerImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 12),
            // avatar preview
            CircleAvatar(
              radius: 48,
              backgroundImage: NetworkImage(widget.profile.avatarImage),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Display name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Bio'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _onSave,
              child: const Text('Save changes'),
            ),
          ],
        ),
      ),
    );
  }
}
