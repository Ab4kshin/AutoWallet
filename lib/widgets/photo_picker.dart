import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auto_wallet2/services/image_service.dart';
import 'package:auto_wallet2/utils/app_theme.dart';
import 'package:auto_wallet2/l10n/l10n.dart';

class PhotoPicker extends StatelessWidget {
  final String? currentPhotoPath;
  final Function(String) onPhotoSelected;
  final double size;
  final String buttonText;
  final IconData icon;
  
  const PhotoPicker({
    Key? key,
    this.currentPhotoPath,
    required this.onPhotoSelected,
    this.size = 120,
    this.buttonText = '',
    this.icon = Icons.camera_alt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showImageSourceDialog(context),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              image: currentPhotoPath != null && File(currentPhotoPath!).existsSync()
                  ? DecorationImage(
                      image: FileImage(File(currentPhotoPath!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: currentPhotoPath == null || !File(currentPhotoPath!).existsSync()
                ? Icon(
                    icon,
                    size: size * 0.5,
                    color: Colors.grey.shade600,
                  )
                : null,
          ),
        ),
        if (buttonText.isNotEmpty) ...[
          const SizedBox(height: AppTheme.paddingMedium),
          TextButton(
            onPressed: () => _showImageSourceDialog(context),
            child: Text(buttonText),
          ),
        ],
      ],
    );
  }

  Future<void> _showImageSourceDialog(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.borderRadiusLarge),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(context.l10n.selectPhoto),
                  onTap: () async {
                    Navigator.pop(context);
                    final String? imagePath = await ImageService.pickImageFromGallery();
                    if (imagePath != null) {
                      onPhotoSelected(imagePath);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take Photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    final String? imagePath = await ImageService.takePhoto();
                    if (imagePath != null) {
                      onPhotoSelected(imagePath);
                    }
                  },
                ),
                if (currentPhotoPath != null)
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                    onTap: () async {
                      Navigator.pop(context);
                      if (currentPhotoPath != null) {
                        await ImageService.deleteImage(currentPhotoPath!);
                        onPhotoSelected('');
                      }
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
} 