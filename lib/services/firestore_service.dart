import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ==================== USER AUTHENTICATION ====================

  /// Membuat user baru di Firestore
  Future<void> createUser({
    required String username,
    required String password,
    required String role, // 'super_admin', 'admin', 'user'
    String? email,
    String? fullName,
  }) async {
    try {
      await _db.collection('users').doc(username).set({
        'username': username,
        'password': password, // Di production, gunakan password hashing!
        'role': role,
        'email': email,
        'fullName': fullName,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': null,
      });
      print('✅ User berhasil dibuat: $username');
    } catch (e) {
      print('❌ Error creating user: $e');
      rethrow;
    }
  }

  /// Mendapatkan data user berdasarkan username
  Future<DocumentSnapshot> getUserByUsername(String username) async {
    try {
      return await _db.collection('users').doc(username).get();
    } catch (e) {
      print('Error getting user: $e');
      rethrow;
    }
  }

  /// Update last login timestamp
  Future<void> updateLastLogin(String username) async {
    try {
      await _db.collection('users').doc(username).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating last login: $e');
    }
  }

  /// Verifikasi login user
  Future<Map<String, dynamic>?> verifyLogin(
    String username,
    String password,
  ) async {
    try {
      final doc = await _db.collection('users').doc(username).get();

      if (!doc.exists) {
        return null;
      }

      final userData = doc.data() as Map<String, dynamic>;

      // Cek apakah user aktif
      if (userData['isActive'] != true) {
        throw Exception('User tidak aktif');
      }

      // Verifikasi password
      if (userData['password'] == password) {
        // Update last login
        await updateLastLogin(username);
        return userData;
      }

      return null;
    } catch (e) {
      print('Error verifying login: $e');
      rethrow;
    }
  }

  /// Mendapatkan semua users (untuk super admin)
  Stream<QuerySnapshot> getAllUsers() {
    return _db
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Update user status (active/inactive)
  Future<void> updateUserStatus(String username, bool isActive) async {
    try {
      await _db.collection('users').doc(username).update({
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating user status: $e');
      rethrow;
    }
  }

  /// Change password
  Future<void> changePassword(String username, String newPassword) async {
    try {
      await _db.collection('users').doc(username).update({
        'password': newPassword, // Di production, gunakan password hashing!
        'passwordChangedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error changing password: $e');
      rethrow;
    }
  }

  // ==================== EXISTING METHODS ====================

  Future<void> addGuest(String name, String unsur, String address) async {
    final slug = name.replaceAll(' ', '');
    await _db.collection('guests').doc(slug).set({
      'name': name,
      'unsur': unsur,
      'address': address,
      'slug': slug,
      'link': 'https://digitalinvitationaksala.vercel.app/to$slug',
      'isShared': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getGuests() {
    return _db
        .collection('guests')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> deleteGuest(String guestId) async {
    try {
      await _db.collection('guests').doc(guestId).delete();
    } catch (e) {
      print('Error deleting guest: $e');
      rethrow;
    }
  }

  Future<void> updateGuestSharedStatus(String guestId, bool isShared) async {
    try {
      await _db.collection('guests').doc(guestId).update({
        'isShared': isShared,
        'sharedAt': isShared ? FieldValue.serverTimestamp() : null,
      });
    } catch (e) {
      print('Error updating guest shared status: $e');
      rethrow;
    }
  }

  Future<void> saveWeddingData(Map<String, dynamic> data) async {
    await _db.collection('wedding_data').doc('main').set(data);
  }

  Future<DocumentSnapshot> getWeddingData() async {
    return _db.collection('wedding_data').doc('main').get();
  }

  Future<Map<String, dynamic>?> getGuestBySlug(String slug) async {
    try {
      print('Fetching guest with slug: $slug');
      final doc = await _db.collection('guests').doc(slug).get();

      if (doc.exists) {
        print('Guest found: ${doc.data()}');
        return doc.data();
      } else {
        print('Guest not found with slug: $slug');
        return null;
      }
    } catch (e) {
      print('Error getting guest: $e');
      print('Error details: ${e.toString()}');
      return null;
    }
  }

  Future<void> addUcapan(String name, String ucapan) async {
    await _db.collection('ucapan').add({
      'name': name,
      'ucapan': ucapan,
      'kehadiran': 'Hadir',
      'replies': [],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addUcapanWithKehadiran(
    String name,
    String ucapan,
    String kehadiran,
  ) async {
    try {
      await _db.collection('ucapan').add({
        'name': name,
        'ucapan': ucapan,
        'kehadiran': kehadiran,
        'replies': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ Ucapan berhasil ditambahkan');
    } catch (e) {
      print('❌ Error adding ucapan: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getUcapanLimited(int limit) {
    return _db
        .collection('ucapan')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllUcapan() {
    return _db
        .collection('ucapan')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> deleteUcapan(String docId) async {
    await _db.collection('ucapan').doc(docId).delete();
  }

  Future<void> addReplyToUcapan(String docId, String replyText) async {
    final docRef = _db.collection('ucapan').doc(docId);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      final currentReplies = data['replies'] as List<dynamic>? ?? [];

      final newReply = {
        'text': replyText,
        'timestamp': Timestamp.now(),
        'isAdmin': true,
      };

      await docRef.update({
        'replies': [...currentReplies, newReply],
      });
    }
  }

  Future<void> deleteReply(String docId, Map<String, dynamic> reply) async {
    await _db.collection('ucapan').doc(docId).update({
      'replies': FieldValue.arrayRemove([reply]),
    });
  }

  Future<Map<String, int>> getKehadiranStats() async {
    final snapshot = await _db.collection('ucapan').get();

    int hadir = 0;
    int tidakHadir = 0;
    int ragu = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final kehadiran = data['kehadiran'] ?? 'Hadir';

      if (kehadiran == 'Hadir') {
        hadir++;
      } else if (kehadiran == 'Tidak Hadir') {
        tidakHadir++;
      } else {
        ragu++;
      }
    }

    return {
      'hadir': hadir,
      'tidakHadir': tidakHadir,
      'ragu': ragu,
      'total': snapshot.docs.length,
    };
  }

  Future<void> addKisahCinta(
    String judul,
    String tanggal,
    String cerita,
  ) async {
    try {
      await _db.collection('kisah_cinta').add({
        'judul': judul,
        'tanggal': tanggal,
        'cerita': cerita,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding kisah cinta: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getAllKisahCinta() {
    return _db.collection('kisah_cinta').snapshots();
  }

  Stream<QuerySnapshot> getKisahCintaLimited(int limit) {
    return _db.collection('kisah_cinta').limit(limit).snapshots();
  }

  Future<void> updateKisahCinta(
    String docId,
    String judul,
    String tanggal,
    String cerita,
  ) async {
    try {
      await _db.collection('kisah_cinta').doc(docId).update({
        'judul': judul,
        'tanggal': tanggal,
        'cerita': cerita,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating kisah cinta: $e');
      rethrow;
    }
  }

  Future<void> deleteKisahCinta(String docId) async {
    try {
      await _db.collection('kisah_cinta').doc(docId).delete();
    } catch (e) {
      print('Error deleting kisah cinta: $e');
      rethrow;
    }
  }

  Future<DocumentSnapshot> getKisahCintaById(String docId) async {
    try {
      return await _db.collection('kisah_cinta').doc(docId).get();
    } catch (e) {
      print('Error getting kisah cinta: $e');
      rethrow;
    }
  }

  Future<int> getKisahCintaCount() async {
    try {
      final snapshot = await _db.collection('kisah_cinta').get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error getting kisah cinta count: $e');
      return 0;
    }
  }

  Future<DocumentSnapshot> getKisahCintaPenutup() async {
    try {
      return await _db.collection('kisah_cinta_penutup').doc('penutup').get();
    } catch (e) {
      print('Error getting kisah cinta penutup: $e');
      rethrow;
    }
  }

  Future<void> setKisahCintaPenutup(String title, String kisah) async {
    try {
      await _db.collection('kisah_cinta_penutup').doc('penutup').set({
        'title': title,
        'kisah': kisah,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error setting kisah cinta penutup: $e');
      rethrow;
    }
  }

  Stream<DocumentSnapshot> getKisahCintaPenutupStream() {
    return _db.collection('kisah_cinta_penutup').doc('penutup').snapshots();
  }

  Future<bool> hasKisahCintaPenutup() async {
    try {
      final doc = await _db
          .collection('kisah_cinta_penutup')
          .doc('penutup')
          .get();
      return doc.exists && doc.data() != null;
    } catch (e) {
      print('Error checking kisah cinta penutup: $e');
      return false;
    }
  }

  Future<void> updateGuest(String guestId, Map<String, dynamic> data) async {
    try {
      await _db.collection('guests').doc(guestId).update(data);
    } catch (e) {
      throw Exception('Failed to update guest: $e');
    }
  }

  Future<void> deleteKisahCintaPenutup() async {
    try {
      await _db.collection('kisah_cinta_penutup').doc('penutup').delete();
    } catch (e) {
      print('Error deleting kisah cinta penutup: $e');
      rethrow;
    }
  }
}
