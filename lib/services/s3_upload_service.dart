import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import '../data/models/profile/profile_picture_models.dart';

@lazySingleton
class S3UploadService {
  /// Upload file directly to S3 using presigned URL
  Future<bool> uploadToS3({
    required File file,
    required GenerateProfileUploadURLResponseModel presignedData,
  }) async {
    try {
      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(presignedData.url),
      );

      // Add all the fields from presigned data
      request.fields.addAll(
        presignedData.fields.map((key, value) => MapEntry(key, value.toString())),
      );

      // Add the file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: presignedData.key.split('/').last,
        ),
      );

      // Send the request
      final response = await request.send();

      // Check if upload was successful
      if (response.statusCode == 204 || response.statusCode == 200) {
        return true;
      } else {
        print('S3 upload failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('S3 upload error: $e');
      return false;
    }
  }

  /// Get content type from file extension
  String getContentTypeFromFile(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg'; // Default fallback
    }
  }

  /// Validate file size (max 5MB)
  bool validateFileSize(File file) {
    const maxSizeInBytes = 5 * 1024 * 1024; // 5MB
    return file.lengthSync() <= maxSizeInBytes;
  }

  /// Validate file type
  bool validateFileType(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    const allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
    return allowedExtensions.contains(extension);
  }
}
