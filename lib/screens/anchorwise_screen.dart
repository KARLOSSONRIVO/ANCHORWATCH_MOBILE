import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

/// AnchorWise page content with dark theme (no navigation)
class AnchorWiseScreen extends StatefulWidget {
  const AnchorWiseScreen({super.key});

  @override
  State<AnchorWiseScreen> createState() => _AnchorWiseScreenState();
}

class _AnchorWiseScreenState extends State<AnchorWiseScreen> {
  final TextEditingController _questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        foregroundColor: Colors.white,
        title: const Text(
          'AnchorWise',
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.history, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share, color: Colors.white),
          ),
        ],
      ),
      drawer: const NavigationDrawerWidget(),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // AI Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.psychology,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Title
                    const Text(
                      'Your AI companion for stablecoin\nand macroeconomic insights.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Subtitle
                    const Text(
                      'Ask questions, explore trends, and get\ninstant summaries powered by intelligent\nfinancial analysis.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Question input at bottom
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _questionController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Ask a question...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Inter',
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () {
                      SnackBarHelper.showInfo(context, 'AI response coming soon!');
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }
}