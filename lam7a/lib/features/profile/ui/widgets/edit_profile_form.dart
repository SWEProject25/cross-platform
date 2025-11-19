// lib/features/profile/ui/widgets/edit_profile_form.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/profile_model.dart';

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
  late TextEditingController birthdayController;

  File? newBanner;
  File? newAvatar;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.displayName);
    bioController = TextEditingController(text: widget.profile.bio);
    locationController = TextEditingController(text: widget.profile.location);
    birthdayController = TextEditingController(text: widget.profile.joinedDate);
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    locationController.dispose();
    birthdayController.dispose();
    super.dispose();
  }

  Future<void> pickBanner() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => newBanner = File(picked.path));
    }
  }

  Future<void> pickAvatar() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => newAvatar = File(picked.path));
    }
  }

  Future<ProfileModel?> saveProfile() async {
    final updated = widget.profile.copyWith(
      displayName: nameController.text,
      bio: bioController.text,
      location: locationController.text,
      bannerImage:
          newBanner != null ? newBanner!.path : widget.profile.bannerImage,
      avatarImage:
          newAvatar != null ? newAvatar!.path : widget.profile.avatarImage,
    );
    return updated;
  }

  ImageProvider<Object> _imageProvider(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return NetworkImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannerProvider = newBanner != null
        ? FileImage(newBanner!)
        : _imageProvider(widget.profile.bannerImage);

    final avatarProvider = newAvatar != null
        ? FileImage(newAvatar!)
        : _imageProvider(widget.profile.avatarImage);

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: pickBanner,
                child: Image(
                  image: bannerProvider,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: -50,
                left: 20,
                child: GestureDetector(
                  onTap: pickAvatar,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: avatarProvider,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(labelText: 'Bio'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: birthdayController,
                  decoration: const InputDecoration(labelText: 'Joined Date'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}