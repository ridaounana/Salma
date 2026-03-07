# Coins System Documentation

## Overview

The Coins System is a monetization feature that allows users to purchase virtual coins to create and customize their love pages. This system provides a sustainable revenue stream while offering users flexibility in how they use the platform.

## Coin Pricing

### Base Costs
- **Create a Love Page**: 10 coins
- **Add Photo**: 2 coins per photo
- **Add Message**: 1 coin per message

### Coin Packages
| Package | Coins | Price |
|----------|--------|-------|
| Starter Pack | 50 | $0.99 |
| Basic Pack | 100 | $1.99 |
| Standard Pack | 250 | $4.99 |
| Premium Pack | 500 | $9.99 |
| Ultimate Pack | 1000 | $19.99 |

### Example Costs
- **Simple page** (no photos, 1 message): 11 coins
- **Page with 5 photos and 3 messages**: 10 + (5×2) + (3×1) = 23 coins
- **Page with 10 photos and 5 messages**: 10 + (10×2) + (5×1) = 35 coins

## System Architecture

### Services

#### CoinsService
Located at `lib/services/coins_service.dart`

**Key Methods:**
- `getUserCoins()`: Get user's current coin balance
- `hasEnoughCoins(int requiredCoins)`: Check if user has sufficient coins
- `deductCoins(int amount)`: Deduct coins from user's balance
- `addCoins(int amount, {String? packageId})`: Add coins (for purchases)
- `calculatePageCost({required int imageCount, required int messageCount})`: Calculate total cost
- `getTransactionHistory()`: Get user's transaction history

#### CoinsProvider
Located at `lib/providers/coins_provider.dart`

Manages coin state across the application using the Provider pattern.

**Key Methods:**
- `loadCoins()`: Load user's coins from Firestore
- `deductCoins(int amount)`: Deduct coins and update state
- `addCoins(int amount, {String? packageId})`: Add coins and update state
- `loadTransactions()`: Load transaction history

### Pages

#### CoinsStorePage
Located at `lib/dashboard/coins_store_page.dart`

Displays:
- Current coin balance
- Pricing information
- Coin packages for purchase
- Link to transaction history

#### TransactionHistoryPage
Located at `lib/dashboard/transaction_history_page.dart`

Displays:
- List of all coin transactions
- Transaction type (purchase/spend)
- Transaction amount
- Transaction date/time

## Database Structure

### Users Collection
```javascript
{
  "coins": number,
  "createdAt": Timestamp,
  "updatedAt": Timestamp
}
```

### Transactions Collection
```javascript
{
  "userId": string,
  "type": "purchase" | "spend",
  "amount": number,
  "packageId": string | null,
  "timestamp": Timestamp
}
```

## Firebase Security Rules

### Users Collection Rules
```javascript
match /users/{userId} {
  allow read: if request.auth != null && request.auth.uid == userId;
  allow write: if request.auth != null && request.auth.uid == userId;
}
```

### Transactions Collection Rules
```javascript
match /transactions/{transactionId} {
  allow read: if request.auth != null && request.auth.uid == resource.data.userId;
  allow create: if request.auth != null && request.auth.uid == request.resource.data.userId;
  allow update, delete: if false; // Transactions are immutable
}
```

## User Flow

### New User Registration
1. User signs up
2. System automatically creates user document with 5 free coins
3. User can create their first page (if they have enough coins)

### Creating a Page
1. User fills in page details
2. System calculates total cost
3. System checks if user has enough coins
4. If insufficient:
   - Show dialog with cost and current balance
   - Offer to purchase more coins
   - Redirect to Coins Store
5. If sufficient:
   - Deduct coins
   - Create page
   - Show success message with coin deduction

### Purchasing Coins
1. User navigates to Coins Store
2. User selects a package
3. User confirms purchase
4. System processes payment (currently simulated)
5. System adds coins to user's balance
6. Transaction is logged

## Payment Integration (Future)

### In-App Purchase
The `in_app_purchase` package is included for future implementation of native in-app purchases on:
- iOS (App Store)
- Android (Google Play Store)

### Web Payment
For web deployment, consider integrating:
- Stripe
- PayPal
- Firebase Payments

### Implementation Steps
1. Set up products in respective stores (App Store/Google Play)
2. Configure in_app_purchase package
3. Implement purchase flow
4. Handle purchase verification
5. Update coins on successful purchase
6. Handle refunds and cancellations

## Analytics & Reporting

### Key Metrics to Track
- Daily active users
- Coins purchased per day/week/month
- Coins spent per day/week/month
- Average coins per user
- Most popular coin packages
- Pages created per user
- Revenue per user

### Recommended Events
- `coin_package_purchased`: When user buys coins
- `page_created`: When user creates a page
- `insufficient_coins`: When user tries to create page without enough coins
- `store_viewed`: When user visits coins store

## Testing

### Test Scenarios
1. New user gets free coins
2. User can view coin balance
3. User can purchase coins
4. User can create page with sufficient coins
5. User cannot create page with insufficient coins
6. Coins are deducted correctly
7. Transactions are logged properly
8. Transaction history displays correctly

### Test Data
```javascript
// Test user with 100 coins
{
  "userId": "test-user-123",
  "coins": 100,
  "createdAt": Timestamp.now(),
  "updatedAt": Timestamp.now()
}

// Test transaction
{
  "userId": "test-user-123",
  "type": "purchase",
  "amount": 50,
  "packageId": "basic",
  "timestamp": Timestamp.now()
}
```

## Troubleshooting

### Common Issues

#### Coins not displaying
- Check if user document exists in Firestore
- Verify CoinsProvider is properly initialized
- Check network connectivity

#### Coins not deducting
- Verify user has sufficient coins
- Check Firestore security rules
- Review transaction logs

#### Purchase not working
- Verify payment provider configuration
- Check network connectivity
- Review error logs

### Debug Tips
1. Enable debug logging in CoinsService
2. Check Firestore console for data
3. Use Flutter DevTools to inspect state
4. Monitor Firebase Console for errors

## Future Enhancements

1. **Daily Login Bonus**: Reward users with coins for daily logins
2. **Referral System**: Give coins for referring friends
3. **Achievement System**: Unlock coins for completing tasks
4. **Subscription Model**: Monthly coin allowance
5. **Coin Bundles**: Limited-time offers and discounts
6. **Coin Transfer**: Allow users to gift coins to others
7. **Coin Multipliers**: Bonus coins during special events

## Support

For issues or questions about the coins system:
1. Check this documentation
2. Review transaction history
3. Contact support with transaction ID
4. Provide screenshots if applicable
