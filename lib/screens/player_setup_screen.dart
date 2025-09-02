import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';
import 'role_reveal_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  double _playerCount = 3;

  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      12,
      (i) => TextEditingController(text: 'Player ${i + 1}'),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startGame() {
    final playerNames =
        _controllers
            .sublist(0, _playerCount.toInt())
            .map((controller) => controller.text.trim())
            .toList();

    if (playerNames.any((name) => name.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Player names cannot be empty!')),
      );
      return;
    }

    final gameService = Provider.of<GameService>(context, listen: false);
    gameService.setupGame(playerNames);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RoleRevealScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game Setup')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Number of Players: ${_playerCount.toInt()}',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Slider(
                value: _playerCount,
                min: 3,
                max: 12,
                divisions: 9,
                label: _playerCount.toInt().toString(),
                onChanged: (newValue) {
                  setState(() {
                    _playerCount = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),

              Text(
                'Enter Player Names',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _playerCount.toInt(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: TextField(
                      controller: _controllers[index],
                      decoration: InputDecoration(
                        labelText: 'Player ${index + 1}',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
