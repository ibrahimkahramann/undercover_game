// lib/screens/voting_screen.dart

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
  late Map<Player, int> _votes;

  @override
  void initState() {
    super.initState();
    final gameService = Provider.of<GameService>(context, listen: false);
    final activePlayers =
        gameService.players.where((p) => !p.isEliminated).toList();
    _votes = {for (var player in activePlayers) player: 0};
  }

  void _submitVotes(GameService gameService) {
    gameService.tallyVotesAndEliminate(_votes);
    final result = gameService.lastVoteResult!;

    if (result.contains("Win")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameOverScreen(resultMessage: result),
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
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
    final activePlayers =
        gameService.players.where((p) => !p.isEliminated).toList();

    final totalVotesCast = _votes.values.fold(0, (prev, count) => prev + count);

    final bool canAddMoreVotes = totalVotesCast < activePlayers.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tally the Votes'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Text(
                'Votes: $totalVotesCast / ${activePlayers.length}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add votes for each player based on the group\'s decision.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: activePlayers.length,
                itemBuilder: (context, index) {
                  final player = activePlayers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            player.name,
                            style: const TextStyle(fontSize: 20),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    if (_votes[player]! > 0) {
                                      _votes[player] = _votes[player]! - 1;
                                    }
                                  });
                                },
                              ),
                              Text(
                                _votes[player]?.toString() ?? '0',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed:
                                    canAddMoreVotes
                                        ? () {
                                          setState(() {
                                            _votes.putIfAbsent(player, () => 0);
                                            _votes[player] =
                                                _votes[player]! + 1;
                                          });
                                        }
                                        : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _submitVotes(context.read<GameService>()),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Finalize Votes & Eliminate'),
            ),
          ],
        ),
      ),
    );
  }
}
