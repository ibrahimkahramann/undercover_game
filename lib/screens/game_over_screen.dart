import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import 'player_setup_screen.dart';

class GameOverScreen extends StatelessWidget {
  final String resultMessage;

  const GameOverScreen({
    super.key,
    required this.resultMessage,
  });

  @override
  Widget build(BuildContext context) {
    final bool citizensWon = resultMessage.contains("Citizens Win");
    final String winnerText = citizensWon ? "Citizens Win!" : "Undercover Wins!";

    return Scaffold(
      backgroundColor: citizensWon ? Colors.green.shade100 : Colors.red.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                citizensWon ? Icons.security : Icons.theater_comedy,
                size: 100,
                color: citizensWon ? Colors.green.shade800 : Colors.red.shade800,
              ),
              const SizedBox(height: 20),
              Text(
                winnerText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: citizensWon ? Colors.green.shade900 : Colors.red.shade900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                resultMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  final gameService = context.read<GameService>();
                  gameService.resetGame();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const PlayerSetupScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                child: const Text('Play Again', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
