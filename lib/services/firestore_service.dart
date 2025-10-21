import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addGuest(String name, String unsur, String address) async {
    final slug = name.replaceAll(' ', '');
    await _db.collection('guests').doc(slug).set({
      'name': name,
      'unsur': unsur,
      'address': address,
      'slug': slug,
      'link': 'https://digitalinvitationaksala.vercel.app/to$slug',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getGuests() {
    return _db.collection('guests').orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> saveWeddingData(Map<String, dynamic> data) async {
    await _db.collection('wedding_data').doc('main').set(data);
  }

  Future<DocumentSnapshot> getWeddingData() async {
    return _db.collection('wedding_data').doc('main').get();
  }

  // Method baru untuk mendapatkan data guest berdasarkan slug
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

  // ===== UCAPAN METHODS =====
  
  // Menambahkan ucapan baru (versi lama - untuk backward compatibility)
  Future<void> addUcapan(String name, String ucapan) async {
    await _db.collection('ucapan').add({
      'name': name,
      'ucapan': ucapan,
      'kehadiran': 'Hadir', // default
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Menambahkan ucapan baru dengan konfirmasi kehadiran
  Future<void> addUcapanWithKehadiran(String name, String ucapan, String kehadiran) async {
    await _db.collection('ucapan').add({
      'name': name,
      'ucapan': ucapan,
      'kehadiran': kehadiran, // 'Hadir', 'Tidak Hadir', 'Ragu'
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Mendapatkan ucapan terbatas (limit)
  Stream<QuerySnapshot> getUcapanLimited(int limit) {
    return _db
        .collection('ucapan')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots();
  }

  // Mendapatkan semua ucapan
  Stream<QuerySnapshot> getAllUcapan() {
    return _db
        .collection('ucapan')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Menghapus ucapan (opsional, untuk admin)
  Future<void> deleteUcapan(String docId) async {
    await _db.collection('ucapan').doc(docId).delete();
  }

  // Mendapatkan statistik kehadiran
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
}