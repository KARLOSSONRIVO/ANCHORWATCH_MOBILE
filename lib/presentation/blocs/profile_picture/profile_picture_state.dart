import 'package:equatable/equatable.dart';
import 'dart:io';

/// Profile picture status enum
enum ProfilePictureStatus {
  initial,
  pickingImage,
  imagePicked,
  uploading,
  uploadSuccess,
  confirming,
  confirmed,
  error,
  removing,
  removed,
}

/// Profile picture state
class ProfilePictureState extends Equatable {
  const ProfilePictureState({
    this.status = ProfilePictureStatus.initial,
    this.selectedImage,
    this.uploadProgress = 0.0,
    this.profileImageUrl,
    this.error,
  });

  final ProfilePictureStatus status;
  final File? selectedImage;
  final double uploadProgress;
  final String? profileImageUrl;
  final String? error;

  /// Creates a copy with new values
  ProfilePictureState copyWith({
    ProfilePictureStatus? status,
    File? selectedImage,
    double? uploadProgress,
    String? profileImageUrl,
    String? error,
  }) {
    return ProfilePictureState(
      status: status ?? this.status,
      selectedImage: selectedImage ?? this.selectedImage,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedImage,
        uploadProgress,
        profileImageUrl,
        error,
      ];

  @override
  String toString() => 'ProfilePictureState(status: $status, uploadProgress: $uploadProgress, profileImageUrl: $profileImageUrl, error: $error)';
}
