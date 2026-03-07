// File: dashboard/transaction_history_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coins_provider.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: const Color(0xFFE91E63),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
          ),
        ),
        child: Consumer<CoinsProvider>(
          builder: (context, coinsProvider, _) {
            if (coinsProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final transactions = coinsProvider.transactions;

            if (transactions.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No transactions yet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _buildTransactionCard(transaction);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final type = transaction['type'] as String? ?? 'unknown';
    final amount = transaction['amount'] as int? ?? 0;
    final timestamp = transaction['timestamp'];
    final packageId = transaction['packageId'] as String?;

    String title;
    Color iconColor;
    IconData iconData;

    switch (type) {
      case 'purchase':
        title = packageId != null
            ? 'Purchased ${_getPackageName(packageId)}'
            : 'Coins Purchased';
        iconColor = Colors.green;
        iconData = Icons.add_circle;
        break;
      case 'spend':
        title = 'Page Created';
        iconColor = Colors.red;
        iconData = Icons.remove_circle;
        break;
      default:
        title = 'Transaction';
        iconColor = Colors.grey;
        iconData = Icons.receipt;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(
            iconData,
            color: iconColor,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_formatTimestamp(timestamp)),
        trailing: Text(
          type == 'purchase' ? '+$amount' : '-$amount',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: type == 'purchase' ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }

  String _getPackageName(String packageId) {
    switch (packageId) {
      case 'starter':
        return 'Starter Pack';
      case 'basic':
        return 'Basic Pack';
      case 'standard':
        return 'Standard Pack';
      case 'premium':
        return 'Premium Pack';
      case 'ultimate':
        return 'Ultimate Pack';
      default:
        return 'Coins';
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';
    try {
      final date = (timestamp as dynamic).toDate();
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Unknown';
    }
  }
}
