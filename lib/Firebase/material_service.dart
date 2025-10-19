import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MaterialService {
  static final MaterialService _instance = MaterialService._internal();
  factory MaterialService() => _instance;
  MaterialService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Uploads a new material record to Firestore.
  Future<void> uploadMaterial({
    required String name,
    required String type,
    required String subject,
    required int size,
    required String url,
    required String fileId,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

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
        'url': url,
        'uploadedAt': FieldValue.serverTimestamp(),
        'fileId': fileId,
      });
    } catch (e) {
      throw Exception("Failed to upload material: $e");
    }
  }

  /// Retrieves all materials uploaded by the current user.
  Future<List<Map<String, dynamic>>> getUserMaterials() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('materials')
          .orderBy('uploadedAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        final uploadedAt = data['uploadedAt'];
        if (uploadedAt is Timestamp) {
          data['uploadedAt'] = uploadedAt.toDate();
        }
        return {'id': doc.id, ...data};
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch materials: $e");
    }
  }

  /// Deletes a material document from Firestore.
  Future<void> deleteMaterial(String materialId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

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

  /// Calculates total storage used by the user.
  Future<int> getTotalStorageUsed() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('materials')
          .get();

      int totalBytes = 0;
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final size = data['size'];
        if (size != null && size is int) totalBytes += size;
      }
      return totalBytes;
    } catch (e) {
      throw Exception("Failed to calculate total storage used: $e");
    }
  }

  /// Counts total uploaded materials.
  Future<int> getTotalFilesCount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('materials')
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception("Failed to get total files count: $e");
    }
  }

  /// Deletes a material from both Firestore and Google Drive.
  Future<void> deleteMaterialEverywhere({
    required String materialId,
    required String fileId,
  }) async {
    try {
      // Step 1: Delete from Firebase
      await deleteMaterial(materialId);

      // Step 2: Delete from Google Drive (via Apps Script)
      final driveScriptUrl = dotenv.env['driveScriptUrl'];
      if (driveScriptUrl == null || driveScriptUrl.isEmpty) {
        throw Exception('driveScriptUrl missing from .env');
      }

      final response = await http.post(
        Uri.parse(driveScriptUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"action": "delete", "fileId": fileId}),
      );

      // ---- Handle Redirect (302)
      if (response.isRedirect || response.statusCode == 302) {
        final redirectedUrl = response.headers['location'];
        if (redirectedUrl == null) {
          throw Exception('Redirect location missing from Drive script response.');
        }

        final redirectedResp = await http.get(Uri.parse(redirectedUrl));
        if (redirectedResp.statusCode == 200) {
          final data = jsonDecode(redirectedResp.body);
          if (data['success'] == true) return;
          throw Exception("Drive delete failed: ${data['error'] ?? 'Unknown error'}");
        } else {
          throw Exception("Redirected request failed with ${redirectedResp.statusCode}");
        }
      }

      // ---- Handle Normal 200 Response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) return;
        throw Exception("Drive delete failed: ${data['error'] ?? 'Unknown error'}");
      }

      // ---- Handle Others
      throw Exception('Unexpected status code from Drive Script: ${response.statusCode}');
    } catch (e) {
      throw Exception("Failed to delete material and file: $e");
    }
  }
}