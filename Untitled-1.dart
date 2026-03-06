import 'dart:async'; // Required for the Timer
import 'package:flutter/material.dart';
import 'dart:math';

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
  final List<String> _loveNotes = [
    "You are my favorite person.",
    "Your smile lights up my entire world.",
    "I love you more than coffee!",
    "Thank you for being you, Salma.",
    "You make every day better.",
    "My heart beats for you.",
    "You are beautiful inside and out.",
  ];

  String _currentNote = "Tap the heart for a surprise!";

  void _generateNewNote() {
    setState(() {
      _currentNote = _loveNotes[Random().nextInt(_loveNotes.length)];
    });
  }

  // --- COUNTDOWN LOGIC ---
  Timer? _timer;
  Duration _timeUntilAnniversary = Duration.zero;
  
  // SET YOUR ANNIVERSARY DATE HERE (Year, Month, Day)
  // Example: November 15th, 2024
  final DateTime _anniversaryDate = DateTime(2024, 11, 15); 

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
      body: Container(
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
                  // --- PHOTO SECTION ---
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFFE91E63),
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  const Text(
                    "Hello, Salma ❤️",
                    style: TextStyle(
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
                  const Text(
                    "Countdown to our Anniversary:",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimeBlock(_timeUntilAnniversary.inDays, "DAYS"),
                      _buildTimeBlock(_timeUntilAnniversary.inHours % 24, "HRS"),
                      _buildTimeBlock(_timeUntilAnniversary.inMinutes % 60, "MIN"),
                      _buildTimeBlock(_timeUntilAnniversary.inSeconds % 60, "SEC"),
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
                      color: Colors.white.withOpacity(0.9),
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
                    label: const Text(
                      "Tell me something sweet",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
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
    );
  }

  // Helper widget to build the time boxes
  Widget _buildTimeBlock(int timeValue, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
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
