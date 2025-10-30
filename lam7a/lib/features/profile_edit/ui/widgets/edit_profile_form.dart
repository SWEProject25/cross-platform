import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/edit_profile_model.dart';
import '../viewmodel/edit_profile_viewmodel.dart';

class EditProfileForm extends ConsumerStatefulWidget {
  final EditProfileModel profile;

  const EditProfileForm({
    super.key,
    required this.profile,
  });

  @override
  ConsumerState<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends ConsumerState<EditProfileForm> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.displayName);
    bioController = TextEditingController(text: widget.profile.bio);
    locationController = TextEditingController(text: widget.profile.location);
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(editProfileViewModelProvider.notifier);
    final profileState = ref.watch(editProfileViewModelProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.network(
                widget.profile.bannerImage,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 16,
                bottom: -40,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(widget.profile.avatarImage),
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),

          _buildTextField(nameController, 'Display Name'),
          _buildTextField(bioController, 'Bio', maxLines: 3),
          _buildTextField(locationController, 'Location'),

          const SizedBox(height: 16),

          profileState.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, _) => Text('❌ Error: $error'),
            data: (_) => ElevatedButton(
              onPressed: () async {
                final updatedProfile = EditProfileModel(
                  displayName: nameController.text,
                  bio: bioController.text,
                  location: locationController.text,
                  avatarImage: widget.profile.avatarImage,
                  bannerImage: widget.profile.bannerImage,
                );

                await viewModel.saveProfile(updatedProfile);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Profile saved successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
