import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/player_model.dart';
import '../services/game_service.dart';
import 'game_round_screen.dart';

class RoleRevealScreen extends StatefulWidget {
  const RoleRevealScreen({super.key});

  @override
  State<RoleRevealScreen> createState() => _RoleRevealScreenState();
}

class _RoleRevealScreenState extends State<RoleRevealScreen> {
  int _currentPlayerIndex = 0;
  bool _isRoleVisible = false;

  void _showRole() {
    setState(() {
      _isRoleVisible = true;
    });
  }

  void _nextPlayerOrStartGame() {
    final gameService = Provider.of<GameService>(context, listen: false);

    if (_currentPlayerIndex < gameService.players.length - 1) {
      setState(() {
        _currentPlayerIndex++;
        _isRoleVisible = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GameRoundScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameService = context.watch<GameService>();
    final currentPlayer = gameService.players[_currentPlayerIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reveal Your Role'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _isRoleVisible
              ? _buildRoleVisibleView(currentPlayer)
              : _buildRoleHiddenView(currentPlayer),
        ),
      ),
    );
  }

  Widget _buildRoleHiddenView(Player player) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Pass the phone to',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          player.name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: _showRole,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          child: const Text('Tap to Reveal Your Role', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  Widget _buildRoleVisibleView(Player player) {
    String roleName = player.role.toString().split('.').last;
    roleName = roleName[0].toUpperCase() + roleName.substring(1);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${player.name}, here is your role:',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('You are a:', style: Theme.of(context).textTheme.titleMedium),
                Text(
                  roleName,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: player.role == PlayerRole.undercover ? Colors.red.shade700 : Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 20),
                Text('Your secret word is:', style: Theme.of(context).textTheme.titleMedium),
                Text(
                  player.secretWord ?? 'Error',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: _nextPlayerOrStartGame,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          child: const Text('Got It! Hide and Pass', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
