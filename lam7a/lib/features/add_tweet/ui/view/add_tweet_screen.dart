import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/responsive_utils.dart';
import 'package:lam7a/features/add_tweet/ui/viewmodel/add_tweet_viewmodel.dart';
import 'package:lam7a/features/add_tweet/ui/widgets/add_tweet_body_input_widget.dart';
import 'package:lam7a/features/add_tweet/ui/widgets/add_tweet_header_widget.dart';
import 'package:lam7a/features/add_tweet/ui/widgets/add_tweet_toolbar_widget.dart';
import 'dart:io';

class AddTweetScreen extends ConsumerStatefulWidget {
  final String userId;

  const AddTweetScreen({super.key, required this.userId});

  @override
  ConsumerState<AddTweetScreen> createState() => _AddTweetScreenState();
}

class _AddTweetScreenState extends ConsumerState<AddTweetScreen> {
  final TextEditingController _bodyController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Reset state when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addTweetViewmodelProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Pallete.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Pallete.borderHover),
                title: const Text('Take Photo', style: TextStyle(color: Pallete.whiteColor)),
                onTap: () {
                  Navigator.pop(context);
                  _handleImagePick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Pallete.borderHover),
                title: const Text('Choose from Gallery', style: TextStyle(color: Pallete.whiteColor)),
                onTap: () {
                  Navigator.pop(context);
                  _handleImagePick(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleImagePick(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        // In a real app, you'd upload this to a server and get a URL
        // For now, we'll use the local path as a placeholder
        final viewmodel = ref.read(addTweetViewmodelProvider.notifier);
        viewmodel.updateMediaPic(image.path);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(source == ImageSource.camera 
                  ? 'Photo captured successfully' 
                  : 'Image selected successfully'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Pallete.errorColor,
          ),
        );
      }
    }
  }

  void _showVideoSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Pallete.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.videocam, color: Pallete.borderHover),
                title: const Text('Record Video', style: TextStyle(color: Pallete.whiteColor)),
                onTap: () {
                  Navigator.pop(context);
                  _handleVideoPick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_library, color: Pallete.borderHover),
                title: const Text('Choose from Gallery', style: TextStyle(color: Pallete.whiteColor)),
                onTap: () {
                  Navigator.pop(context);
                  _handleVideoPick(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleVideoPick(ImageSource source) async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 2),
      );

      if (video != null) {
        // In a real app, you'd upload this to a server and get a URL
        final viewmodel = ref.read(addTweetViewmodelProvider.notifier);
        viewmodel.updateMediaVideo(video.path);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(source == ImageSource.camera 
                  ? 'Video recorded successfully' 
                  : 'Video selected successfully'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick video: $e'),
            backgroundColor: Pallete.errorColor,
          ),
        );
      }
    }
  }

  void _handlePost() async {
    final viewmodel = ref.read(addTweetViewmodelProvider.notifier);
    await viewmodel.postTweet();

    if (mounted) {
      final state = ref.read(addTweetViewmodelProvider);
      
      if (state.isTweetPosted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tweet posted successfully!'),
            backgroundColor: Pallete.greenColor,
            duration: Duration(seconds: 2),
          ),
        );
        // Navigate back
        //Navigator.of(context).pop();
      } else if (state.errorMessage != null) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Pallete.errorColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addTweetViewmodelProvider);
    final viewmodel = ref.read(addTweetViewmodelProvider.notifier);
    final responsive = context.responsive;
    final imageHeight = responsive.getTweetImageHeight();
    final horizontalPadding = responsive.padding(16);

    return Scaffold(
      backgroundColor: Pallete.blackColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with cancel and post buttons
            AddTweetHeaderWidget(
              onCancel: () => Navigator.of(context).pop(),
              onPost: _handlePost,
              canPost: viewmodel.canPostTweet(),
              isLoading: state.isLoading,
            ),
            
            SizedBox(height: responsive.padding(10)),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tweet body input
                      AddTweetBodyInputWidget(
                        controller: _bodyController,
                        onChanged: (value) {
                          viewmodel.updateBody(value);
                        },
                        maxLength: AddTweetViewmodel.maxBodyLength,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Media preview (if any)
                      if (state.mediaPicPath != null) ...[
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(state.mediaPicPath!),
                                width: double.infinity,
                                height: imageHeight,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: double.infinity,
                                    height: imageHeight,
                                    color: Pallete.cardColor,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Pallete.greyColor,
                                      size: 50,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () => viewmodel.removeMediaPic(),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Pallete.blackColor.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Pallete.whiteColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Video preview (if any)
                      if (state.mediaVideoPath != null) ...[
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: imageHeight,
                              decoration: BoxDecoration(
                                color: Pallete.cardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.video_library,
                                      color: Pallete.whiteColor,
                                      size: 50,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Video selected',
                                      style: TextStyle(
                                        color: Pallete.whiteColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () => viewmodel.removeMediaVideo(),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Pallete.blackColor.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Pallete.whiteColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      // Character count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${viewmodel.getRemainingCharacters()}',
                            style: TextStyle(
                              color: viewmodel.getRemainingCharacters() < 0
                                  ? Pallete.errorColor
                                  : viewmodel.getRemainingCharacters() < 20
                                      ? Colors.orange
                                      : Pallete.greyColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Toolbar
            AddTweetToolbarWidget(
              onImagePick: _showImageSourceDialog,
              onGifPick: _showVideoSourceDialog,
              onPollCreate: () {
                // TODO: Implement poll creation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Poll creation not implemented yet'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
