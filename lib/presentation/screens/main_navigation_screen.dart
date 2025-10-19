import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_state.dart';
import '../blocs/anchorwise/anchorwise.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/navigation_drawer_widget.dart';
import '../widgets/conversation_history_dialog.dart';
import '../../services/navigation_service.dart';
import '../themes/app_theme.dart';
import 'dashboard_screen.dart';
import 'discover/discover_screen.dart';
import 'anchorwise_screen.dart';
import 'alerts_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'AnchorWatch';
      case 1:
        return 'Discover';
      case 2:
        return 'AnchorWise';
      case 3:
        return 'Alerts';
      case 4:
        return 'Profile';
      default:
        return 'Dashboard';
    }
  }

  Widget _buildAnchorWiseTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'AnchorWise',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  List<Widget> _getAppBarActions(BuildContext context, int index) {
    switch (index) {
      case 2: // AnchorWise screen
        return [
          IconButton(
            onPressed: () {
              final anchorWiseBloc = BlocProvider.of<AnchorWiseBloc>(context);
              anchorWiseBloc.add(const AnchorWiseLoadConversations());
              showDialog(
                context: context,
                builder: (dialogContext) => BlocProvider.value(
                  value: anchorWiseBloc,
                  child: const ConversationHistoryDialog(),
                ),
              );
            },
            icon: const Icon(Icons.history),
            tooltip: 'History',
          ),
          IconButton(
            onPressed: () {
              final anchorWiseBloc = BlocProvider.of<AnchorWiseBloc>(context);
              anchorWiseBloc.add(const AnchorWiseCreateNewConversation());
            },
            icon: const Icon(Icons.add_comment_outlined),
            tooltip: 'New Chat',
          ),
        ];
      default: // All other screens
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationBloc, NavigationState>(
      listener: (context, state) {
        if (state is NavigationPageSelected) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NavigationService.forceCloseDrawer();
          });
        }
      },
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          int currentIndex = 0;
          bool canGoBack = false;

          if (state is NavigationPageSelected) {
            currentIndex = state.currentIndex;
            canGoBack = state.canGoBack;
          }

          return PopScope(
            canPop:
                !canGoBack, // Prevent system back button if we have navigation stack
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop && canGoBack) {
                NavigationService.goBack(context);
              }
            },
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: AppTheme.getBackgroundColor(context),
              appBar: AppBar(
                title: currentIndex == 2
                    ? _buildAnchorWiseTitle()
                    : Text(
                        _getPageTitle(currentIndex),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                actions: _getAppBarActions(context, currentIndex),
              ),
              drawer: const NavigationDrawerWidget(),
              body: IndexedStack(
                index: currentIndex,
                children: const [
                  DashboardScreen(),
                  DiscoverScreen(),
                  AnchorWiseScreen(),
                  AlertsScreen(),
                  ProfileScreen(),
                ],
              ),
              bottomNavigationBar: BottomNavigationWidget(
                currentIndex: currentIndex,
                onTap: (index) {
                  NavigationService.navigateToIndex(context, index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
