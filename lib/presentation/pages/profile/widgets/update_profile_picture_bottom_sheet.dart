import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_up/presentation/bloc/account/account_bloc.dart';

class UpdateProfilePictureBottomSheet extends StatelessWidget {
  final String imageUrl;

  const UpdateProfilePictureBottomSheet({super.key, required this.imageUrl});

  void _selectImage(BuildContext context, ImageSource imageSource) async {
    final ImagePicker imagePicker = ImagePicker();

    final XFile? file = await imagePicker.pickImage(
      source: imageSource,
    );

    if (file == null) return;

    if (context.mounted) {
      context.read<AccountBloc>().add(
        UpdateMyProfilePictureEvent(imagePath: File(file.path)),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Update Profile Picture",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 40),

          ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 160,
              height: 160,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),

          SizedBox(height: 30),

          Material(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Take Photo"),
                    Icon(Icons.photo_camera_outlined),
                  ],
                ),
              ),
              onTap: () => _selectImage(context, ImageSource.camera),
            ),
          ),

          SizedBox(height: 5),

          Material(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Choose Photo"), Icon(Icons.photo_outlined)],
                ),
              ),
              onTap: () => _selectImage(context, ImageSource.gallery),
            ),
          ),
        ],
      ),
    );
  }
}
