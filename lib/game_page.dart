import 'dart:async';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final String selectedLanguage;
  final Map<String, Map<String, dynamic>> translations;

  const GamePage({
    super.key,
    required this.selectedLanguage,
    required this.translations,
  });

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  late List<CardItem> _cards;
  CardItem? _firstCard;
  CardItem? _secondCard;
  int _matches = 0;
  bool _isProcessing = false;

  // Image paths for the game
  final List<String> _imagePaths = [
    "img/game (1).jpeg",
    "img/game (2).jpeg",
    "img/game (3).jpeg",
    "img/game (4).jpeg",
    "img/game (5).jpeg",
    "img/game (6).jpeg",
  ];

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  void _setupGame() {
    _matches = 0;
    List<String> gameImages = [];
    gameImages.addAll(_imagePaths);
    gameImages.addAll(_imagePaths); // Duplicate for pairs
    gameImages.shuffle();

    _cards = List.generate(
      gameImages.length,
      (index) => CardItem(id: index, imagePath: gameImages[index]),
    );
    setState(() {});
  }

  void _onCardTapped(CardItem card) {
    if (card.isFlipped || _isProcessing) return;

    setState(() {
      card.isFlipped = true;
    });

    if (_firstCard == null) {
      _firstCard = card;
    } else {
      _secondCard = card;
      _isProcessing = true;
      _checkForMatch();
    }
  }

  void _checkForMatch() {
    if (_firstCard!.imagePath == _secondCard!.imagePath) {
      // It's a match!
      setState(() {
        _matches++;
      });
      _resetTurn();
      if (_matches == _imagePaths.length) {
        _showWinDialog();
      }
    } else {
      // Not a match, flip back after a delay
      Timer(const Duration(milliseconds: 1200), () {
        setState(() {
          _firstCard!.isFlipped = false;
          _secondCard!.isFlipped = false;
        });
        _resetTurn();
      });
    }
  }

  void _resetTurn() {
    _firstCard = null;
    _secondCard = null;
    _isProcessing = false;
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(widget.translations[widget.selectedLanguage]!['winTitle']!, textAlign: TextAlign.center),
          content: Text(widget.translations[widget.selectedLanguage]!['winContent']!, textAlign: TextAlign.center),
          actions: <Widget>[
            TextButton(
              child: Text(widget.translations[widget.selectedLanguage]!['playAgain']!),
              onPressed: () {
                Navigator.of(context).pop();
                _setupGame();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.translations[widget.selectedLanguage]!['gameAppBarTitle']!,
            style: const TextStyle(color: Color(0xFF2C3E50))),
        backgroundColor: const Color(0xFFB0E0E6),
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB0E0E6), Color(0xFFE6E6FA)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              return _buildCard(context, _cards[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, CardItem card) {
    return GestureDetector(
      onTap: () => _onCardTapped(card),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: card.isFlipped
                ? Image.asset(
                    card.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: const Color(0xFFF8F8F8).withOpacity(0.8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.question_mark,
                        size: 40,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class CardItem {
  final int id;
  final String imagePath;
  bool isFlipped;

  CardItem({required this.id, required this.imagePath, this.isFlipped = false});
}
