import 'package:flutter/material.dart';
import 'package:salma_love/leaderboard_model.dart';

class LeaderboardPage extends StatefulWidget {
  final String selectedLanguage;
  final Map<String, Map<String, dynamic>> translations;

  const LeaderboardPage({
    super.key,
    required this.selectedLanguage,
    required this.translations,
  });

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late Future<List<Score>> _scores;

  @override
  void initState() {
    super.initState();
    _scores = Leaderboard.getScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.translations[widget.selectedLanguage]!['leaderboard']!),
        backgroundColor: const Color(0xFFB0E0E6),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB0E0E6), Color(0xFFE6E6FA)],
          ),
        ),
        child: FutureBuilder<List<Score>>(
          future: _scores,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  widget.translations[widget.selectedLanguage]!['noScores'] ?? 'No scores yet!',
                  style: const TextStyle(fontSize: 18),
                ),
              );
            } else {
              final scores = snapshot.data!;
              return ListView.builder(
                itemCount: scores.length,
                itemBuilder: (context, index) {
                  final score = scores[index];
                  return ListTile(
                    leading: Text(
                      '${index + 1}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    title: Text(
                      score.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '${score.timeInSeconds}s',
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
