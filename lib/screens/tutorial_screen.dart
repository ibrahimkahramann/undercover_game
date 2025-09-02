import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'player_setup_screen.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  void onDoneOrSkip(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenTutorial', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PlayerSetupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      listContentConfig: [
        ContentConfig(
          title: "Welcome to Undercover!",
          description: "A social deduction game where you find the impostor among your friends.",
          pathImage: "assets/images/citizen.png", 
          backgroundColor: const Color(0xFF25283D), 
        ),
        ContentConfig(
          title: "Roles & Secret Words",
          description: "Most players are Citizens with the same word.\nOne is the Undercover with a similar, but different word.",
          pathImage: "assets/images/undercover.png",
          backgroundColor: const Color(0xFF8F3985), 
        ),
        ContentConfig(
          title: "Describe, Vote, Eliminate!",
          description: "Describe your word without saying it.\nDiscuss with others and vote for who you think is the Undercover to win!",
          pathImage: "assets/icon/icon.png",
          backgroundColor: const Color(0xFFA675A1), 
        ),
      ],
      onDonePress: () => onDoneOrSkip(context),
      onSkipPress: () => onDoneOrSkip(context),
      indicatorConfig: const IndicatorConfig(
        colorIndicator: Colors.white,
        sizeIndicator: 12,
      ),
      nextButtonStyle: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.white)),
      skipButtonStyle: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.white)),
      doneButtonStyle: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.white)),
    );
  }
}
