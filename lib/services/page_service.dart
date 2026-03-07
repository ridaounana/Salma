// File: services/page_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class PageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid _uuid = const Uuid();

  // Create a new love page
  Future<String> createPage({
    required String partnerName,
    required String anniversaryDate,
    required String primaryColor,
    required String secondaryColor,
    required List<String> messages,
    required List<String> imageUrls,
    required String language,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      String pageId = _uuid.v4();

      await _firestore.collection('pages').doc(pageId).set({
        'userId': user.uid,
        'partnerName': partnerName,
        'anniversaryDate': anniversaryDate,
        'primaryColor': primaryColor,
        'secondaryColor': secondaryColor,
        'messages': messages,
        'imageUrls': imageUrls,
        'language': language,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'shareUrl': 'https://yourdomain.com/page/$pageId',
      });

      return pageId;
    } catch (e) {
      print('Error creating page: $e');
      rethrow;
    }
  }

  // Get page by ID
  Future<Map<String, dynamic>?> getPage(String pageId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('pages').doc(pageId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting page: $e');
      return null;
    }
  }

  // Get all pages for current user
  Future<List<Map<String, dynamic>>> getUserPages() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      QuerySnapshot querySnapshot = await _firestore
          .collection('pages')
          .where('userId', isEqualTo: user.uid)
          .get();

      List<Map<String, dynamic>> pages = querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['pageId'] = doc.id;
            return data;
          })
          .toList();

      // Sort by createdAt in Dart instead of Firestore
      pages.sort((a, b) {
        DateTime aTime = (a['createdAt'] as Timestamp).toDate();
        DateTime bTime = (b['createdAt'] as Timestamp).toDate();
        return bTime.compareTo(aTime); // descending order
      });

      return pages;
    } catch (e) {
      print('Error getting user pages: $e');
      return [];
    }
  }

  // Update page
  Future<void> updatePage({
    required String pageId,
    String? partnerName,
    String? anniversaryDate,
    String? primaryColor,
    String? secondaryColor,
    List<String>? messages,
    List<String>? imageUrls,
    String? language,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (partnerName != null) updateData['partnerName'] = partnerName;
      if (anniversaryDate != null) updateData['anniversaryDate'] = anniversaryDate;
      if (primaryColor != null) updateData['primaryColor'] = primaryColor;
      if (secondaryColor != null) updateData['secondaryColor'] = secondaryColor;
      if (messages != null) updateData['messages'] = messages;
      if (imageUrls != null) updateData['imageUrls'] = imageUrls;
      if (language != null) updateData['language'] = language;

      await _firestore.collection('pages').doc(pageId).update(updateData);
    } catch (e) {
      print('Error updating page: $e');
      rethrow;
    }
  }

  // Delete page
  Future<void> deletePage(String pageId) async {
    try {
      await _firestore.collection('pages').doc(pageId).delete();
    } catch (e) {
      print('Error deleting page: $e');
      rethrow;
    }
  }
}
