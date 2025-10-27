import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../injection_container.dart';
import '../../blocs/profile/profile.dart';
import '../../blocs/profile_picture/profile_picture.dart';
import '../../routes/app_routes.dart';
import '../../themes/app_theme.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/profile_picture_picker_widget.dart';
import '../../widgets/custom_snackbar.dart';
import 'profile_action_result.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ProfileBloc>()..add(const ProfileLoadRequested()),
        ),
        BlocProvider(
          create: (context) => getIt<ProfilePictureBloc>(),
        ),
      ],
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.getBackgroundColor(context),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) {
          if (state.status == ProfileStatus.navigatingToEditAccount) {
            Navigator.of(context).pushNamed('/edit-account');
          } else if (state.status == ProfileStatus.navigatingToContactSupport) {
            Navigator.of(context).pushNamed('/contact').then((_) {
              if (context.mounted) {
                context.read<ProfileBloc>().add(const ProfileLoadRequested());
              }
            });
          } else if (state.status == ProfileStatus.navigatingToFAQs) {
            Navigator.of(context).pushNamed('/faq').then((_) {
              if (context.mounted) {
                context.read<ProfileBloc>().add(const ProfileLoadRequested());
              }
            });
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return Center(
              child: LoadingWidget(
                size: 48.0,
                color: AppTheme.getTextPrimaryColor(context),
                text: 'Loading Profile...',
              ),
            );
          }

          if (state.status == ProfileStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.error ?? 'An error occurred',
                    style: const TextStyle(
                      color: Colors.red,
                      fontFamily: 'Inter',
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileBloc>().add(const ProfileLoadRequested());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      BlocListener<ProfilePictureBloc, ProfilePictureState>(
                        listener: (context, profilePictureState) {
                          if (profilePictureState.status == ProfilePictureStatus.confirmed) {
                            context.read<ProfileBloc>().add(const ProfileLoadRequested());
                          }
                        },
                        child: ProfilePicturePickerWidget(
                          currentImageUrl: state.avatar,
                          size: 80.0,
                          onImageChanged: () {
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.name,
                        style: TextStyle(
                          color: AppTheme.getTextPrimaryColor(context),
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.email,
                        style: TextStyle(
                          color: AppTheme.getTextSecondaryColor(context),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Account',
                  style: TextStyle(
                    color: AppTheme.getTextPrimaryColor(context),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.getCardBackgroundColor(context),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.getBorderColor(context),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _EditAccountDropdownItem(),
                      _ProfileMenuItemInCard(
                        title: 'Contact Support',
                        onTap: () {
                          context.read<ProfileBloc>().add(const ProfileNavigateToContactSupport());
                        },
                        showDivider: true,
                      ),
                      _ProfileMenuItemInCard(
                        title: 'FAQs',
                        onTap: () {
                          context.read<ProfileBloc>().add(const ProfileNavigateToFAQs());
                        },
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
class _ProfileMenuItemInCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  const _ProfileMenuItemInCard({
    required this.title,
    required this.onTap,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: AppTheme.getTextPrimaryColor(context),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.getTextSecondaryColor(context),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Container(
            height: 1,
            color: AppTheme.getBorderColor(context),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
      ],
    );
  }
}
class _EditAccountDropdownItem extends StatefulWidget {
  @override
  _EditAccountDropdownItemState createState() => _EditAccountDropdownItemState();
}

class _EditAccountDropdownItemState extends State<_EditAccountDropdownItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Edit Account',
                    style: TextStyle(
                      color: AppTheme.getTextPrimaryColor(context),
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: _isExpanded ? 0.25 : 0.0,
                  child: Icon(
                    Icons.chevron_right,
                    color: AppTheme.getTextSecondaryColor(context),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 1,
                color: AppTheme.getBorderColor(context),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              _DropdownOption(
                title: 'Change Username',
                onTap: () async {
                  setState(() {
                    _isExpanded = false;
                  });
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.changeUsername,
                  );
                  if (context.mounted && result is ProfileActionResult) {
                    _handleProfileActionResult(result);
                  }
                },
              ),
              _DropdownOption(
                title: 'Change Password',
                onTap: () async {
                  setState(() {
                    _isExpanded = false;
                  });
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.changePassword,
                  );
                  if (context.mounted && result is ProfileActionResult) {
                    _handleProfileActionResult(result);
                  }
                },
              ),
              _DropdownOption(
                title: 'Change Email',
                onTap: () async {
                  setState(() {
                    _isExpanded = false;
                  });
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.requestChangeEmail,
                  );
                  if (context.mounted && result is ProfileActionResult) {
                    _handleProfileActionResult(result);
                  }
                },
                showDivider: false,
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          color: AppTheme.getBorderColor(context),
          margin: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ],
    );
  }

  void _handleProfileActionResult(ProfileActionResult result) {
    if (!mounted) {
      return;
    }

    if (result.isSuccess) {
      SnackBarHelper.showSuccess(
        context,
        result.message,
        duration: const Duration(milliseconds: 1500),
      );

      if (result.hasProfileUpdates) {
        context.read<ProfileBloc>().add(
          ProfileUpdateRequested(
            name: result.updatedName,
            email: result.updatedEmail,
          ),
        );
      }
    } else {
      SnackBarHelper.showError(
        context,
        result.message,
        duration: const Duration(milliseconds: 1600),
      );
    }
  }
}

class _DropdownOption extends StatelessWidget {
  final String title;
  final Future<void> Function()? onTap;
  final bool showDivider;

  const _DropdownOption({
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap == null
              ? null
              : () {
                  onTap!();
                },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppTheme.getTextSecondaryColor(context),
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.getTextSecondaryColor(context),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Container(
            height: 1,
            color: AppTheme.getBorderColor(context),
            margin: const EdgeInsets.symmetric(horizontal: 32),
          ),
      ],
    );
  }
}
