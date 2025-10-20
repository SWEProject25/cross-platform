import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:lam7a/features/authentication/ui/widgets/next_button.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicture extends StatefulWidget {
  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File? _selectedImage; // To store selected image
  final ImagePicker _picker = ImagePicker();
    // Picker instance

    // Function to pick image from gallery
    Future<void> _pickImage() async {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          print(_selectedImage);
        });
      }
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Spacer(flex: 1),
              Expanded(
                flex: 9,
                child: const Text(
                  "Pick a profile picture",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Pallete.blackColor,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Spacer(flex: 1),
              Expanded(
                flex: 9,
                child: const Text(
                  "Have a favourite selfie?Upload it now",
                  style: TextStyle(color: Pallete.subtitleText),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Center(
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: Radius.circular(7),
                dashPattern: [10, 5],
                color: Pallete.borderHover,
                strokeWidth: 2,
              ),
              child: InkWell(
                onTap: () {
                  _pickImage();
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: Pallete.borderHover,
                        size: 60,
                      ),
                      Text(
                        "Upload",
                        style: TextStyle(color: Pallete.borderHover),
                      ),
                    ],
                  ),
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
