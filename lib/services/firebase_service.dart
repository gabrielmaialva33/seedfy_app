import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../firebase_options.dart';

class FirebaseService {
  static FirebaseAuth get _auth => FirebaseAuth.instance;
  static FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  static FirebaseStorage get _storage => FirebaseStorage.instance;

  /// Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  /// Authentication Methods
  static User? get currentUser => _auth.currentUser;
  static bool get isAuthenticated => currentUser != null;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<UserCredential?> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e) {
      throw Exception('Failed to sign in anonymously: $e');
    }
  }

  static Future<UserCredential?> signInWithEmailPassword(
    String email, 
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  static Future<UserCredential?> signUpWithEmailPassword(
    String email, 
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Firestore Methods
  static CollectionReference get users => _firestore.collection('users');
  static CollectionReference get gardens => _firestore.collection('gardens');
  static CollectionReference get plants => _firestore.collection('plants');
  static CollectionReference get analysis => _firestore.collection('plant_analysis');
  static CollectionReference get chatHistory => _firestore.collection('chat_history');

  /// Save plant analysis result
  static Future<DocumentReference> savePlantAnalysis({
    required Map<String, dynamic> analysisData,
    String? imagePath,
  }) async {
    try {
      final userId = currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final data = {
        ...analysisData,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
        'imagePath': imagePath,
      };

      return await analysis.add(data);
    } catch (e) {
      throw Exception('Failed to save plant analysis: $e');
    }
  }

  /// Get user's plant analysis history
  static Stream<QuerySnapshot> getUserAnalysisHistory() {
    final userId = currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    return analysis
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Save chat message
  static Future<DocumentReference> saveChatMessage({
    required String message,
    required bool isFromUser,
    String? imageBase64,
  }) async {
    try {
      final userId = currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final data = {
        'userId': userId,
        'message': message,
        'isFromUser': isFromUser,
        'imageBase64': imageBase64,
        'timestamp': FieldValue.serverTimestamp(),
      };

      return await chatHistory.add(data);
    } catch (e) {
      throw Exception('Failed to save chat message: $e');
    }
  }

  /// Get user's chat history
  static Stream<QuerySnapshot> getUserChatHistory() {
    final userId = currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    return chatHistory
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  /// Upload image to Firebase Storage
  static Future<String> uploadImage(File imageFile, String path) async {
    try {
      final userId = currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final ref = _storage.ref().child('users/$userId/$path');
      final uploadTask = await ref.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Save user profile
  static Future<void> saveUserProfile({
    required String name,
    required String email,
    String? profileImageUrl,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      final userId = currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final data = {
        'name': name,
        'email': email,
        'profileImageUrl': profileImageUrl,
        'preferences': preferences ?? {},
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await users.doc(userId).set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  /// Get user profile
  static Future<DocumentSnapshot> getUserProfile() async {
    final userId = currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    return await users.doc(userId).get();
  }

  /// Save garden/farm data
  static Future<DocumentReference> saveGarden({
    required String name,
    required Map<String, dynamic> gardenData,
  }) async {
    try {
      final userId = currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final data = {
        'name': name,
        'userId': userId,
        'gardenData': gardenData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      return await gardens.add(data);
    } catch (e) {
      throw Exception('Failed to save garden: $e');
    }
  }

  /// Get user's gardens
  static Stream<QuerySnapshot> getUserGardens() {
    final userId = currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    return gardens
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }
}