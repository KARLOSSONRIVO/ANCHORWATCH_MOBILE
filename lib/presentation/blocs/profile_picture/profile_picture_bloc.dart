import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../data/datasources/remote/profile_remote_datasource.dart';
import '../../../data/models/profile/profile_picture_models.dart';
import '../../../services/s3_upload_service.dart';
import 'profile_picture_event.dart';
import 'profile_picture_state.dart';

/// BLoC for managing profile picture uploads
@injectable
class ProfilePictureBloc extends Bloc<ProfilePictureEvent, ProfilePictureState> {
  final ProfileRemoteDataSource _profileRemoteDataSource;
  final S3UploadService _s3UploadService;
  final ImagePicker _imagePicker;

  ProfilePictureBloc(
    this._profileRemoteDataSource,
    this._s3UploadService,
  ) : _imagePicker = ImagePicker(),
        super(const ProfilePictureState()) {
    on<ProfilePicturePickImageRequested>(_onPickImageRequested);
    on<ProfilePictureUploadRequested>(_onUploadRequested);
    on<ProfilePictureConfirmRequested>(_onConfirmRequested);
    on<ProfilePictureRemoveRequested>(_onRemoveRequested);
    on<ProfilePictureResetRequested>(_onResetRequested);
  }

  /// Pick image from gallery or camera
  Future<void> _onPickImageRequested(
    ProfilePicturePickImageRequested event,
    Emitter<ProfilePictureState> emit,
  ) async {
    emit(state.copyWith(status: ProfilePictureStatus.pickingImage));

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: event.fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);

        // Validate file
        if (!_s3UploadService.validateFileType(imageFile)) {
          emit(state.copyWith(
            status: ProfilePictureStatus.error,
            error: 'Invalid file type. Please select a JPEG, PNG, or WebP image.',
          ));
          return;
        }

        if (!_s3UploadService.validateFileSize(imageFile)) {
          emit(state.copyWith(
            status: ProfilePictureStatus.error,
            error: 'File too large. Please select an image smaller than 5MB.',
          ));
          return;
        }

        emit(state.copyWith(
          status: ProfilePictureStatus.imagePicked,
          selectedImage: imageFile,
          error: null,
        ));
      } else {
        emit(state.copyWith(
          status: ProfilePictureStatus.initial,
          error: null,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProfilePictureStatus.error,
        error: 'Failed to pick image: $e',
      ));
    }
  }

  /// Upload image to S3
  Future<void> _onUploadRequested(
    ProfilePictureUploadRequested event,
    Emitter<ProfilePictureState> emit,
  ) async {
    emit(state.copyWith(
      status: ProfilePictureStatus.uploading,
      uploadProgress: 0.0,
    ));

    try {
      // Get content type
      final contentType = _s3UploadService.getContentTypeFromFile(event.imageFile);

      // Generate presigned URL
      final presignedResponse = await _profileRemoteDataSource.generateProfileUploadURL(
        GenerateProfileUploadURLRequestModel(contentType: contentType),
      );

      emit(state.copyWith(uploadProgress: 0.3));

      // Upload to S3
      final uploadSuccess = await _s3UploadService.uploadToS3(
        file: event.imageFile,
        presignedData: presignedResponse,
      );

      if (uploadSuccess) {
        emit(state.copyWith(
          status: ProfilePictureStatus.uploadSuccess,
          uploadProgress: 1.0,
        ));

        // Automatically confirm the upload
        add(ProfilePictureConfirmRequested(s3Key: presignedResponse.key));
      } else {
        emit(state.copyWith(
          status: ProfilePictureStatus.error,
          error: 'Failed to upload image to S3',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProfilePictureStatus.error,
        error: 'Upload failed: $e',
      ));
    }
  }

  /// Confirm the uploaded image
  Future<void> _onConfirmRequested(
    ProfilePictureConfirmRequested event,
    Emitter<ProfilePictureState> emit,
  ) async {
    emit(state.copyWith(status: ProfilePictureStatus.confirming));

    try {
      final confirmResponse = await _profileRemoteDataSource.confirmProfileImage(
        ConfirmProfileImageRequestModel(key: event.s3Key),
      );

      emit(state.copyWith(
        status: ProfilePictureStatus.confirmed,
        profileImageUrl: confirmResponse.profileImageUrl,
        selectedImage: null, // Clear selected image after successful upload
        uploadProgress: 0.0,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfilePictureStatus.error,
        error: 'Failed to confirm image: $e',
      ));
    }
  }

  /// Remove profile picture
  Future<void> _onRemoveRequested(
    ProfilePictureRemoveRequested event,
    Emitter<ProfilePictureState> emit,
  ) async {
    emit(state.copyWith(status: ProfilePictureStatus.removing));

    try {
      // For now, we'll just clear the local state
      // In a full implementation, you might want to call an API to remove from S3
      emit(state.copyWith(
        status: ProfilePictureStatus.removed,
        profileImageUrl: null,
        selectedImage: null,
        uploadProgress: 0.0,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfilePictureStatus.error,
        error: 'Failed to remove profile picture: $e',
      ));
    }
  }

  /// Reset profile picture state
  void _onResetRequested(
    ProfilePictureResetRequested event,
    Emitter<ProfilePictureState> emit,
  ) {
    emit(const ProfilePictureState());
  }
}
