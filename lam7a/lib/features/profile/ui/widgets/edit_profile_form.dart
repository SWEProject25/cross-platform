// lib/features/profile/ui/widgets/edit_profile_form.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';

class EditProfileForm extends ConsumerStatefulWidget {
  final ProfileModel profile;
  const EditProfileForm({super.key, required this.profile});

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
    nameController = TextEditingController(text: widget.profile.displayName);
    bioController = TextEditingController(text: widget.profile.bio);
    locationController = TextEditingController(text: widget.profile.location);
    websiteController = TextEditingController(text: widget.profile.website);
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    locationController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  Future<void> pickBanner() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => newBanner = File(picked.path));
  }

  Future<void> pickAvatar() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => newAvatar = File(picked.path));
  }

  Future<ProfileModel?> saveProfile() async {
    setState(() => saving = true);
    final repo = ref.read(profileRepositoryProvider);

    final updated = widget.profile.copyWith(
      displayName: nameController.text,
      bio: bioController.text,
      location: locationController.text,
      website: websiteController.text,
    );

    try {
      final result = await repo.updateMyProfile(
        updated,
        avatarPath: newAvatar?.path,
        bannerPath: newBanner?.path,
      );
      return result;
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
      return null;
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  ImageProvider _imageProvider(String path) {
    if (path.isEmpty) return const NetworkImage('https://via.placeholder.com/400x150');
    if (path.startsWith('http')) return NetworkImage(path);
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    final bannerImage = newBanner != null ? FileImage(newBanner!) : _imageProvider(widget.profile.bannerImage);
    final avatarImage = newAvatar != null ? FileImage(newAvatar!) : _imageProvider(widget.profile.avatarImage);

    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(onTap: pickBanner, child: Image(image: bannerImage, width: double.infinity, height: 180, fit: BoxFit.cover)),
          const SizedBox(height: 12),
          GestureDetector(onTap: pickAvatar, child: CircleAvatar(backgroundImage: avatarImage, radius: 48)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Display name')),
              TextField(controller: bioController, decoration: const InputDecoration(labelText: 'Bio')),
              TextField(controller: locationController, decoration: const InputDecoration(labelText: 'Location')),
              TextField(controller: websiteController, decoration: const InputDecoration(labelText: 'Website')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saving ? null : () async {
                  final res = await saveProfile();
                  if (res != null && mounted) Navigator.of(context).pop(res);
                },
                child: saving ? const CircularProgressIndicator() : const Text('Save'),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
