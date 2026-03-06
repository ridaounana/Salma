import 'dart:async'; // Required for the Timer
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:salma_love/game_page.dart';
import 'package:salma_love/leaderboard_page.dart';

void main() {
  runApp(const SalmaLoveApp());
}

class SalmaLoveApp extends StatelessWidget {
  const SalmaLoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'For Salma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE91E63)),
        useMaterial3: true,
        fontFamily: 'Georgia',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- LOVE NOTE LOGIC ---
  String _selectedLanguage = 'en';

  final Map<String, Map<String, dynamic>> _translations = {
    'en': {
      'greeting': 'Hello, Salma ❤️',
      'countdown': 'Countdown to our Anniversary:',
      'days': 'DAYS',
      'hours': 'HRS',
      'min': 'MIN',
      'sec': 'SEC',
      'button': 'Tell me something sweet',
      'default_note': 'Tap the heart for a surprise!',
      'notes': [
        "You are my favorite person.",
        "Your smile lights up my entire world.",
        "I love you more than coffee!",
        "Thank you for being you, Salma.",
        "You make every day better.",
        "My heart beats for you.",
        "You are beautiful inside and out.",
      ],
      'playGame': "Play a little game?",
      'leaderboard': "Leaderboard",
      'gameAppBarTitle': 'Memory Lane',
      'winTitle': 'You Won!',
      'winContent': 'You found all the memories! 🎉',
      'playAgain': 'Play Again',
      'enterName': 'Enter your name',
      'yourName': 'Your Name',
      'save': 'Save',
      'noScores': 'No scores yet. Play a game to be the first!',
    },
    'fr': {
      'greeting': 'Bonjour, Salma ❤️',
      'countdown': 'Compte à rebours de notre anniversaire :',
      'days': 'JOURS',
      'hours': 'HRS',
      'min': 'MIN',
      'sec': 'SEC',
      'button': 'Dis-moi quelque chose de doux',
      'default_note': 'Appuie sur le cœur pour une surprise !',
      'notes': [
        "Tu es ma personne préférée.",
        "Ton sourire illumine mon monde entier.",
        "Je t'aime plus que le café !",
        "Merci d'être toi, Salma.",
        "Tu rends chaque jour meilleur.",
        "Mon cœur bat pour toi.",
        "Tu es belle à l'intérieur comme à l'extérieur.",
      ],
      'playGame': "Jouer à un petit jeu ?",
      'leaderboard': "Classement",
      'gameAppBarTitle': 'Chemin de la mémoire',
      'winTitle': 'Tu as gagné !',
      'winContent': 'Tu as trouvé tous les souvenirs ! 🎉',
      'playAgain': 'Rejouer',
      'enterName': 'Entrez votre nom',
      'yourName': 'Votre nom',
      'save': 'Enregistrer',
      'noScores': 'Aucun score pour le moment. Jouez une partie pour être le premier !',
    },
    'ar': {
      'greeting': 'مرحباً سلمى ❤️',
      'countdown': 'العد التنازلي لذكرى زواجنا:',
      'days': 'أيام',
      'hours': 'ساعات',
      'min': 'دقائق',
      'sec': 'ثواني',
      'button': 'قل لي شيئاً لطيفاً',
      'default_note': 'اضغطي على القلب لمفاجأة!',
      'notes': [
        "أنتِ شخصي المفضل.",
        "ابتسامتك تضيء عالمي بأكمله.",
        "أحبك أكثر من القهوة!",
        "شكراً لكونك أنتِ، سلمى.",
        "أنتِ تجعلين كل يوم أفضل.",
        "قلبي ينبض لكِ.",
        "أنتِ جميلة قلباً وقالباً.",
      ],
      'playGame': "تلعب لعبة صغيرة؟",
      'leaderboard': "لوحة الصدارة",
      'gameAppBarTitle': 'ممر الذاكرة',
      'winTitle': 'لقد فزت!',
      'winContent': 'لقد وجدت كل الذكريات! 🎉',
      'playAgain': 'العب مرة أخرى',
      'enterName': 'أدخل أسمك',
      'yourName': 'اسمك',
      'save': 'حفظ',
      'noScores': 'لا توجد نتائج حتى الآن. العب لعبة لتكون الأول!',
    },
  };

  String _currentNote = "Tap the heart for a surprise!";

  void _generateNewNote() {
    setState(() {
      List<String> notes = _translations[_selectedLanguage]!['notes'];
      _currentNote = notes[Random().nextInt(notes.length)];
    });
  }

  // --- COUNTDOWN LOGIC ---
  Timer? _timer;
  Duration _timeUntilAnniversary = Duration.zero;
  
  // SET YOUR ANNIVERSARY DATE HERE (Year, Month, Day)
  // Example: November 15th, 2024
  final DateTime _anniversaryDate = DateTime(2026, 3, 29); 

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Always cancel timers when the widget is removed
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      
      // If the date has passed for this year, target next year
      DateTime targetDate = _anniversaryDate;
      if (now.isAfter(_anniversaryDate)) {
         // Logic to find the next occurrence of the anniversary could go here,
         // but for now, we will just calculate the difference to the specific date set.
         // If you want it to always be "next year", you'd add logic here.
      }

      final difference = targetDate.difference(now);

      setState(() {
        _timeUntilAnniversary = difference.isNegative ? Duration.zero : difference;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: _selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView( // Added scroll view for smaller screens
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- LANGUAGE SELECTOR ---
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51), // 0.2 opacity
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedLanguage,
                          dropdownColor: const Color(0xFFFF9A9E),
                          icon: const Icon(Icons.language, color: Colors.white),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          items: const [
                            DropdownMenuItem(value: 'en', child: Text("English")),
                            DropdownMenuItem(value: 'fr', child: Text("Français")),
                            DropdownMenuItem(value: 'ar', child: Text("العربية")),
                          ],
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedLanguage = newValue;
                                _currentNote = _translations[_selectedLanguage]!['default_note'];
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // --- PHOTO SECTION ---
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('img/unnamed.jpg'),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    _translations[_selectedLanguage]!['greeting'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(blurRadius: 10.0, color: Colors.black26, offset: Offset(2, 2)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- COUNTDOWN SECTION ---
                  Text(
                    _translations[_selectedLanguage]!['countdown'],
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimeBlock(_timeUntilAnniversary.inDays, _translations[_selectedLanguage]!['days']),
                      _buildTimeBlock(_timeUntilAnniversary.inHours % 24, _translations[_selectedLanguage]!['hours']),
                      _buildTimeBlock(_timeUntilAnniversary.inMinutes % 60, _translations[_selectedLanguage]!['min']),
                      _buildTimeBlock(_timeUntilAnniversary.inSeconds % 60, _translations[_selectedLanguage]!['sec']),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // --- LOVE NOTE CARD ---
                  Container(
                    constraints: const BoxConstraints(minHeight: 120),
                    width: double.infinity,
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.white.withAlpha(230), // 0.9 opacity
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                              child: Text(
                                _currentNote,
                                key: ValueKey<String>(_currentNote),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF880E4F),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- BUTTON ---
                  ElevatedButton.icon(
                    onPressed: _generateNewNote,
                    icon: const Icon(Icons.favorite, color: Colors.white),
                    label: Text(
                      _translations[_selectedLanguage]!['button'],
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- GAME BUTTON ---
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GamePage(
                            selectedLanguage: _selectedLanguage,
                            translations: _translations,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.games, color: Colors.white),
                    label: Text(
                      _translations[_selectedLanguage]!['playGame']!,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63).withAlpha(217), // 0.85 opacity
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- LEADERBOARD BUTTON ---
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaderboardPage(
                            selectedLanguage: _selectedLanguage,
                            translations: _translations,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.leaderboard, color: Colors.white),
                    label: Text(
                      _translations[_selectedLanguage]!['leaderboard']!,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63).withAlpha(217), // 0.85 opacity
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ),
      ),
    );
  }

  // Helper widget to build the time boxes
  Widget _buildTimeBlock(int timeValue, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(204), // 0.8 opacity
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            timeValue.toString().padLeft(2, '0'), // Ensures "05" instead of "5"
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFFE91E63),
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
