// lib/features/profile/ui/widgets/edit_profile_form.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';

class EditProfileForm extends ConsumerStatefulWidget {
  final UserModel user;
  const EditProfileForm({super.key, required this.user});

  @override
  EditProfileFormState createState() => EditProfileFormState();
}

class EditProfileFormState extends ConsumerState<EditProfileForm> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController locationController;
  late TextEditingController websiteController;

  File? newBanner;
  File? newAvatar;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name ?? '');
    bioController = TextEditingController(text: widget.user.bio ?? '');
    locationController = TextEditingController(text: widget.user.location ?? '');
    websiteController = TextEditingController(text: widget.user.website ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    locationController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  bool _isValidName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return false;
    if (trimmed.length < 5 || trimmed.length > 30) return false;
    final validNameRegex = RegExp(r'^[a-zA-Z0-9 _.-]+$');
    return validNameRegex.hasMatch(trimmed);
  }

  Future<void> pickBanner() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => newBanner = File(picked.path));
  }

  Future<void> pickAvatar() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => newAvatar = File(picked.path));
  }

  Future<UserModel?> saveProfile() async {
    setState(() => saving = true);
    final repo = ref.read(profileRepositoryProvider);

    final name = nameController.text.trim();

    if (!_isValidName(name)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Name must be 5–30 characters and cannot contain emojis or only spaces',
            ),
          ),
        );
      }
      setState(() => saving = false);
      return null;
    }


    final updated = widget.user.copyWith(
      name: name,
      bio: bioController.text.trim(),
      location: locationController.text.trim(),
      website: websiteController.text.trim(),
    );

    try {
      final result = await repo.updateMyProfile(updated, avatarPath: newAvatar?.path, bannerPath: newBanner?.path);
      return result;
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
      return null;
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  ImageProvider _imageProvider(String? path) {
    if (path == null || path.isEmpty) return const NetworkImage('https://via.placeholder.com/400x150');
    if (path.startsWith('http')) return NetworkImage(path);
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    final bannerImage = newBanner != null ? FileImage(newBanner!) : _imageProvider(widget.user.bannerImageUrl);
    final avatarImage = newAvatar != null ? FileImage(newAvatar!) : _imageProvider(widget.user.profileImageUrl);

    return SingleChildScrollView(
      key: const ValueKey('edit_profile_form'),
      child: Column(children: [
        GestureDetector(key: const ValueKey('edit_profile_banner_picker'), onTap: pickBanner, child: Image(image: bannerImage, width: double.infinity, height: 180, fit: BoxFit.cover)),
        const SizedBox(height: 12),
        GestureDetector(key: const ValueKey('edit_profile_avatar_picker'), onTap: pickAvatar, child: CircleAvatar(backgroundImage: avatarImage, radius: 48)),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            TextField(key: const ValueKey('edit_profile_name_input'), controller: nameController, maxLength: 30, decoration: const InputDecoration(labelText: 'Display name')),
            //TextField(controller: bioController, decoration: const InputDecoration(labelText: 'Bio')),
            TextField(
              key: const ValueKey('edit_profile_bio_input'),
              controller: bioController,
              maxLength: 160,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Bio',
                counterText: "", 
              ),
            ),

            TextField(key: const ValueKey('edit_profile_location_input'), controller: locationController, decoration: const InputDecoration(labelText: 'Location')),
            TextField(key: const ValueKey('edit_profile_website_input'), controller: websiteController, decoration: const InputDecoration(labelText: 'Website')),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const ValueKey('edit_profile_save_button'),
              onPressed: saving ? null : () async {
                final res = await saveProfile();
                if (res != null && mounted) Navigator.of(context).pop(res);
              },
              child: saving ? const CircularProgressIndicator() : const Text('Save'),
            ),
          ]),
        ),
      ]),
    );
  }
}

