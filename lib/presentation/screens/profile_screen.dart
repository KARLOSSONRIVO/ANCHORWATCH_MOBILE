import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart';
import '../blocs/profile/profile.dart';
import '../themes/app_theme.dart';

/// Profile page content with dark theme using BLoC architecture
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileBloc>()..add(const ProfileLoadRequested()),
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
        listener: (context, state) {
          // Handle navigation based on state
          if (state.status == ProfileStatus.navigatingToEditAccount) {
            // Navigate to edit account screen
            Navigator.of(context).pushNamed('/edit-account');
          } else if (state.status == ProfileStatus.navigatingToContactSupport) {
            // Navigate to contact support screen
            Navigator.of(context).pushNamed('/contact');
          } else if (state.status == ProfileStatus.navigatingToFAQs) {
            // Navigate to FAQs screen
            Navigator.of(context).pushNamed('/faq');
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.getTextPrimaryColor(context)),
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
                // Profile Header Section
                Center(
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.getSurfaceColor(context),
                          border: Border.all(
                            color: AppTheme.getBorderColor(context),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: state.avatar != null
                              ? Image.network(
                                  state.avatar!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const _DefaultAvatar();
                                  },
                                )
                              : const _DefaultAvatar(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Name
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
                      
                      // Email
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
                
                // Account Section
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
                
                // Menu Items in Single Card
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
                      _ProfileMenuItemInCard(
                        title: 'Edit Account',
                        onTap: () {
                          context.read<ProfileBloc>().add(const ProfileNavigateToEditAccount());
                        },
                        showDivider: true,
                      ),
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

/// Default avatar widget when no avatar is provided
class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.getBorderColor(context),
      child: Icon(
        Icons.person,
        color: AppTheme.getTextPrimaryColor(context),
        size: 40,
      ),
    );
  }
}

/// Profile menu item widget for use within a card
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