import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class LoveStorySection extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header Title
          Text(
            'Our Love Story',
            style: GoogleFonts.lobster(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: Color(0xFFF5F5F5),
              letterSpacing: 1.0,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4),

          // Divider Line
          Container(
            width: 60,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFD4AF37).withOpacity(0),
                  Color(0xFFD4AF37),
                  Color(0xFFD4AF37).withOpacity(0),
                ],
              ),
            ),
          ),

          SizedBox(height: 8),

          // Subtitle
          Text(
            'The journey of our beautiful love',
            style: GoogleFonts.roboto(
              fontSize: 11,
              color: Color(0xFFB0B0B0),
              letterSpacing: 0.5,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 16),

          // Story Cards from Firestore
          StreamBuilder<QuerySnapshot>(
            stream: _firestoreService.getAllKisahCinta(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(
                      color: Color(0xFFD4AF37),
                      strokeWidth: 2,
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Terjadi kesalahan memuat kisah cinta',
                      style: GoogleFonts.roboto(
                        color: Color(0xFFB0B0B0),
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SizedBox.shrink();
              }

              // Sort stories by createdAt timestamp (oldest first)
              final stories = snapshot.data!.docs;
              stories.sort((a, b) {
                final aData = a.data() as Map<String, dynamic>;
                final bData = b.data() as Map<String, dynamic>;
                final aTimestamp = aData['createdAt'] as Timestamp?;
                final bTimestamp = bData['createdAt'] as Timestamp?;

                if (aTimestamp == null && bTimestamp == null) return 0;
                if (aTimestamp == null) return 1;
                if (bTimestamp == null) return -1;

                return aTimestamp.compareTo(bTimestamp);
              });

              return Column(
                children: [
                  // Loop through all stories
                  ...stories.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final judul = data['judul'] ?? '';
                    final tanggal = data['tanggal'] ?? '';
                    final cerita = data['cerita'] ?? '';

                    return Column(
                      children: [
                        _buildStoryCard(
                          title: judul,
                          date: tanggal,
                          description: cerita,
                        ),
                        SizedBox(height: 12),
                      ],
                    );
                  }).toList(),

                  // Closing Card from Firestore
                  FutureBuilder<DocumentSnapshot>(
                    future: _firestoreService.getKisahCintaPenutup(),
                    builder: (context, penutupSnapshot) {
                      if (penutupSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(
                              color: Color(0xFFD4AF37),
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }

                      if (penutupSnapshot.hasError ||
                          !penutupSnapshot.hasData ||
                          !penutupSnapshot.data!.exists) {
                        return SizedBox.shrink();
                      }

                      final penutupData =
                          penutupSnapshot.data!.data() as Map<String, dynamic>?;

                      if (penutupData == null ||
                          penutupData['title'] == null ||
                          penutupData['kisah'] == null ||
                          penutupData['title'].toString().isEmpty ||
                          penutupData['kisah'].toString().isEmpty) {
                        return SizedBox.shrink();
                      }

                      final title = penutupData['title'] as String;
                      final kisah = penutupData['kisah'] as String;

                      return _buildClosingCard(title: title, kisah: kisah);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard({
    required String title,
    required String date,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFF5F5F5).withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          // Title
          Text(
            title,
            style: GoogleFonts.lobster(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: Color(0xFFF5F5F5),
              letterSpacing: 0.8,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4),

          // Date
          Text(
            date,
            style: GoogleFonts.roboto(
              fontSize: 11,
              color: Color(0xFFD4AF37),
              letterSpacing: 1.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 10),

          // Divider
          Container(height: 1, color: Color(0xFFF5F5F5).withOpacity(0.1)),

          SizedBox(height: 10),

          // Description
          Text(
            description,
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFFE0E0E0),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildClosingCard({required String title, required String kisah}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFD4AF37).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Title
          Text(
            title,
            style: GoogleFonts.lobster(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Color(0xFFD4AF37),
              letterSpacing: 1.0,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 10),

          // Divider
          Container(height: 1, color: Color(0xFFD4AF37).withOpacity(0.3)),

          SizedBox(height: 10),

          // Closing Text
          Text(
            kisah,
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFFE0E0E0),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
