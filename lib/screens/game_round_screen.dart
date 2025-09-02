import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import '../models/player_model.dart';
import 'voting_screen.dart';

class GameRoundScreen extends StatelessWidget {
  const GameRoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameService = context.watch<GameService>();
    
    final activePlayers =
        gameService.players.where((p) => !p.isEliminated).toList();
    final eliminatedPlayers =
        gameService.players.where((p) => p.isEliminated).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Round ${gameService.roundNumber}'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPlayerList(context, 'Active Players', activePlayers, Colors.green),
            const SizedBox(height: 20),
            
            if (eliminatedPlayers.isNotEmpty)
              _buildPlayerList(context, 'Eliminated Players', eliminatedPlayers, Colors.red),
            
            const Spacer(),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VotingScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Proceed to Voting'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerList(BuildContext context, String title, List<Player> players, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: players.length * 60.0,
          child: ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return Card(
                child: ListTile(
                  leading: Icon(Icons.person, color: color),
                  title: Text(
                    player.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
