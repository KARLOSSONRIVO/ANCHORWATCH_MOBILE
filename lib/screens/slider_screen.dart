import 'package:flutter/material.dart';

/// Slider screen for onboarding/intro slides
class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  final PageController _pageController = PageController();
  
  final List<SlideData> _slides = [
    SlideData(
      title: 'Welcome to AnchorWatch',
      subtitle: 'Monitor your anchor position with precision and confidence.',
      imagePath: 'assets/images/slide1.png',
    ),
    SlideData(
      title: 'Real-time Monitoring',
      subtitle: 'Get instant alerts when your boat drifts beyond safe anchoring zones.',
      imagePath: 'assets/images/slide2.png',
    ),
    SlideData(
      title: 'Advanced Analytics',
      subtitle: 'Track weather conditions, tide patterns, and historical anchor data.',
      imagePath: 'assets/images/slide3.png',
    ),
    SlideData(
      title: 'Stay Connected',
      subtitle: 'Peace of mind with 24/7 monitoring and emergency notifications.',
      imagePath: 'assets/images/slide4.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToSignup() {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  void _onPageChanged(int page) {
    // Page changed, can be used for analytics or other purposes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      return _SliderContent(
                        slide: _slides[index],
                        pageController: _pageController,
                        totalSlides: _slides.length,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _navigateToLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: TextButton(
                      onPressed: _navigateToSignup,
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Create an account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderContent extends StatelessWidget {
  final SlideData slide;
  final PageController pageController;
  final int totalSlides;

  const _SliderContent({
    required this.slide,
    required this.pageController,
    required this.totalSlides,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Stack(
          children: [
            // Background image with opacity
            Positioned.fill(
              child: Opacity(
                opacity: 0.25,
                child: Image.asset(
                  'assets/images/SlidePageBackground.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    );
                  },
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Slide image
                Image.asset(
                  slide.imagePath,
                  width: 200,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E5CC).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.anchor,
                        size: 80,
                        color: Color(0xFF00E5CC),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    slide.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.headlineLarge?.color,
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    slide.subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                      height: 1.5,
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                
                // Page indicator
                _DotIndicator(
                  controller: pageController,
                  count: totalSlides,
                ),
              ],
            ),
            
            // Logo in top left
            Positioned(
              top: 16,
              left: 24,
              child: ColorFiltered(
                colorFilter: Theme.of(context).brightness == Brightness.light
                    ? const ColorFilter.mode(Colors.black, BlendMode.srcIn)
                    : const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                child: Image.asset(
                  'assets/images/LOGO.png',
                  width: 80,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E5CC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'AW',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data model for slide content
class SlideData {
  final String title;
  final String subtitle;
  final String imagePath;

  SlideData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}

/// Simple dot indicator widget
class _DotIndicator extends StatelessWidget {
  final PageController controller;
  final int count;

  const _DotIndicator({
    required this.controller,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double page = controller.hasClients ? (controller.page ?? 0) : 0;
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (index) {
            double selectedness = Curves.easeOut.transform(
              (1.0 - (page - index).abs()).clamp(0.0, 1.0),
            );
            double zoom = 1.0 + (selectedness * 0.3);
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 8 * zoom,
                height: 8,
                decoration: BoxDecoration(
                  color: index == page.round()
                      ? const Color(0xFF00E5CC)
                      : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.3) ?? Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}