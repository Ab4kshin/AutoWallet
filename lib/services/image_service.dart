import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();
  
  // Pick an image from gallery
  static Future<String?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (pickedFile == null) return null;
      
      // Save image to app directory and return path
      return await _saveImageToLocal(pickedFile);
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }
  
  // Take a photo using camera
  static Future<String?> takePhoto() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (pickedFile == null) return null;
      
      // Save image to app directory and return path
      return await _saveImageToLocal(pickedFile);
    } catch (e) {
      debugPrint('Error taking photo: $e');
      return null;
    }
  }
  
  // Save image to local storage
  static Future<String> _saveImageToLocal(XFile file) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imagesDir = path.join(appDir.path, 'images');
    
    // Create images directory if it doesn't exist
    await Directory(imagesDir).create(recursive: true);
    
    // Generate a unique filename
    final String fileName = '${const Uuid().v4()}${path.extension(file.path)}';
    final String localPath = path.join(imagesDir, fileName);
    
    // Copy file to app directory
    final File localFile = File(localPath);
    await localFile.writeAsBytes(await file.readAsBytes());
    
    return localPath;
  }
  
  // Delete image from local storage
  static Future<bool> deleteImage(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }
} 