import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
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
          child:
              _isRoleVisible
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
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: _showRole,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          child: const Text(
            'Tap to Reveal Your Role',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleVisibleView(Player player) {
    String roleName = player.role.toString().split('.').last;
    roleName = roleName[0].toUpperCase() + roleName.substring(1);

    final String imagePath =
        player.role == PlayerRole.undercover
            ? 'assets/images/undercover.png'
            : 'assets/images/citizen.png';

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.7),
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeIn(
              duration: const Duration(milliseconds: 800),
              child: Text(
                '${player.name}, here is your role:',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            FadeIn(
              delay: const Duration(milliseconds: 400),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'You are a:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      roleName,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            player.role == PlayerRole.undercover
                                ? Colors.red.shade300
                                : Colors.green.shade300,
                        shadows: [
                          Shadow(
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Your secret word is:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        player.secretWord ?? 'Error',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: const Offset(1, 1),
                              blurRadius: 3,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            FadeIn(
              delay: const Duration(milliseconds: 600),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: _nextPlayerOrStartGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: Colors.white.withOpacity(0.9),
                    foregroundColor: Colors.black87,
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Got It! Hide and Pass',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
