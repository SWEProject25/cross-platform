import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/responsive_utils.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/widgets/app_user_avatar.dart';
import 'package:lam7a/features/add_tweet/ui/viewmodel/add_tweet_viewmodel.dart';
import 'package:lam7a/features/add_tweet/ui/viewmodel/mention_suggestions_viewmodel.dart';
import 'package:lam7a/features/add_tweet/ui/widgets/add_tweet_body_input_widget.dart';
import 'package:lam7a/features/add_tweet/ui/widgets/add_tweet_header_widget.dart';
import 'package:lam7a/features/add_tweet/ui/widgets/add_tweet_toolbar_widget.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_body_summary_widget.dart';
// import 'package:lam7a/features/profile/ui/viewmodel/profile_posts_viewmodel.dart';
//import 'package:lam7a/features/profile/ui/viewmodel/profile_viewmodel.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_likes_pagination.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_replies_pagination.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_posts_pagination.dart';

import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class AddTweetScreen extends ConsumerStatefulWidget {
  final int userId;
  final int? parentPostId;
  final bool isReply;
  final bool isQuote;

  const AddTweetScreen({
    super.key,
    required this.userId,
    this.parentPostId,
    this.isReply = false,
    this.isQuote = false,
  });

  @override
  ConsumerState<AddTweetScreen> createState() => _AddTweetScreenState();
}

class _AddTweetScreenState extends ConsumerState<AddTweetScreen> {
  final TextEditingController _bodyController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final Set<int> _mentionUserIds = {};
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _replyComposerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Reset state when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = ref.read(addTweetViewmodelProvider.notifier);
      vm.reset();
      if (widget.parentPostId != null) {
        if (widget.isReply) {
          vm.setReplyTo(widget.parentPostId!);
        } else if (widget.isQuote) {
          vm.setQuoteTo(widget.parentPostId!);
        }
      }

      // For replies, auto-scroll so the composer is initially in view.
      if (widget.isReply && widget.parentPostId != null) {
        final ctx = _replyComposerKey.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 300),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _bodyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                title:  Text('Take Photo', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  _handleImagePick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Pallete.borderHover),
                title:  Text('Choose from Gallery', style:Theme.of(context).textTheme.bodyLarge),
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

  Widget _buildParentTweetPreview() {
    if (!widget.isReply || widget.parentPostId == null) {
      return const SizedBox.shrink();
    }

    final parentId = widget.parentPostId!.toString();
    final parentAsync = ref.watch(tweetViewModelProvider(parentId));

    return parentAsync.when(
      data: (tweetState) {
        final tweet = tweetState.tweet.value;
        if (tweet == null) {
          return const SizedBox.shrink();
        }
        return OriginalTweetCard(
          tweet: tweet,
          showConnectorLine: true,
          showActions: false,
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildReplyComposer(AddTweetViewmodel viewmodel) {
    final authState = ref.watch(authenticationProvider);
    final user = authState.user;
    final myUsername = user?.username ?? '';
    final myDisplayName = user?.name ?? myUsername;
    final myProfileImage = user?.profileImageUrl;

    String? replyingToHandle;
    if (widget.parentPostId != null) {
      final parentAsync =
          ref.watch(tweetViewModelProvider(widget.parentPostId!.toString()));
      replyingToHandle = parentAsync.maybeWhen(
        data: (tweetState) => tweetState.tweet.maybeWhen(
          data: (tweet) => tweet.username,
          orElse: () => null,
        ),
        orElse: () => null,
      );
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 2,
                  height: 16,
                  color: Colors.grey,
                ),
                AppUserAvatar(
                  radius: 20,
                  imageUrl: myProfileImage,
                  displayName: myDisplayName,
                  username: myUsername,
                ),
              ],
            ),
            const SizedBox(width: 12),
            if (replyingToHandle != null && replyingToHandle!.isNotEmpty)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/profile',
                      arguments: {'username': replyingToHandle},
                    );
                  },
                  child: Text(
                    'Replying to @${replyingToHandle!}',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.blueAccent),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _bodyController,
          onChanged: (value) {
            viewmodel.updateBody(value);
            _handleBodyChanged(value);
          },
          maxLines: null,
          minLines: 5,
          maxLength: AddTweetViewmodel.maxBodyLength,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: "Tweet your reply",
            hintStyle: theme.textTheme.bodyLarge,
            border: InputBorder.none,
            counterText: '',
            filled: false,
            fillColor: Colors.transparent,
          ),
          cursorColor: Pallete.borderHover,
        ),
      ],
    );
  }

  Future<void> _handleImagePick(ImageSource source) async {
    try {
      final hasPermission = await _ensureMediaPermission(source, isVideo: false);
      if (!hasPermission) {
        return;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final file = File(image.path);
        const maxSizeBytes = 100 * 1024 * 1024;
        final fileSize = await file.length();
        if (fileSize > maxSizeBytes) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image is too large. Max size is 100MB'),
                backgroundColor: Pallete.errorColor,
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }

        final viewmodel = ref.read(addTweetViewmodelProvider.notifier);
        final beforeCount = viewmodel.state.mediaPicPaths.length;
        viewmodel.addMediaPic(image.path);
        final afterCount = viewmodel.state.mediaPicPaths.length;

        if (afterCount == beforeCount) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You can attach up to 4 images per tweet'),
                backgroundColor: Pallete.errorColor,
                duration: Duration(seconds: 2),
              ),
            );
          }
          return;
        }
        
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
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                title:  Text('Record Video', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  _handleVideoPick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_library, color: Pallete.borderHover),
                title:  Text('Choose from Gallery', style:Theme.of(context).textTheme.bodyLarge),
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
      final hasPermission = await _ensureMediaPermission(source, isVideo: true);
      if (!hasPermission) {
        return;
      }

      final XFile? video = await _imagePicker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 2),
      );

      if (video != null) {
        final file = File(video.path);
        const maxSizeBytes = 100 * 1024 * 1024;
        final fileSize = await file.length();
        if (fileSize > maxSizeBytes) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Video is too large. Max size is 100MB'),
                backgroundColor: Pallete.errorColor,
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }

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

  Future<bool> _ensureMediaPermission(ImageSource source, {required bool isVideo}) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera permission is required'),
              backgroundColor: Pallete.errorColor,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return false;
      }
      return true;
    }

    PermissionStatus status;
    if (Platform.isAndroid) {
      status = isVideo
          ? await Permission.videos.request()
          : await Permission.photos.request();
    } else if (Platform.isIOS) {
      status = await Permission.photos.request();
    } else {
      // Other platforms (web/desktop) currently don't use runtime permissions here
      return true;
    }

    if (!status.isGranted) {
      if (mounted) {
        final message = status.isPermanentlyDenied
            ? 'Gallery permission is permanently denied. Please enable it in system settings.'
            : 'Gallery permission is required';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Pallete.errorColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }

      return false;
    }

    return true;
  }

  void _handleBodyChanged(String value) {
    final mentionVm = ref.read(mentionSuggestionsViewModelProvider.notifier);

    final cursorPosition = _bodyController.selection.baseOffset;
    if (cursorPosition < 0 || cursorPosition > value.length) {
      mentionVm.clear();
      return;
    }

    final textBeforeCursor = value.substring(0, cursorPosition);
    final atIndex = textBeforeCursor.lastIndexOf('@');

    if (atIndex == -1) {
      mentionVm.clear();
      return;
    }

    if (atIndex > 0) {
      final prevChar = textBeforeCursor[atIndex - 1];
      if (!RegExp(r'\s').hasMatch(prevChar)) {
        mentionVm.clear();
        return;
      }
    }

    final query = textBeforeCursor.substring(atIndex + 1);
    if (query.isEmpty || query.contains(RegExp(r'\s'))) {
      mentionVm.clear();
      return;
    }

    mentionVm.updateQuery(query);
  }

  void _insertMention(String handle, int handleUserId) {
    final text = _bodyController.text;
    final cursorPosition = _bodyController.selection.baseOffset;
    if (cursorPosition < 0 || cursorPosition > text.length) {
      return;
    }

    final textBeforeCursor = text.substring(0, cursorPosition);
    final atIndex = textBeforeCursor.lastIndexOf('@');
    if (atIndex == -1) {
      return;
    }

    final prefix = text.substring(0, atIndex);
    final suffix = text.substring(cursorPosition);
    final newText = '$prefix@$handle $suffix';
    final newCursorPos = (prefix + '@$handle ').length;

    _bodyController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );

    final viewmodel = ref.read(addTweetViewmodelProvider.notifier);
    viewmodel.updateBody(newText);

    // Track mentioned user IDs so we can send them to backend when posting
    // (IDs are added from the suggestions list on tap).
    // Note: _mentionUserIds is managed locally in this screen.
    // The actual IDs are passed to AddTweetViewmodel.postTweet.
    _mentionUserIds.add(handleUserId);

    ref.read(mentionSuggestionsViewModelProvider.notifier).clear();
  }

  Widget _buildMentionSuggestionsPanel() {
    final mentionState = ref.watch(mentionSuggestionsViewModelProvider);

    if (!mentionState.isOpen || mentionState.suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final results = mentionState.suggestions.length > 5
        ? mentionState.suggestions.sublist(0, 5)
        : mentionState.suggestions;

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final contact in results)
              ListTile(
                leading: AppUserAvatar(
                  radius: 20,
                  imageUrl: contact.avatarUrl,
                  displayName: contact.name,
                  username: contact.handle,
                ),
                title: Text(
                  contact.name,
                  style: theme.textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '@${contact.handle}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  _insertMention(contact.handle, contact.id);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _handlePost() async {
    final viewmodel = ref.read(addTweetViewmodelProvider.notifier);
    await viewmodel.postTweet(mentionsIds: _mentionUserIds.toList());

    if (!mounted) {
      return;
    }

    final state = ref.read(addTweetViewmodelProvider);

    if (mounted) {
      if (state.isTweetPosted) {

          try {
                final authState = ref.read(authenticationProvider);
                final myUser = authState.user;

                if (myUser != null && myUser.id != null) {
                  final userId = myUser.id.toString();

                  // Refresh profile lists
                  ref.invalidate(profilePostsProvider(userId));
                  ref.invalidate(profileRepliesProvider(userId));
                  ref.invalidate(profileLikesProvider(userId));
                }
              } catch (_) {}
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tweet posted successfully!'),
            backgroundColor: Pallete.greenColor,
            duration: Duration(seconds: 2),
          ),
        );
        // Navigate back
        Navigator.of(context).pop();
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
    final imageRows = state.mediaPicPaths.length <= 2 ? 1 : 2;
    final mediaGridHeight = imageHeight * imageRows;
    final horizontalPadding = responsive.padding(16);

    final authState = ref.watch(authenticationProvider);
    final currentUser = authState.user;

    // Focus node for the main tweet body input so we can clear mention
    // suggestions when the input loses focus.
    final FocusNode bodyFocusNode = FocusNode();

    bodyFocusNode.addListener(() {
      if (!bodyFocusNode.hasFocus) {
        ref.read(mentionSuggestionsViewModelProvider.notifier).clear();
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header with cancel and post buttons
            AddTweetHeaderWidget(
              onCancel: () => Navigator.of(context).pop(),
              onPost: _handlePost,
              canPost: viewmodel.canPostTweet(),
              isLoading: state.isLoading,
              actionLabel: widget.isReply ? 'Reply' : 'Post',
            ),
            
            SizedBox(height: responsive.padding(10)),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.isReply && widget.parentPostId != null) ...[
                        _buildParentTweetPreview(),
                        const SizedBox(height: 12),
                        KeyedSubtree(
                          key: _replyComposerKey,
                          child: _buildReplyComposer(viewmodel),
                        ),
                      ] else ...[
                        // Tweet body input for new posts / quotes
                        AddTweetBodyInputWidget(
                          controller: _bodyController,
                          focusNode: bodyFocusNode,
                          onChanged: (value) {
                            viewmodel.updateBody(value);
                            _handleBodyChanged(value);
                          },
                          maxLength: AddTweetViewmodel.maxBodyLength,
                          authorProfileImage: currentUser?.profileImageUrl,
                          authorName: currentUser?.name ?? currentUser?.username,
                          username: currentUser?.username,
                        ),
                      ],
                      _buildMentionSuggestionsPanel(),
                      
                      const SizedBox(height: 16),
                      
                      // Media preview (if any)
                      if (state.mediaPicPaths.isNotEmpty) ...[
                        SizedBox(
                          height: mediaGridHeight,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            itemCount: state.mediaPicPaths.length,
                            itemBuilder: (context, index) {
                              final path = state.mediaPicPaths[index];
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(path),
                                      width: double.infinity,
                                      height: imageHeight,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                                      onTap: () => viewmodel
                                          .removeMediaPicAt(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Pallete.blackColor
                                              .withOpacity(0.7),
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
                              );
                            },
                          ),
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
                              child:  Center(
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
                                      style: Theme.of(context).textTheme.bodyLarge
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
                            style:Theme.of(context).textTheme.bodyLarge
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
