import 'package:digitalinvitationaksala/data/wedding_data.dart';
import 'package:digitalinvitationaksala/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UcapanSection extends StatefulWidget {
  @override
  _UcapanSectionState createState() => _UcapanSectionState();
}

class _UcapanSectionState extends State<UcapanSection> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ucapanController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isSubmitting = false;
  String _selectedKehadiran = 'Hadir';

  @override
  void dispose() {
    _nameController.dispose();
    _ucapanController.dispose();
    super.dispose();
  }

  Future<void> _submitUcapan() async {
    if (_nameController.text.trim().isEmpty ||
        _ucapanController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mohon isi nama dan ucapan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _firestoreService.addUcapanWithKehadiran(
        _nameController.text.trim(),
        _ucapanController.text.trim(),
        _selectedKehadiran,
      );

      _nameController.clear();
      _ucapanController.clear();
      setState(() {
        _selectedKehadiran = 'Hadir';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ucapan berhasil dikirim'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim ucapan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Widget _buildKehadiranChip(String label, IconData icon) {
    final isSelected = _selectedKehadiran == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedKehadiran = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFFF5F5F5).withOpacity(0.15)
              : Color(0xFFF5F5F5).withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Color(0xFFF5F5F5).withOpacity(0.4)
                : Color(0xFFF5F5F5).withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Color(0xFFF5F5F5)),
            SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: Color(0xFFF5F5F5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUcapanItem(
    Map<String, dynamic> data, {
    bool showDivider = true,
  }) {
    final kehadiran = data['kehadiran'] ?? 'Hadir';
    final repliesData = data['replies'];
    final replies = repliesData is List ? repliesData : [];
    final timestamp = data['createdAt'] as Timestamp?;

    IconData statusIcon;
    Color statusColor;

    if (kehadiran == 'Hadir') {
      statusIcon = Icons.check_circle;
      statusColor = Colors.green;
    } else if (kehadiran == 'Tidak Hadir') {
      statusIcon = Icons.cancel;
      statusColor = Colors.red;
    } else {
      statusIcon = Icons.help;
      statusColor = Colors.orange;
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        (data['name'] ?? 'A')[0].toUpperCase(),
                        style: GoogleFonts.robotoSlab(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF5F5F5),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data['name'] ?? 'Anonymous',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFF5F5F5),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            Icon(statusIcon, color: statusColor, size: 18),
                          ],
                        ),

                        SizedBox(height: 4),

                        Text(
                          data['ucapan'] ?? '',
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFE0E0E0),
                            height: 1.4,
                          ),
                        ),

                        if (timestamp != null) ...[
                          SizedBox(height: 4),
                          Text(
                            _formatTimestamp(timestamp),
                            style: GoogleFonts.roboto(
                              fontSize: 10,
                              color: Color(0xFFE0E0E0).withOpacity(0.5),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              if (replies.isNotEmpty) ...[
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(left: 48),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color(0xFFF5F5F5).withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: replies.map((reply) {
                      if (reply is! Map) {
                        return SizedBox.shrink();
                      }

                      final replyData = reply as Map<String, dynamic>;
                      final replyText = replyData['text'] ?? '';
                      final replyTimestamp =
                          replyData['timestamp'] as Timestamp?;

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: replies.last == reply ? 0 : 8,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 14,
                              color: Color(0xFFF5F5F5).withOpacity(0.7),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    groomnickName + ' & ' + bridenickName,
                                    style: GoogleFonts.roboto(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFF5F5F5).withOpacity(0.7),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    replyText,
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: Color(0xFFE0E0E0),
                                      height: 1.3,
                                    ),
                                  ),
                                  if (replyTimestamp != null) ...[
                                    SizedBox(height: 3),
                                    Text(
                                      _formatTimestamp(replyTimestamp),
                                      style: GoogleFonts.roboto(
                                        fontSize: 10,
                                        color: Color(
                                          0xFFE0E0E0,
                                        ).withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF5F5F5).withOpacity(0.08),
            indent: 68,
          ),
      ],
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Text(
            'Ucapan & Doa',
            style: GoogleFonts.robotoSlab(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF5F5F5),
              letterSpacing: 0.5,
            ),
          ),

          SizedBox(height: 6),

          Text(
            'Berikan ucapan dan doa terbaik untuk kami',
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFFE0E0E0),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 24),

          // Form Input
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFF5F5F5).withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Input
                TextField(
                  controller: _nameController,
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    color: Color(0xFFF5F5F5),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Nama Anda',
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 13,
                      color: Color(0xFFE0E0E0).withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF5F5F5).withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color(0xFFF5F5F5).withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color(0xFFF5F5F5).withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color(0xFFF5F5F5).withOpacity(0.5),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                ),

                SizedBox(height: 12),

                // Konfirmasi Kehadiran Label
                Text(
                  'Konfirmasi Kehadiran',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFF5F5F5).withOpacity(0.8),
                  ),
                ),

                SizedBox(height: 8),

                // Kehadiran Options
                Row(
                  children: [
                    Expanded(
                      child: _buildKehadiranChip(
                        'Hadir',
                        Icons.check_circle_outline,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildKehadiranChip(
                        'Tidak Hadir',
                        Icons.cancel_outlined,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildKehadiranChip('Ragu', Icons.help_outline),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Ucapan Input
                TextField(
                  controller: _ucapanController,
                  maxLines: 3,
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    color: Color(0xFFF5F5F5),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Tulis ucapan dan doa Anda...',
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 13,
                      color: Color(0xFFE0E0E0).withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF5F5F5).withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color(0xFFF5F5F5).withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color(0xFFF5F5F5).withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color(0xFFF5F5F5).withOpacity(0.5),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitUcapan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF5F5F5).withOpacity(0.9),
                      foregroundColor: Color(0xFF1A1A1A),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF1A1A1A),
                              ),
                            ),
                          )
                        : Text(
                            'Kirim Ucapan',
                            style: GoogleFonts.roboto(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // List Ucapan dalam Satu Container
          StreamBuilder<QuerySnapshot>(
            stream: _firestoreService.getUcapanLimited(5),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFFF5F5F5).withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Terjadi kesalahan',
                    style: GoogleFonts.roboto(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFFF5F5F5).withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFF5F5F5),
                      ),
                    ),
                  ),
                );
              }

              final ucapanDocs = snapshot.data?.docs ?? [];

              if (ucapanDocs.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFFF5F5F5).withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Belum ada ucapan. Jadilah yang pertama!',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: Color(0xFFE0E0E0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFFF5F5F5).withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: List.generate(ucapanDocs.length, (index) {
                    final data =
                        ucapanDocs[index].data() as Map<String, dynamic>;
                    final isLast = index == ucapanDocs.length - 1;
                    return _buildUcapanItem(data, showDivider: !isLast);
                  }),
                ),
              );
            },
          ),

          SizedBox(height: 12),

          // Button Lihat Semua
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Color(0xFF1A1A1A),
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  minChildSize: 0.5,
                  maxChildSize: 0.9,
                  expand: false,
                  builder: (context, scrollController) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          // Handle
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                          SizedBox(height: 16),

                          Text(
                            'Semua Ucapan',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFF5F5F5),
                            ),
                          ),

                          SizedBox(height: 16),

                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _firestoreService.getAllUcapan(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFF5F5F5),
                                      ),
                                    ),
                                  );
                                }

                                final allUcapan = snapshot.data!.docs;

                                return Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF5F5F5).withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Color(0xFFF5F5F5).withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: allUcapan.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      final data =
                                          allUcapan[index].data()
                                              as Map<String, dynamic>;
                                      final isLast =
                                          index == allUcapan.length - 1;
                                      return _buildUcapanItem(
                                        data,
                                        showDivider: !isLast,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            child: Text(
              'Lihat Semua Ucapan',
              style: GoogleFonts.roboto(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFFF5F5F5),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
