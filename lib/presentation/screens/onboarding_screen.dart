import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/onboarding/onboarding.dart';

/// Onboarding screen with multiple pages showcasing app features
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Sliding pages (after GET STARTED is clicked)
  final List<OnboardingPage> _slidingPages = [
    OnboardingPage(
      title: 'Discover the Pulse of the Digital Economy',
      subtitle: 'AnchorWatch gives you a clear view of global economic trends and stablecoin activities in one intuitive, easy-to-use interface.',
      image: 'assets/images/PAGE1.png',
      backgroundColor: Colors.black,
    ),
    OnboardingPage(
      title: 'Real-Time Data at Your Fingertips',
      subtitle: 'From inflation and interest rates to on-chain USDC flows, AnchorWatch delivers live insights by Apex, Celo, every, Movement and more.',
      image: 'assets/images/PAGE2.png',
      backgroundColor: Colors.black,
    ),
    OnboardingPage(
      title: 'Smarter Analysis with Powered Intelligence',
      subtitle: 'Powered by AI, our platform detects anomalies and provides predictive and Crypto safeguarding, your live Edge to before The market does.',
      image: 'assets/images/PAGE3.png',
      backgroundColor: Colors.black,
    ),
    OnboardingPage(
      title: 'Join a Global Network of Financial Watchers',
      subtitle: 'Professionals, analysts, and crypto enthusiasts around the world rely on AnchorWatch. Connect with the community today with insights you can trust.',
      image: 'assets/images/PAGE4.png',
      backgroundColor: Colors.black,
    ),
  ];

  bool _showSlidingPages = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startSlidingPages() {
    setState(() {
      _showSlidingPages = true;
      _currentPage = 0;
    });
  }

  void _completeOnboarding() {
    context.read<OnboardingBloc>().add(const OnboardingCompleted());
  }

  @override
  Widget build(BuildContext context) {
    // Show landing page first
    if (!_showSlidingPages) {
      return _LandingPageWidget(
        onGetStarted: _startSlidingPages,
        onSkip: _completeOnboarding,
      );
    }

    // Hide status bar for sliding pages as well
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Show sliding pages after GET STARTED is clicked
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black, // Full black background to match SlidePageBackground.png
        ),
        child: Stack(
          children: [
            // Background image positioned at top with blur - extends above safe area
            Positioned(
              top: -MediaQuery.of(context).padding.top, // Extend above status bar
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.5, // Increased height to 50%
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/SlidePageBackground.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                ),
              ),
            ),
            SafeArea(
              top: false, // Ignore top system UI for full immersive experience
          child: Column(
            children: [
              // Top Navigation
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0), // Reduced padding for more content space
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Logo
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset(
                        'assets/images/LOGO.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              
              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _slidingPages.length,
                  itemBuilder: (context, index) {
                    return _SlidingPageWidget(page: _slidingPages[index]);
                  },
                ),
              ),
              
              // Bottom Navigation
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slidingPages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.blue
                                : Colors.white30,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Action Buttons - Always visible
                    Column(
                      children: [
                        // Login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _completeOnboarding,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
                        const SizedBox(height: 12),
                        // Create Account button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _completeOnboarding,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white30),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Create an account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
          ],
        ),
      ),
    );
  }
}



/// Landing page widget with background image
class _LandingPageWidget extends StatelessWidget {
  const _LandingPageWidget({
    required this.onGetStarted,
    required this.onSkip,
  });

  final VoidCallback onGetStarted;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    // Hide status bar and set dark theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    return Scaffold(
      backgroundColor: Colors.black, // Full black background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black, // Full black background
          image: DecorationImage(
            image: AssetImage('assets/images/Background_LandingPage_Front.png'), // Back to original
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
            top: false, // Ignore top system UI for full immersive experience
            child: Padding(
               padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0), // Reduced padding for more content space
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset(
                          'assets/images/LOGO.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.anchor,
                              size: 80,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Main title text with shadow for better visibility
                  Text(
                    'Track stablecoin flows.\nDecode the economy.\nStay ahead with\nAnchorWatch.',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                      fontFamily: 'Inter',
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // GET STARTED Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onGetStarted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        shadowColor: Colors.blue.withOpacity(0.3),
                      ),
                      child: const Text(
                        'GET STARTED',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
        ),
      ),
    );
  }
}

/// Sliding page widget for individual pages
class _SlidingPageWidget extends StatelessWidget {
  const _SlidingPageWidget({required this.page});

  final OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
          children: [
            const SizedBox(height: 10),
            
            // Feature Image - Give more space
            Expanded(
              flex: 4,
              child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  page.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Content - Only description, no big title
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Small title
                Text(
                  page.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.2,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                // Description
                Text(
                  page.subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    height: 1.4,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

/// Onboarding page data model
class OnboardingPage {
  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.backgroundColor,
  });

  final String title;
  final String subtitle;
  final String image;
  final Color backgroundColor;
}