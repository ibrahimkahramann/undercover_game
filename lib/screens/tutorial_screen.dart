import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'player_setup_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<TutorialSlide> _slides = [
    TutorialSlide(
      title: "Welcome to Undercover!",
      description: "A social deduction game where you find the impostor among your friends.",
      imagePath: "assets/images/citizen.png",
      overlayColor: const Color(0xFF25283D).withOpacity(0.8),
    ),
    TutorialSlide(
      title: "Roles & Secret Words",
      description: "Most players are Citizens with the same word.\nOne is the Undercover with a similar, but different word.",
      imagePath: "assets/images/undercover.png",
      overlayColor: const Color(0xFF8F3985).withOpacity(0.8),
    ),
    TutorialSlide(
      title: "Describe, Vote, Eliminate!",
      description: "Describe your word without saying it.\nDiscuss with others and vote for who you think is the Undercover to win!",
      imagePath: "assets/icon/icon.png",
      overlayColor: const Color(0xFFA675A1).withOpacity(0.8),
    ),
  ];

  void onDoneOrSkip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenTutorial', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PlayerSetupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return _buildSlide(_slides[index]);
            },
          ),
          
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: onDoneOrSkip,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                Row(
                  children: List.generate(
                    _slides.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index 
                            ? Colors.white 
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                
                TextButton(
                  onPressed: () {
                    if (_currentPage == _slides.length - 1) {
                      onDoneOrSkip();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _currentPage == _slides.length - 1 ? 'Done' : 'Next',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Widget _buildSlide(TutorialSlide slide) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(slide.imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            slide.overlayColor,
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Title
                Text(
                  slide.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 8,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    slide.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      height: 1.5,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 4,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TutorialSlide {
  final String title;
  final String description;
  final String imagePath;
  final Color overlayColor;

  TutorialSlide({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.overlayColor,
  });
}
