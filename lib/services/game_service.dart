import 'package:flutter/foundation.dart';
import '../models/player_model.dart';
import 'dart:math';

class GameService with ChangeNotifier {
  final Random _random = Random(); 
  int _playerCount = 3;
  final List<Player> _players = [];
  bool _gameHasStarted = false;
  int _roundNumber = 1;
  String? _lastVoteResult;

  final List<Map<String, String>> _wordPairs = [
    {'citizenWord': 'Cat', 'undercoverWord': 'Tiger'},
    {'citizenWord': 'Coffee', 'undercoverWord': 'Tea'},
    {'citizenWord': 'Ship', 'undercoverWord': 'Boat'},
    {'citizenWord': 'Piano', 'undercoverWord': 'Guitar'},
    {'citizenWord': 'Apple', 'undercoverWord': 'Orange'},
    {'citizenWord': 'Car', 'undercoverWord': 'Bus'},
    {'citizenWord': 'Mountain', 'undercoverWord': 'Hill'},
    {'citizenWord': 'Ocean', 'undercoverWord': 'Lake'},
    {'citizenWord': 'Pen', 'undercoverWord': 'Pencil'},
    {'citizenWord': 'Movie', 'undercoverWord': 'Series'},
    {'citizenWord': 'Bread', 'undercoverWord': 'Cake'},
    {'citizenWord': 'Sun', 'undercoverWord': 'Moon'},
    {'citizenWord': 'Phone', 'undercoverWord': 'Laptop'},
    {'citizenWord': 'Winter', 'undercoverWord': 'Summer'},
    {'citizenWord': 'Soccer', 'undercoverWord': 'Basketball'},
    {'citizenWord': 'Novel', 'undercoverWord': 'Magazine'},
    {'citizenWord': 'Jeans', 'undercoverWord': 'Shorts'},
    {'citizenWord': 'Rain', 'undercoverWord': 'Snow'},
    {'citizenWord': 'Restaurant', 'undercoverWord': 'Cafe'},
    {'citizenWord': 'Chicken', 'undercoverWord': 'Turkey'},
  ];

  int get playerCount => _playerCount;
  List<Player> get players => _players;
  bool get gameHasStarted => _gameHasStarted;
  int get roundNumber => _roundNumber;
  String? get lastVoteResult => _lastVoteResult;


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
    final wordPair = _wordPairs[_random.nextInt(_wordPairs.length)]; // MODIFY THIS LINE
    final citizenWord = wordPair['citizenWord']!;
    final undercoverWord = wordPair['undercoverWord']!;

    final undercoverIndex = _random.nextInt(_players.length); // MODIFY THIS LINE

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
      _roundNumber = 1;
      _lastVoteResult = null;
      notifyListeners();
  }

  void eliminatePlayer(Player eliminatedPlayer) {
    final player = _players.firstWhere((p) => p.name == eliminatedPlayer.name);
    player.isEliminated = true;
    _lastVoteResult = "${player.name} was eliminated.";

    final winner = _checkWinCondition();
    if (winner != null) {
      _lastVoteResult = winner;
    } else {
      _roundNumber++;
    }

    notifyListeners();
  }

  String? _checkWinCondition() {
    final activePlayers = _players.where((p) => !p.isEliminated).toList();
    
    final undercover = _players.firstWhere((p) => p.role == PlayerRole.undercover);

    if (undercover.isEliminated) {
      return "The Undercover was found! Citizens Win!";
    }

    if (activePlayers.length <= 2) {
      return "Only two remain... The Undercover Wins!";
    }

    return null;
  }
}
