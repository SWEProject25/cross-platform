// lib/features/profile/ui/view/edit_profile_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/profile/model/profile_model.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final ProfileModel profile;

  const EditProfilePage({
    super.key,
    required this.profile,
  });

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController nameCtrl;
  late TextEditingController bioCtrl;
  late TextEditingController locationCtrl;
  late TextEditingController websiteCtrl;
  late TextEditingController birthdayCtrl;

  String? newBannerPath;
  String? newAvatarPath;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.profile.displayName);
    bioCtrl = TextEditingController(text: widget.profile.bio);
    locationCtrl = TextEditingController(text: widget.profile.location);
    websiteCtrl = TextEditingController(text: widget.profile.website);
    birthdayCtrl = TextEditingController(text: widget.profile.birthday);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    bioCtrl.dispose();
    locationCtrl.dispose();
    websiteCtrl.dispose();
    birthdayCtrl.dispose();
    super.dispose();
  }

  Future<void> pickBanner() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => newBannerPath = file.path);
  }

  Future<void> pickAvatar() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => newAvatarPath = file.path);
  }

  Future<void> save() async {
    if (_saving) return;

    setState(() => _saving = true);

    final updatedModel = widget.profile.copyWith(
      displayName: nameCtrl.text.trim(),
      bio: bioCtrl.text.trim(),
      location: locationCtrl.text.trim(),
      website: websiteCtrl.text.trim(),
      birthday: birthdayCtrl.text.trim(),
    );

    final repo = ref.read(profileRepositoryProvider);

    try {
      final saved = await repo.updateMyProfile(
        updatedModel,
        avatarPath: newAvatarPath,
        bannerPath: newBannerPath,
      );

      if (mounted) Navigator.pop(context, saved);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)),
        title: const Text("Edit profile"),
        actions: [
          TextButton(
            onPressed: _saving ? null : save,
            child: Text(
              "Save",
              style: TextStyle(
                color: _saving ? Colors.grey : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  color: Colors.black12,
                  child: newBannerPath != null
                      ? Image.file(File(newBannerPath!), fit: BoxFit.cover)
                      : (widget.profile.bannerImage.isNotEmpty
                          ? Image.network(widget.profile.bannerImage,
                              fit: BoxFit.cover)
                          : Container(color: Colors.grey[300])),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: pickBanner,
                    icon: const Icon(Icons.camera_alt_outlined,
                        color: Colors.white),
                  ),
                ),
              ],
            ),

            // Avatar
            Container(
              height: 80,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 38,
                      backgroundImage: newAvatarPath != null
                          ? FileImage(File(newAvatarPath!))
                          : (widget.profile.avatarImage.isNotEmpty
                              ? NetworkImage(widget.profile.avatarImage)
                              : null) as ImageProvider?,
                    ),
                  ),
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt_outlined),
                      onPressed: pickAvatar,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            buildField("Name", nameCtrl),
            buildField("Bio", bioCtrl, maxLines: 3),
            buildField("Location", locationCtrl),
            buildField("Website", websiteCtrl),
            buildField("Birthday (YYYY-MM-DD)", birthdayCtrl),
          ],
        ),
      ),
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ]),
    );
  }
}
