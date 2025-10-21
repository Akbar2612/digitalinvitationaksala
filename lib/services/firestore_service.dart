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
}