// lib/features/profile/ui/view/edit_profile_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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

  bool _isValidName(String name) {
    final trimmed = name.trim();

    if (trimmed.isEmpty) return false;
    if (trimmed.length < 5) return false;
    if (trimmed.length > 30) return false;

    
    final validNameRegex = RegExp(r'^[a-zA-Z0-9 _.-]+$');
    return validNameRegex.hasMatch(trimmed);
  }

  bool _isValidBirthYear(String birthDate) {
    if (birthDate.isEmpty) return true; 

    final maxAllowedYear = 2010;
    final parts = birthDate.split('-');
    if (parts.isEmpty) return false;

    final year = int.tryParse(parts[0]);
    if (year == null) return false;

    // Max allowed year = 2010
    return year <= maxAllowedYear;
  }

  bool _isValidWebsite(String website) {
    if (website.isEmpty) return true; 

    // No emojis or spaces
    final validChars = RegExp(r"^[a-zA-Z0-9\-._~:/?#\[\]@!$&\'()*+,;=%]+$");
    if (!validChars.hasMatch(website)) return false;

    // Must look like a domain
    final domainRegex = RegExp(
      r'^(https?:\/\/)?([\w-]+\.)+[\w-]{2,}$',
    );

    return domainRegex.hasMatch(website);
  }


  Future<void> pickAvatar() async {
    final f = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (f != null) setState(() => newAvatarPath = f.path);
  }

  Future<void> pickBanner() async {
    final f = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (f != null) setState(() => newBannerPath = f.path);
  }

  Future<void> deleteAvatar() async {
    final repo = ref.read(profileRepositoryProvider);
    await repo.deleteAvatar();

    if (mounted) {
      setState(() {
        newAvatarPath = null;
      });
    }
  }

  Future<void> deleteBanner() async {
    final repo = ref.read(profileRepositoryProvider);
    await repo.deleteBanner();

    if (mounted) {
      setState(() {
        newBannerPath = null;
      });
    }
  }


  Future<void> save() async {
    if (_saving) return;
    setState(() => _saving = true);

    final name = nameCtrl.text.trim();

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
      setState(() => _saving = false);
      return;
    }

    final birthDate = birthDateCtrl.text.trim();

    if (!_isValidBirthYear(birthDate)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Birth year must be 2010 or earlier',
            ),
          ),
        );
      }
      setState(() => _saving = false);
      return;
    }

    final website = websiteCtrl.text.trim();

    if (!_isValidWebsite(website)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid website URL'),
          ),
        );
      }
      setState(() => _saving = false);
      return;
    }

    final normalizedWebsite =
        website.isNotEmpty && !website.startsWith('http')
            ? 'https://$website'
            : website;

    final updated = widget.user.copyWith(
      name: name,
      bio: bioCtrl.text.trim(),
      location: locationCtrl.text.trim(),
      website: normalizedWebsite,
      birthDate: birthDate,
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



  Widget buildField(String label, TextEditingController c, {int maxLines = 1, int? maxLength, Key? fieldKey,}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 6),
        TextField(
          key: fieldKey,
          controller: c,
          maxLines: maxLines,
          maxLength: maxLength, 
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

    final bannerProvider = (newBannerPath != null) ? FileImage(File(newBannerPath!)) : (widget.user.bannerImageUrl != null && widget.user.bannerImageUrl!.isNotEmpty ? NetworkImage(widget.user.bannerImageUrl!) : const AssetImage('assets/images/Blue-Background-Download-PNG-Image.png')) as ImageProvider;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(key: const ValueKey('edit_profile_close_button'), icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: const Text('Edit profile'),
        actions: [
          TextButton(key: const ValueKey('edit_profile_save_button'), onPressed: _saving ? null : save, child: Text('Save', style: TextStyle(color: _saving ? Colors.grey : Colors.blue, fontWeight: FontWeight.bold))),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          GestureDetector(
            key: const ValueKey('edit_profile_banner_picker'),
            onTap: pickBanner,
            child: Image(image: bannerProvider, width: double.infinity, height: 160, fit: BoxFit.cover),
          ),
          if (widget.user.bannerImageUrl != null || newBannerPath != null)
            TextButton(
              onPressed: deleteBanner,
              child: const Text(
                'Remove banner',
                style: TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                key: const ValueKey('edit_profile_avatar_picker'),
                onTap: pickAvatar,
                child: CircleAvatar(
                  radius: 46,
                  backgroundImage: avatarProvider,
                ),
              ),

              if (widget.user.profileImageUrl != null || newAvatarPath != null)
                TextButton(
                  onPressed: deleteAvatar,
                  child: const Text(
                    'Remove avatar',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          buildField('Name', nameCtrl, maxLength: 30, fieldKey: const ValueKey('edit_profile_name_field'),),
          buildField('Bio', bioCtrl, maxLines: 3, maxLength: 160, fieldKey: const ValueKey('edit_profile_bio_field'),),
          buildField('Location', locationCtrl, fieldKey: const ValueKey('edit_profile_location_field'),),
          buildField('Website', websiteCtrl, fieldKey: const ValueKey('edit_profile_website_field'),),
          buildField('Birthday (YYYY-MM-DD)', birthDateCtrl, fieldKey: const ValueKey('edit_profile_birthdate_field'),),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}
