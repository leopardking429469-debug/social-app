import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Search users by username
  Future<List<UserModel>> searchUsersByUsername(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      // Convert query to lowercase for case-insensitive search
      final lowerQuery = query.toLowerCase();
      
      final snapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: lowerQuery)
          .where('username', isLessThan: lowerQuery + 'z')
          .limit(20)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  // Search users by email
  Future<List<UserModel>> searchUsersByEmail(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      final lowerQuery = query.toLowerCase();
      
      final snapshot = await _firestore
          .collection('users')
          .where('email', isGreaterThanOrEqualTo: lowerQuery)
          .where('email', isLessThan: lowerQuery + 'z')
          .limit(20)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error searching users by email: $e');
      return [];
    }
  }

  // Get all users (for browsing)
  Future<List<UserModel>> getAllUsers({int limit = 50}) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  // Get trending/suggested users
  Stream<List<UserModel>> getTrendingUsers({int limit = 10}) {
    try {
      return _firestore
          .collection('users')
          .orderBy('followersCount', descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      print('Error getting trending users: $e');
      return Stream.value([]);
    }
  }

  // Search accounts by bio/description
  Future<List<UserModel>> searchUsersByBio(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      final lowerQuery = query.toLowerCase();
      
      final snapshot = await _firestore
          .collection('users')
          .get();

      final filtered = snapshot.docs
          .where((doc) {
            final bio = (doc['bio'] as String?)?.toLowerCase() ?? '';
            return bio.contains(lowerQuery);
          })
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();

      return filtered;
    } catch (e) {
      print('Error searching users by bio: $e');
      return [];
    }
  }
}
