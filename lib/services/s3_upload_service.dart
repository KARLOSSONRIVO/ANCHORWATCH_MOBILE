import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import '../data/models/profile/profile_picture_models.dart';

@lazySingleton
class S3UploadService {
  Future<bool> uploadToS3({
    required File file,
    required GenerateProfileUploadURLResponseModel presignedData,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(presignedData.url),
      );
      request.fields.addAll(
        presignedData.fields.map((key, value) => MapEntry(key, value.toString())),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: presignedData.key.split('/').last,
        ),
      );
      final response = await request.send();
      if (response.statusCode == 204 || response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
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
  bool validateFileSize(File file) {
    const maxSizeInBytes = 5 * 1024 * 1024; // 5MB
    return file.lengthSync() <= maxSizeInBytes;
  }
  bool validateFileType(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    const allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
    return allowedExtensions.contains(extension);
  }
}


