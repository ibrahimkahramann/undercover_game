import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/player_model.dart';
import '../services/game_service.dart';
import 'game_over_screen.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  Player? _selectedPlayer;
  
  void _submitVote(GameService gameService) {
    if (_selectedPlayer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must select a player to eliminate.'))
      );
      return;
    }
    
    gameService.eliminatePlayer(_selectedPlayer!);
    final result = gameService.lastVoteResult!;

    if (result.contains("Win")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GameOverScreen(resultMessage: result)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Vote Result'),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                Navigator.of(context).pop(); 
              },
              child: const Text('Next Round'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameService = context.watch<GameService>();
    final activePlayers = gameService.players.where((p) => !p.isEliminated).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vote for the Undercover'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Who is the Undercover?',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: activePlayers.length,
                itemBuilder: (context, index) {
                  final player = activePlayers[index];
                  final isSelected = _selectedPlayer?.name == player.name;

                  return ChoiceChip(
                    label: Text(player.name, style: const TextStyle(fontSize: 18)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedPlayer = player;
                        }
                      });
                    },
                    selectedColor: Colors.red.shade200,
                    padding: const EdgeInsets.all(10),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _submitVote(context.read<GameService>()),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Eliminate Selected Player'),
            ),
          ],
        ),
      ),
    );
  }
}
