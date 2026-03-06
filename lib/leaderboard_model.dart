import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Score {
  final String name;
  final int timeInSeconds;

  Score({required this.name, required this.timeInSeconds});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      name: json['name'],
      timeInSeconds: json['timeInSeconds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'timeInSeconds': timeInSeconds,
    };
  }
}

class Leaderboard {
  static const _key = 'leaderboard';

  static Future<List<Score>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scoresJson = prefs.getStringList(_key) ?? [];
    return scoresJson
        .map((score) => Score.fromJson(jsonDecode(score)))
        .toList();
  }

  static Future<void> addScore(Score score) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = await getScores();
    scores.add(score);
    scores.sort((a, b) => a.timeInSeconds.compareTo(b.timeInSeconds));
    final scoresJson = scores.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_key, scoresJson);
  }
}
