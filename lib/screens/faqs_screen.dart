import 'package:flutter/material.dart';

/// FAQ item data model
class FAQItem {
  final String question;
  final String answer;
  bool expanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.expanded = false,
  });
}

/// FAQ category data model
class FAQCategory {
  final String title;
  final List<FAQItem> items;

  FAQCategory({
    required this.title,
    required this.items,
  });
}

/// FAQs screen displaying frequently asked questions
class FAQsScreen extends StatefulWidget {
  const FAQsScreen({super.key});

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen> {
  late List<FAQCategory> _categories;

  @override
  void initState() {
    super.initState();
    _initializeCategories();
  }

  void _initializeCategories() {
    _categories = [
      FAQCategory(
        title: 'General Questions',
        items: [
          FAQItem(
            question: 'What is AnchorWatch?',
            answer: 'AnchorWatch is a comprehensive maritime anchor monitoring system that helps boat owners and sailors track their anchor position and ensure their vessel stays securely anchored.',
          ),
          FAQItem(
            question: 'How does anchor monitoring work?',
            answer: 'Our system uses GPS technology and advanced algorithms to continuously monitor your anchor position. If your boat drifts beyond a safe zone, you\'ll receive immediate alerts.',
          ),
          FAQItem(
            question: 'Is AnchorWatch available worldwide?',
            answer: 'Yes, AnchorWatch works globally wherever you have internet connectivity and GPS signal. Our service covers all major maritime regions.',
          ),
        ],
      ),
      FAQCategory(
        title: 'Account & Subscription',
        items: [
          FAQItem(
            question: 'How do I create an account?',
            answer: 'Simply tap "Sign Up" on the login screen, enter your email, create a password, and verify your email address. Your account will be ready to use immediately.',
          ),
          FAQItem(
            question: 'What subscription plans are available?',
            answer: 'We offer Basic (free), Premium, and Professional plans. Each plan includes different features and monitoring capabilities to suit your needs.',
          ),
          FAQItem(
            question: 'Can I cancel my subscription anytime?',
            answer: 'Yes, you can cancel your subscription at any time from your account settings. Your subscription will remain active until the end of the current billing period.',
          ),
        ],
      ),
      FAQCategory(
        title: 'Technical Support',
        items: [
          FAQItem(
            question: 'Why am I not receiving alerts?',
            answer: 'Check your notification settings, ensure the app has permission to send notifications, and verify your internet connection. Contact support if the issue persists.',
          ),
          FAQItem(
            question: 'How accurate is the GPS tracking?',
            answer: 'Our GPS tracking is accurate to within 3-5 meters under normal conditions. Accuracy may vary based on weather conditions and GPS signal strength.',
          ),
          FAQItem(
            question: 'What should I do if the app crashes?',
            answer: 'Try restarting the app and your device. If the problem continues, please contact our support team with details about when the crash occurred.',
          ),
        ],
      ),
    ];
  }

  void _toggleItem(int categoryIndex, int itemIndex) {
    setState(() {
      _categories[categoryIndex].items[itemIndex].expanded = 
          !_categories[categoryIndex].items[itemIndex].expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF8F8F8) // Softer off-white for light mode
          : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFF8F8F8) // Softer off-white for light mode
            : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: Text(
          'FAQs',
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineMedium?.color,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: _categories.length,
        itemBuilder: (context, categoryIndex) {
          final category = _categories[categoryIndex];
          return _FAQCategorySection(
            title: category.title,
            items: category.items,
            onToggle: (itemIndex) => _toggleItem(categoryIndex, itemIndex),
          );
        },
      ),
    );
  }
}

class _FAQCategorySection extends StatelessWidget {
  const _FAQCategorySection({
    required this.title,
    required this.items,
    required this.onToggle,
  });

  final String title;
  final List<FAQItem> items;
  final void Function(int index) onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFF8F8F8) // Softer off-white for light mode
              : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.headlineMedium?.color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              fontFamily: 'Inter',
            ),
          ),
        ),
        ...List.generate(items.length, (itemIndex) {
          final item = items[itemIndex];
          return Column(
            children: [
              Material(
                color: Theme.of(context).brightness == Brightness.light
                    ? const Color(0xFFF8F8F8) // Softer off-white for light mode
                    : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
                child: InkWell(
                  onTap: () => onToggle(itemIndex),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Theme.of(context).dividerColor, width: 0.6),
                        bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.6),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.question,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              fontSize: 15,
                              height: 1.35,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        AnimatedRotation(
                          turns: item.expanded ? 0.25 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.add,
                            color: Theme.of(context).iconTheme.color,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  color: Theme.of(context).cardColor,
                  child: Text(
                    item.answer,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.5,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                crossFadeState: item.expanded 
                    ? CrossFadeState.showSecond 
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 220),
              ),
            ],
          );
        }),
      ],
    );
  }
}