// File: providers/coins_provider.dart
import 'package:flutter/material.dart';
import '../services/coins_service.dart';

class CoinsProvider with ChangeNotifier {
  final CoinsService _coinsService = CoinsService();

  int _coins = 0;
  bool _isLoading = false;
  List<Map<String, dynamic>> _transactions = [];

  int get coins => _coins;
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get transactions => _transactions;

  // Load user's coins
  Future<void> loadCoins() async {
    _isLoading = true;
    notifyListeners();

    try {
      _coins = await _coinsService.getUserCoins();
    } catch (e) {
      print('Error loading coins: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Check if user has enough coins
  Future<bool> hasEnoughCoins(int requiredCoins) async {
    return await _coinsService.hasEnoughCoins(requiredCoins);
  }

  // Deduct coins
  Future<bool> deductCoins(int amount) async {
    final success = await _coinsService.deductCoins(amount);
    if (success) {
      _coins -= amount;
      notifyListeners();
    }
    return success;
  }

  // Add coins (purchase)
  Future<bool> addCoins(int amount, {String? packageId}) async {
    final success = await _coinsService.addCoins(amount, packageId: packageId);
    if (success) {
      _coins += amount;
      notifyListeners();
    }
    return success;
  }

  // Load transaction history
  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await _coinsService.getTransactionHistory();
    } catch (e) {
      print('Error loading transactions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Calculate page cost
  int calculatePageCost({
    required int imageCount,
    required int messageCount,
  }) {
    return _coinsService.calculatePageCost(
      imageCount: imageCount,
      messageCount: messageCount,
    );
  }
}
