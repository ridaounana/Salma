// File: services/coins_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CoinsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Coin pricing
  static const int coinsPerPage = 10;
  static const int coinsPerImage = 2;
  static const int coinsPerMessage = 1;
  static const int freeCoins = 5; // Starting coins for new users

  // Coin packages for purchase
  static const Map<String, int> coinPackages = {
    'starter': 50,    // $0.99
    'basic': 100,      // $1.99
    'standard': 250,   // $4.99
    'premium': 500,    // $9.99
    'ultimate': 1000,  // $19.99
  };

  // Get user's coin balance
  Future<int> getUserCoins() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        // Create user document with free coins
        await _firestore.collection('users').doc(user.uid).set({
          'coins': freeCoins,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return freeCoins;
      }

      return (doc.data() as Map<String, dynamic>)['coins'] as int? ?? 0;
    } catch (e) {
      print('Error getting user coins: $e');
      return 0;
    }
  }

  // Check if user has enough coins
  Future<bool> hasEnoughCoins(int requiredCoins) async {
    final currentCoins = await getUserCoins();
    return currentCoins >= requiredCoins;
  }

  // Deduct coins from user's balance
  Future<bool> deductCoins(int amount) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final currentCoins = await getUserCoins();
      if (currentCoins < amount) return false;

      await _firestore.runTransaction((transaction) async {
        DocumentReference userRef = _firestore.collection('users').doc(user.uid);
        DocumentSnapshot snapshot = await transaction.get(userRef);

        if (!snapshot.exists) {
          throw Exception('User does not exist');
        }

        final data = snapshot.data() as Map<String, dynamic>;
        final currentBalance = data['coins'] as int? ?? 0;

        if (currentBalance < amount) {
          throw Exception('Insufficient coins');
        }

        transaction.update(userRef, {
          'coins': currentBalance - amount,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });

      return true;
    } catch (e) {
      print('Error deducting coins: $e');
      return false;
    }
  }

  // Add coins to user's balance (for purchases)
  Future<bool> addCoins(int amount, {String? packageId}) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore.runTransaction((transaction) async {
        DocumentReference userRef = _firestore.collection('users').doc(user.uid);
        DocumentSnapshot snapshot = await transaction.get(userRef);

        int currentBalance = 0;
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          currentBalance = data['coins'] as int? ?? 0;
        }

        transaction.set(userRef, {
          'coins': currentBalance + amount,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // Log the transaction
        final transactionRef = _firestore.collection('transactions').doc();
        transaction.set(transactionRef, {
          'userId': user.uid,
          'type': 'purchase',
          'amount': amount,
          'packageId': packageId,
          'timestamp': FieldValue.serverTimestamp(),
        });
      });

      return true;
    } catch (e) {
      print('Error adding coins: $e');
      return false;
    }
  }

  // Calculate cost for creating a page
  int calculatePageCost({
    required int imageCount,
    required int messageCount,
  }) {
    return coinsPerPage + 
           (imageCount * coinsPerImage) + 
           (messageCount * coinsPerMessage);
  }

  // Get transaction history
  Future<List<Map<String, dynamic>>> getTransactionHistory() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      QuerySnapshot querySnapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting transaction history: $e');
      return [];
    }
  }

  // Get coin package price in USD
  static String getPackagePrice(String packageId) {
    switch (packageId) {
      case 'starter':
        return '\$0.99';
      case 'basic':
        return '\$1.99';
      case 'standard':
        return '\$4.99';
      case 'premium':
        return '\$9.99';
      case 'ultimate':
        return '\$19.99';
      default:
        return '\$0.00';
    }
  }
}
