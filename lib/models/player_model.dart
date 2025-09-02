enum PlayerRole { citizen, undercover }

class Player {
  final String name;
  PlayerRole? role;
  String? secretWord;
  bool isEliminated;

  Player({
    required this.name,
    this.role,
    this.secretWord,
    this.isEliminated = false,
  });
}
