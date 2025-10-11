import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart';
import '../blocs/profile_picture/profile_picture.dart';
import '../themes/app_theme.dart';

/// Widget for picking and uploading profile pictures
class ProfilePicturePickerWidget extends StatelessWidget {
  final String? currentImageUrl;
  final double size;
  final VoidCallback? onImageChanged;

  const ProfilePicturePickerWidget({
    super.key,
    this.currentImageUrl,
    this.size = 80.0,
    this.onImageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfilePictureBloc>(),
      child: _ProfilePicturePickerView(
        currentImageUrl: currentImageUrl,
        size: size,
        onImageChanged: onImageChanged,
      ),
    );
  }
}

class _ProfilePicturePickerView extends StatelessWidget {
  final String? currentImageUrl;
  final double size;
  final VoidCallback? onImageChanged;

  const _ProfilePicturePickerView({
    required this.currentImageUrl,
    required this.size,
    this.onImageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfilePictureBloc, ProfilePictureState>(
      listener: (context, state) {
        if (state.status == ProfilePictureStatus.imagePicked && state.selectedImage != null) {
          // Automatically start upload when image is picked
          context.read<ProfilePictureBloc>().add(
            ProfilePictureUploadRequested(imageFile: state.selectedImage!),
          );
        } else if (state.status == ProfilePictureStatus.confirmed) {
          // Notify parent that image has changed
          onImageChanged?.call();
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.status == ProfilePictureStatus.error) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            // Profile picture container
            GestureDetector(
              onTap: () => _showImagePickerOptions(context),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.getSurfaceColor(context),
                  border: Border.all(
                    color: AppTheme.getBorderColor(context),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: _buildImageContent(context, state),
                ),
              ),
            ),
            
            // Loading overlay
            if (state.status == ProfilePictureStatus.uploading ||
                state.status == ProfilePictureStatus.confirming)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: size * 0.4,
                          height: size * 0.4,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.getTextPrimaryColor(context),
                            ),
                          ),
                        ),
                        if (state.status == ProfilePictureStatus.uploading)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${(state.uploadProgress * 100).toInt()}%',
                              style: TextStyle(
                                color: AppTheme.getTextPrimaryColor(context),
                                fontSize: 10,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            
            // Camera icon overlay
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryColor,
                  border: Border.all(
                    color: AppTheme.getBackgroundColor(context),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: AppTheme.getTextPrimaryColor(context),
                  size: size * 0.15,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageContent(BuildContext context, ProfilePictureState state) {
    // Show selected image if available
    if (state.selectedImage != null) {
      return Image.file(
        state.selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    
    // Show current profile image
    if (currentImageUrl != null && currentImageUrl!.isNotEmpty) {
      return Image.network(
        currentImageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar(context);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.getTextPrimaryColor(context),
              ),
            ),
          );
        },
      );
    }
    
    // Show default avatar
    return _buildDefaultAvatar(context);
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.getBorderColor(context),
      child: Icon(
        Icons.person,
        color: AppTheme.getTextPrimaryColor(context),
        size: size * 0.5,
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    final profilePictureBloc = context.read<ProfilePictureBloc>();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.getCardBackgroundColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.getBorderColor(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              
              Text(
                'Change Profile Picture',
                style: TextStyle(
                  color: AppTheme.getTextPrimaryColor(context),
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              
              // Gallery option
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: AppTheme.getTextPrimaryColor(context),
                ),
                title: Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    color: AppTheme.getTextPrimaryColor(context),
                    fontFamily: 'Inter',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  profilePictureBloc.add(
                    const ProfilePicturePickImageRequested(fromCamera: false),
                  );
                },
              ),
              
              // Camera option
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: AppTheme.getTextPrimaryColor(context),
                ),
                title: Text(
                  'Take Photo',
                  style: TextStyle(
                    color: AppTheme.getTextPrimaryColor(context),
                    fontFamily: 'Inter',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  profilePictureBloc.add(
                    const ProfilePicturePickImageRequested(fromCamera: true),
                  );
                },
              ),
              
              // Remove option (only if there's a current image)
              if (currentImageUrl != null && currentImageUrl!.isNotEmpty)
                ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Remove Picture',
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    profilePictureBloc.add(
                      const ProfilePictureRemoveRequested(),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
