// lib/features/profile/ui/view/edit_profile_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final UserModel user;
  const EditProfilePage({super.key, required this.user});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController nameCtrl;
  late TextEditingController bioCtrl;
  late TextEditingController locationCtrl;
  late TextEditingController websiteCtrl;
  late TextEditingController birthDateCtrl;

  String? newAvatarPath;
  String? newBannerPath;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.user.name ?? '');
    bioCtrl = TextEditingController(text: widget.user.bio ?? '');
    locationCtrl = TextEditingController(text: widget.user.location ?? '');
    websiteCtrl = TextEditingController(text: widget.user.website ?? '');
    birthDateCtrl = TextEditingController(text: (widget.user.birthDate ?? '').split('T').first);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    bioCtrl.dispose();
    locationCtrl.dispose();
    websiteCtrl.dispose();
    birthDateCtrl.dispose();
    super.dispose();
  }

  Future<void> pickAvatar() async {
    final f = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (f != null) setState(() => newAvatarPath = f.path);
  }

  Future<void> pickBanner() async {
    final f = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (f != null) setState(() => newBannerPath = f.path);
  }

  Future<void> save() async {
    if (_saving) return;
    setState(() => _saving = true);

    final updated = widget.user.copyWith(
      name: nameCtrl.text.trim(),
      bio: bioCtrl.text.trim(),
      location: locationCtrl.text.trim(),
      website: websiteCtrl.text.trim(),
      birthDate: birthDateCtrl.text.trim(),
      profileImageUrl: newAvatarPath ?? widget.user.profileImageUrl,
      bannerImageUrl: newBannerPath ?? widget.user.bannerImageUrl,
    );

    final repo = ref.read(profileRepositoryProvider);

    try {
      final saved = await repo.updateMyProfile(updated, avatarPath: newAvatarPath, bannerPath: newBannerPath);
      if (mounted) Navigator.pop(context, saved);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // Widget buildField(String label, TextEditingController c, {int maxLines = 1}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //       Text(label, style: const TextStyle(color: Colors.grey)),
  //       const SizedBox(height: 6),
  //       TextField(controller: c, maxLines: maxLines, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
  //     ]),
  //   );
  // }

  Widget buildField(String label, TextEditingController c, {int maxLines = 1, int? maxLength}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          maxLines: maxLines,
          maxLength: maxLength,  // <-- ADD THIS
          decoration: InputDecoration(
            counterText: "",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final avatarProvider = (newAvatarPath != null) ? FileImage(File(newAvatarPath!)) : (widget.user.profileImageUrl != null && widget.user.profileImageUrl!.isNotEmpty ? NetworkImage(widget.user.profileImageUrl!) : const AssetImage('assets/images/user_profile.png')) as ImageProvider;

    final bannerProvider = (newBannerPath != null) ? FileImage(File(newBannerPath!)) : (widget.user.bannerImageUrl != null && widget.user.bannerImageUrl!.isNotEmpty ? NetworkImage(widget.user.bannerImageUrl!) : const AssetImage('assets/images/banner_placeholder.png')) as ImageProvider;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: const Text('Edit profile'),
        actions: [
          TextButton(onPressed: _saving ? null : save, child: Text('Save', style: TextStyle(color: _saving ? Colors.grey : Colors.blue, fontWeight: FontWeight.bold))),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          GestureDetector(
            onTap: pickBanner,
            child: Image(image: bannerProvider, width: double.infinity, height: 160, fit: BoxFit.cover),
          ),
          const SizedBox(height: 12),
          Container(
            alignment: Alignment.centerLeft,
            child: GestureDetector(onTap: pickAvatar, child: CircleAvatar(radius: 46, backgroundImage: avatarProvider))
            ),
          
          const SizedBox(height: 12),
          buildField('Name', nameCtrl),
          buildField('Bio', bioCtrl, maxLines: 3, maxLength: 160),
          buildField('Location', locationCtrl),
          buildField('Website', websiteCtrl),
          buildField('Birthday (YYYY-MM-DD)', birthDateCtrl),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}
