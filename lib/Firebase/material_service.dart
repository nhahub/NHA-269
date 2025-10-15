import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MaterialService {
  static final MaterialService _instance = MaterialService._internal();
  factory MaterialService() => _instance;
  MaterialService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Uploads a new material record to Firestore.
  /// Each file is stored under: users/{uid}/materials/{autoID}
  Future<void> uploadMaterial({
    required String name,
    required String type,
    required String subject,
    required int size,
    required String link,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('materials')
          .add({
        'name': name,
        'type': type,
        'subject': subject,
        'size': size,
        'link': link,
        'uploadedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to upload material: $e");
    }
  }

  /// Retrieves all materials uploaded by the current user.
  Future<List<Map<String, dynamic>>> getUserMaterials() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('materials')
          .orderBy('uploadedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch materials: $e");
    }
  }

  /// Deletes a material document from Firestore by its ID.
  Future<void> deleteMaterial(String materialId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('materials')
          .doc(materialId)
          .delete();
    } catch (e) {
      throw Exception("Failed to delete material: $e");
    }
  }
}
