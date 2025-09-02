import 'package:flutter/foundation.dart';
import '../models/player_model.dart';
import 'dart:math';

class GameService with ChangeNotifier {
  int _playerCount = 3;
  final List<Player> _players = [];
  bool _gameHasStarted = false;

  final List<Map<String, String>> _wordPairs = [
    {'citizenWord': 'Cat', 'undercoverWord': 'Tiger'},
    {'citizenWord': 'Coffee', 'undercoverWord': 'Tea'},
    {'citizenWord': 'Ship', 'undercoverWord': 'Boat'},
  ];

  int get playerCount => _playerCount;
  List<Player> get players => _players;
  bool get gameHasStarted => _gameHasStarted;


  void setupGame(List<String> playerNames) {
    _players.clear();
    for (var name in playerNames) {
      _players.add(Player(name: name));
    }
    _assignRolesAndWords();
    _gameHasStarted = true;
    notifyListeners(); 
  }

  void _assignRolesAndWords() {
    final random = Random();
    final wordPair = _wordPairs[random.nextInt(_wordPairs.length)];
    final citizenWord = wordPair['citizenWord']!;
    final undercoverWord = wordPair['undercoverWord']!;

    final undercoverIndex = random.nextInt(_players.length);

    for (int i = 0; i < _players.length; i++) {
      if (i == undercoverIndex) {
        _players[i].role = PlayerRole.undercover;
        _players[i].secretWord = undercoverWord;
      } else {
        _players[i].role = PlayerRole.citizen;
        _players[i].secretWord = citizenWord;
      }
    }
  }

  void resetGame() {
      _players.clear();
      _playerCount = 3;
      _gameHasStarted = false;
      notifyListeners();
  }
}
