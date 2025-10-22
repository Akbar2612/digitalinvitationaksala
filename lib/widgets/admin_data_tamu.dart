import 'package:digitalinvitationaksala/services/excel_services.dart' ;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/firestore_service.dart';


class AdminDataTamu extends StatefulWidget {
  final Color navyBlue;
  final Color lightBlue;
  final Color orange;
  final Color yellow;
  final Color lightGray;

  const AdminDataTamu({
    super.key,
    required this.navyBlue,
    required this.lightBlue,
    required this.orange,
    required this.yellow,
    required this.lightGray,
  });

  @override
  State<AdminDataTamu> createState() => _AdminDataTamuState();
}

class _AdminDataTamuState extends State<AdminDataTamu> {
  late final FirestoreService _firestoreService;
  late final ExcelService _excelService;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService();
    _excelService = ExcelService(_firestoreService);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with Export Button
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: widget.lightGray, width: 1.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DATA TAMU',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: widget.navyBlue,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    height: 3,
                    width: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [widget.orange, widget.yellow],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _isExporting ? null : _handleExportExcel,
                icon: _isExporting
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(Icons.download, size: 18),
                label: Text(
                  _isExporting ? 'Mengekspor...' : 'Export Excel',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ),
        
        // Data Table - Full Width
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestoreService.getGuests(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: widget.orange,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      SizedBox(height: 16),
                      Text(
                        'Terjadi kesalahan',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        snapshot.error.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Belum Ada Data Tamu',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Silakan tambah tamu terlebih dahulu',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              final guests = snapshot.data!.docs;

              return Container(
                width: double.infinity,
                color: Colors.grey[50],
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Table(
                            columnWidths: {
                              0: FixedColumnWidth(80),
                              1: FlexColumnWidth(2.5),
                              2: FlexColumnWidth(1.5),
                              3: FlexColumnWidth(2.5),
                              4: FixedColumnWidth(280),
                            },
                            border: TableBorder.all(
                              color: widget.lightGray,
                              width: 1,
                            ),
                            children: [
                              // Header Row
                              TableRow(
                                decoration: BoxDecoration(
                                  color: widget.navyBlue,
                                ),
                                children: [
                                  _buildHeaderCell('NO'),
                                  _buildHeaderCell('NAMA TAMU'),
                                  _buildHeaderCell('UNSUR'),
                                  _buildHeaderCell('ALAMAT'),
                                  _buildHeaderCell('AKSI'),
                                ],
                              ),
                              // Data Rows
                              ...guests.asMap().entries.map((entry) {
                                final index = entry.key;
                                final guest = entry.value;
                                final data = guest.data() as Map<String, dynamic>;
                                final isShared = data['isShared'] ?? false;

                                return TableRow(
                                  decoration: BoxDecoration(
                                    color: index % 2 == 0
                                        ? Colors.grey[50]
                                        : Colors.white,
                                  ),
                                  children: [
                                    _buildDataCell(
                                      Center(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: widget.lightBlue.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '${index + 1}',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              color: widget.lightBlue,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    _buildDataCell(
                                      Text(
                                        data['name'] ?? '',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: widget.navyBlue,
                                        ),
                                      ),
                                    ),
                                    _buildDataCell(
                                      Text(
                                        data['unsur'] ?? '-',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: widget.navyBlue,
                                        ),
                                      ),
                                    ),
                                    _buildDataCell(
                                      Text(
                                        data['address'] ?? '-',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: widget.navyBlue,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    _buildDataCell(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Status Badge
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isShared
                                                  ? Color(0xFF10B981).withOpacity(0.1)
                                                  : Colors.red.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  isShared ? Icons.check_circle : Icons.cancel,
                                                  size: 14,
                                                  color: isShared
                                                      ? Color(0xFF10B981)
                                                      : Colors.red,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  isShared ? 'Terkirim' : 'Belum',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: isShared
                                                        ? Color(0xFF10B981)
                                                        : Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          // Copy Link Button
                                          _buildActionButton(
                                            icon: Icons.copy,
                                            color: widget.lightBlue,
                                            tooltip: 'Salin Link',
                                            onPressed: () => _handleCopyLink(data['link']),
                                          ),
                                          SizedBox(width: 4),
                                          _buildActionButton(
                                            icon: Icons.send,
                                            color: Color(0xFF25D366),
                                            tooltip: 'Kirim WhatsApp',
                                            onPressed: () => _handleShareWhatsApp(guest),
                                          ),
                                          SizedBox(width: 4),
                                          _buildActionButton(
                                            icon: Icons.delete,
                                            color: Colors.red[400]!,
                                            tooltip: 'Hapus',
                                            onPressed: () => _showDeleteConfirmation(guest.id),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(Widget child) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: child,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
      ),
    );
  }

  Future<void> _handleExportExcel() async {
    if (_isExporting) return;

    setState(() => _isExporting = true);

    try {
      // Get data from Firestore
      final snapshot = await _firestoreService.getGuests().first;
      
      if (snapshot.docs.isEmpty) {
        _showErrorSnackbar('Tidak ada data untuk diekspor');
        setState(() => _isExporting = false);
        return;
      }

      // Map data
      final guests = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'name': data['name'] ?? '',
          'unsur': data['unsur'] ?? '',
          'address': data['address'] ?? '',
          'link': data['link'] ?? '',
          'isShared': data['isShared'] ?? false,
        };
      }).toList();

      // Export to Excel
      final result = await _excelService.exportToExcel(guests);
      
      if (result != null && result.isNotEmpty) {
        _showSuccessSnackbar('Data berhasil diekspor!\nTotal: ${guests.length} tamu');
      } else {
        _showErrorSnackbar('Gagal mengekspor data');
      }
    } catch (e) {
      print('Error exporting: $e');
      _showErrorSnackbar('Terjadi kesalahan: ${e.toString()}');
    } finally {
      setState(() => _isExporting = false);
    }
  }

  void _handleCopyLink(String? link) {
    if (link != null && link.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: link));
      _showSuccessSnackbar('Link berhasil disalin ke clipboard');
    } else {
      _showErrorSnackbar('Link tidak tersedia');
    }
  }

  Future<void> _handleShareWhatsApp(QueryDocumentSnapshot guest) async {
    final data = guest.data() as Map<String, dynamic>;
    final link = data['link'];
    final name = data['name'];
    
    if (link == null || link.isEmpty) {
      _showErrorSnackbar('Link tidak tersedia');
      return;
    }

    final message = '''
Assalamu'alaikum Warahmatullahi Wabarakatuh,

Dengan penuh rasa hormat, kami mengundang Bapak/Ibu/Saudara/i *$name* untuk hadir dan memberikan doa restu pada acara pernikahan Akbar & Wulan.

💌 Link undangan digital: $link
(Untuk hasil terbaik, silakan buka menggunakan Google Chrome)

Kehadiran Bapak/Ibu/Saudara/i akan menjadi kebahagiaan tersendiri bagi kami.

Mohon maaf, undangan ini hanya kami bagikan melalui pesan ini. Terima kasih atas perhatian dan kesediaannya.

Wassalamu'alaikum Warahmatullahi Wabarakatuh

Salam hormat,
Akbar & Wulan
    ''';
    
    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl = 'https://wa.me/?text=$encodedMessage';
    final uri = Uri.parse(whatsappUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        
        // Update status isShared
        await _firestoreService.updateGuestSharedStatus(guest.id, true);
        _showSuccessSnackbar('Berhasil membuka WhatsApp');
      } else {
        _showErrorSnackbar('Tidak dapat membuka WhatsApp');
      }
    } catch (e) {
      _showErrorSnackbar('Gagal membuka WhatsApp: ${e.toString()}');
    }
  }

  void _showDeleteConfirmation(String guestId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red[400], size: 28),
            SizedBox(width: 12),
            Text(
              'Hapus Tamu',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: widget.navyBlue,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus tamu ini? Tindakan ini tidak dapat dibatalkan.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: widget.navyBlue,
            ),
          
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _firestoreService.deleteGuest(guestId);
                Navigator.pop(context);
                _showSuccessSnackbar('Tamu berhasil dihapus');
              } catch (e) {
                Navigator.pop(context);
                _showErrorSnackbar('Gagal menghapus tamu: ${e.toString()}');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        backgroundColor: Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 4),
      ),
    );
  }
}