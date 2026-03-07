// File: viewer/page_viewer.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/page_service.dart';

class PageViewer extends StatefulWidget {
  final String pageId;

  const PageViewer({super.key, required this.pageId});

  @override
  State<PageViewer> createState() => _PageViewerState();
}

class _PageViewerState extends State<PageViewer> {
  final PageService _pageService = PageService();
  Map<String, dynamic>? _pageData;
  bool _isLoading = true;
  String _currentNote = '';
  Timer? _timer;
  Duration _timeUntilAnniversary = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  Future<void> _loadPage() async {
    try {
      final pageData = await _pageService.getPage(widget.pageId);
      if (mounted) {
        setState(() {
          _pageData = pageData;
          _isLoading = false;
          if (pageData != null) {
            // Initialize the current note if messages exist
            if (pageData['messages'] != null && 
                pageData['messages'] is List && 
                (pageData['messages'] as List).isNotEmpty) {
              _currentNote = (pageData['messages'] as List)[0].toString();
            } else {
              // Set a default message if no custom messages
              _currentNote = 'You are my everything ❤️';
            }
            // Always start the countdown
            _startCountdown();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading page: $e')),
        );
      }
    }
  }

  void _startCountdown() {
    if (_pageData == null) return;

    try {
      final anniversaryDate = DateTime.parse(_pageData!['anniversaryDate']);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final now = DateTime.now();
        final difference = anniversaryDate.difference(now);

        if (mounted) {
          setState(() {
            _timeUntilAnniversary = difference.isNegative
                ? Duration.zero
                : difference;
          });
        }
      });
    } catch (e) {
      print('Error starting countdown: $e');
      // Set a default duration if parsing fails
      setState(() {
        _timeUntilAnniversary = Duration.zero;
      });
    }
  }

  void _generateNewNote() {
    if (_pageData == null) return;

    final messages = _pageData!['messages'];

    // Check if messages exist and is a valid list
    if (messages != null && messages is List && messages.isNotEmpty) {
      setState(() {
        _currentNote = messages[
            DateTime.now().millisecondsSinceEpoch % messages.length].toString();
      });
    } else {
      // Use default messages if none provided
      final defaultMessages = [
        'You make my heart smile ❤️',
        'Every moment with you is precious 💕',
        'You are my sunshine ☀️',
        'I love you more than words can say 💖',
        'You are my everything ❤️',
        'Forever and always yours 💑',
        'My love for you grows stronger every day 🌹'
      ];
      setState(() {
        _currentNote = defaultMessages[
            DateTime.now().millisecondsSinceEpoch % defaultMessages.length];
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_pageData == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
            ),
          ),
          child: const Center(
            child: Text(
              'Page not found',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      );
    }

    final primaryColor = _parseColor(_pageData!['primaryColor'] ?? '#FF9A9E');
    final secondaryColor = _parseColor(_pageData!['secondaryColor'] ?? '#FECFEF');
    final partnerName = _pageData!['partnerName'] as String? ?? 'Love';
    final language = _pageData!['language'] as String? ?? 'en';
    final imageUrls = _pageData!['imageUrls'] as List<dynamic>? ?? [];

    return Scaffold(
      body: Directionality(
        textDirection: language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, secondaryColor],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Image
                  if (imageUrls.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(imageUrls[0] as String),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Greeting
                  Text(
                    'Hello, $partnerName ❤️',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black26,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Countdown Section
                  const Text(
                    'Countdown to our Anniversary:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimeBlock(_timeUntilAnniversary.inDays, 'DAYS'),
                      _buildTimeBlock(
                          _timeUntilAnniversary.inHours % 24, 'HRS'),
                      _buildTimeBlock(
                          _timeUntilAnniversary.inMinutes % 60, 'MIN'),
                      _buildTimeBlock(
                          _timeUntilAnniversary.inSeconds % 60, 'SEC'),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Love Note Card
                  Container(
                    constraints: const BoxConstraints(minHeight: 120),
                    width: double.infinity,
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
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

                  // Sweet Message Button
                  ElevatedButton.icon(
                    onPressed: _generateNewNote,
                    icon: const Icon(Icons.favorite, color: Colors.white),
                    label: const Text(
                      'Tell me something sweet',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
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
            timeValue.toString().padLeft(2, '0'),
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

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (e) {
      return const Color(0xFFFF9A9E);
    }
  }
}
