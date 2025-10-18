
import 'package:flutter/material.dart';
import 'macro_trends_screen.dart';
import 'stablecoin_screen.dart';
import 'articles_screen.dart';
import '../../themes/app_theme.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.getBackgroundColor(context),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: _buildTabButtons(context),
            ),
          ),
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButtons(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _tabButton('Stablecoins', isSelected: selectedTab == 0, onTap: () {
            setState(() {
              selectedTab = 0;
            });
          }, context: context),
          const SizedBox(width: 8),
          _tabButton('Macro Trends', isSelected: selectedTab == 1, onTap: () {
            setState(() {
              selectedTab = 1;
            });
          }, context: context),
          const SizedBox(width: 8),
          _tabButton('Articles', isSelected: selectedTab == 2, onTap: () {
            setState(() {
              selectedTab = 2;
            });
          }, context: context),
        ],
      ),
    );
  }

  Widget _tabButton(String text, {required bool isSelected, required VoidCallback onTap, required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(minWidth: 100),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00D4AA) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? const Color(0xFF00D4AA) : Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black : Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0:
        return const StablecoinView();
      case 1:
        return const MacroTrendsView();
      case 2:
        return const ArticlesView();
      default:
        return const SizedBox.shrink();
    }
  }
}