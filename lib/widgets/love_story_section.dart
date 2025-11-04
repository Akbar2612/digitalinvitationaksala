// love_story_section.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../services/firestore_service.dart';

class LoveStorySection extends StatefulWidget {
  @override
  State<LoveStorySection> createState() => _LoveStorySectionState();
}

class _LoveStorySectionState extends State<LoveStorySection> {
  final FirestoreService _firestoreService = FirestoreService();
  int _currentPage = 0;
  late CarouselSliderController _carouselController;

  List<Widget> _carouselItems = [];
  int _initialIndex = 0;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
    _loadDataOnce(); // Load sekali
  }

  Future<void> _loadDataOnce() async {
    try {
      final snapshot = await _firestoreService.getAllKisahCinta().first;
      final stories = snapshot.docs;

      // Sort berdasarkan createdAt
      stories.sort((a, b) {
        final aData = a.data() as Map<String, dynamic>;
        final bData = b.data() as Map<String, dynamic>;
        final aTs = aData['createdAt'] as Timestamp?;
        final bTs = bData['createdAt'] as Timestamp?;
        if (aTs == null) return 1;
        if (bTs == null) return -1;
        return aTs.compareTo(bTs);
      });

      final penutupDoc = await _firestoreService.getKisahCintaPenutup();
      final hasClosing = penutupDoc.exists && penutupDoc.data() != null;
      final closingData = hasClosing
          ? penutupDoc.data() as Map<String, dynamic>?
          : null;

      final List<Widget> items = [];
      int firstDateIndex = 0;

      // Cari "Kencan Pertama"
      for (int i = 0; i < stories.length; i++) {
        final data = stories[i].data() as Map<String, dynamic>;
        final title = data['judul']?.toString() ?? '';
        if (title.toLowerCase().contains('kencan pertama') ||
            title.toLowerCase().contains('pertemuan pertama')) {
          firstDateIndex = i;
        }
        items.add(
          _buildStoryCard(
            title: title,
            date: data['tanggal']?.toString() ?? '',
            story: data['cerita']?.toString() ?? '',
            isClosing: false,
          ),
        );
      }

      // Tambah penutup
      if (hasClosing && closingData != null) {
        items.add(
          _buildStoryCard(
            title: closingData['title']?.toString() ?? 'Penutup',
            date: '',
            story: closingData['kisah']?.toString() ?? '',
            isClosing: true,
          ),
        );
      }

      if (mounted) {
        setState(() {
          _carouselItems = items;
          _initialIndex = firstDateIndex;
          _dataLoaded = true;
        });

        // PAKSA TAMPILAN AWAL KE "KENCAN PERTAMA" — HANYA SEKALI
        if (_initialIndex > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _carouselController.animateToPage(
              _initialIndex,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        }
      }
    } catch (e) {
      print("Error loading love story: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_dataLoaded || _carouselItems.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
      );
    }

    final totalItems = _carouselItems.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
      child: Column(
        children: [
          // Header
          Text(
            'Kisah Cinta Kami',
            style: GoogleFonts.lobster(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: const Color(0xFFF5F5F5),
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            width: 80,
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD4AF37).withOpacity(0),
                  const Color(0xFFD4AF37),
                  const Color(0xFFD4AF37).withOpacity(0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Perjalanan cinta yang indah',
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: const Color(0xFFB0B0B0),
              letterSpacing: 0.6,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // CAROUSEL
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.62,
            child: Column(
              children: [
                // CAROUSEL — initialPage = 0 (tapi akan dipindah pakai controller)
                CarouselSlider(
                  carouselController: _carouselController,
                  items: _carouselItems,
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.52,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 6),
                    enlargeCenterPage: true,
                    viewportFraction: 0.85,
                    aspectRatio: 0.9,
                    enableInfiniteScroll: totalItems > 1,
                    padEnds: true,
                    initialPage:
                        0, // Tetap 0, kita paksa pindah pakai controller
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 12),

                if (totalItems > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalItems, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? const Color(0xFFD4AF37)
                              : const Color(0xFFD4AF37).withOpacity(0.4),
                        ),
                      );
                    }),
                  ),

                const SizedBox(height: 12),

                Text(
                  'Geser untuk melihat kisah berikutnya',
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    color: const Color(0xFFB0B0B0),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard({
    required String title,
    required String date,
    required String story,
    required bool isClosing,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isClosing
              ? const Color(0xFFD4AF37).withOpacity(0.4)
              : const Color(0xFFF5F5F5).withOpacity(0.15),
          width: isClosing ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.lobster(
              fontSize: isClosing ? 22 : 20,
              fontWeight: FontWeight.w300,
              color: isClosing
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFFF5F5F5),
              letterSpacing: 1.0,
            ),
            textAlign: TextAlign.center,
          ),

          if (date.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              date,
              style: GoogleFonts.roboto(
                fontSize: 11,
                color: const Color(0xFFD4AF37),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ],

          const SizedBox(height: 16),
          Container(
            height: 1,
            color: isClosing
                ? const Color(0xFFD4AF37).withOpacity(0.4)
                : const Color(0xFFF5F5F5).withOpacity(0.15),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: AutoSizeText(
              story,
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: const Color(0xFFE0E0E0),
                height: 1.7,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
              minFontSize: 6,
              maxLines: 200,
              overflow: TextOverflow.visible,
              stepGranularity: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
