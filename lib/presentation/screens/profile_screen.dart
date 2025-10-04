import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/widgets.dart';
import '../blocs/profile/profile.dart';
import '../../services/navigation_service.dart';

/// Profile page content with dark theme using BLoC architecture
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(const ProfileLoadRequested()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: DrawerKeys.profileKey,
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        foregroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const NavigationDrawerWidget(),
      body: BlocConsumer<ProfileBloc, ProfileState>(
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
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
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
                          color: const Color(0xFF333333),
                          border: Border.all(
                            color: const Color(0xFF666666),
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Email
                      Text(
                        state.email,
                        style: const TextStyle(
                          color: Color(0xFF999999),
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
                const Text(
                  'Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Menu Items in Single Card
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF333333),
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
      color: const Color(0xFF666666),
      child: const Icon(
        Icons.person,
        color: Colors.white,
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF666666),
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
            color: const Color(0xFF333333),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
      ],
    );
  }
}