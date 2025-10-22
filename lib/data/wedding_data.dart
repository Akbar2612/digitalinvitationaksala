import 'package:cloud_firestore/cloud_firestore.dart';

final WeddingData weddingData = WeddingData._();

class WeddingData {
  Map<String, dynamic>? _data;
  bool _isLoaded = false;

  WeddingData._();

  static WeddingData get instance => weddingData;

  Future<void> loadFromFirestore() async {
    try {
      print('📖 Attempting to load wedding data from Firestore...');
      final doc = await FirebaseFirestore.instance
          .collection('wedding_data')
          .doc('main')
          .get();

      if (doc.exists && doc.data() != null) {
        _data = doc.data();
        _isLoaded = true;
        print('✅ Wedding data loaded from Firestore');
      } else {
        // Jika belum ada data, biarkan kosong
        print('⚠️ No data in Firestore, all fields will be empty');
        _data = {};
        _isLoaded = true;
      }
    } catch (e) {
      print('❌ Error loading wedding data: $e');
      _data = {};
      _isLoaded = true;
    }
  }

  String get brideName => _data?['brideName'] ?? '';
  String get groomName => _data?['groomName'] ?? '';
  String get groomnickName => _data?['groomnickName'] ?? '';
  String get bridenickName => _data?['bridenickName'] ?? '';
  String get FatherparentsBride => _data?['FatherparentsBride'] ?? '';
  String get MotherparentsBride => _data?['MotherparentsBride'] ?? '';
  String get FatherparentsGroom => _data?['FatherparentsGroom'] ?? '';
  String get MotherparentsGroom => _data?['MotherparentsGroom'] ?? '';
  String get ResepsiDate => _data?['ResepsiDate'] ?? '';
  String get AkadDate => _data?['AkadDate'] ?? '';
  String get ResepsiTime => _data?['ResepsiTime'] ?? '';
  String get AkadTime => _data?['AkadTime'] ?? '';
  String get ResepsiLocation => _data?['ResepsiLocation'] ?? '';
  String get AkadLocation => _data?['AkadLocation'] ?? '';
  String get locationUrl => _data?['locationUrl'] ?? '';
  String get accountNumberBride => _data?['accountNumberBride'] ?? '';
  String get accountNumberGroom => _data?['accountNumberGroom'] ?? '';

  bool get isLoaded => _isLoaded;
}

String get brideName => weddingData.brideName;
String get groomName => weddingData.groomName;
String get groomnickName => weddingData.groomnickName;
String get bridenickName => weddingData.bridenickName;
String get FatherparentsBride => weddingData.FatherparentsBride;
String get MotherparentsBride => weddingData.MotherparentsBride;
String get FatherparentsGroom => weddingData.FatherparentsGroom;
String get MotherparentsGroom => weddingData.MotherparentsGroom;
String get ResepsiDate => weddingData.ResepsiDate;
String get AkadDate => weddingData.AkadDate;
String get ResepsiTime => weddingData.ResepsiTime;
String get AkadTime => weddingData.AkadTime;
String get ResepsiLocation => weddingData.ResepsiLocation;
String get AkadLocation => weddingData.AkadLocation;
String get locationUrl => weddingData.locationUrl;
String get accountNumberBride => weddingData.accountNumberBride;
String get accountNumberGroom => weddingData.accountNumberGroom;
