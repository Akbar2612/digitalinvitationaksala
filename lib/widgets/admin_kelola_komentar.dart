import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class AdminKelolaKomentar extends StatefulWidget {
  final Color navyBlue;
  final Color lightBlue;
  final Color orange;
  final Color yellow;
  final Color lightGray;

  const AdminKelolaKomentar({
    super.key,
    required this.navyBlue,
    required this.lightBlue,
    required this.orange,
    required this.yellow,
    required this.lightGray,
  });

  @override
  State<AdminKelolaKomentar> createState() => _AdminKelolaKomentarState();
}

class _AdminKelolaKomentarState extends State<AdminKelolaKomentar> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _filterKehadiran = 'Semua';
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Column(
      children: [
        _buildHeaderSection(isMobile),
        SizedBox(height: isMobile ? 16 : 24),
        _buildFilterSection(isMobile),
        SizedBox(height: isMobile ? 16 : 24),
        Expanded(child: _buildKomentarList(isMobile)),
      ],
    );
  }

  Widget _buildHeaderSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.lightBlue.withOpacity(0.1),
            widget.orange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.lightBlue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 8 : 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.lightBlue,
                      widget.lightBlue.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: widget.lightBlue.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: isMobile ? 20 : 24,
                ),
              ),
              SizedBox(width: isMobile ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KELOLA KOMENTAR',
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 16 : 20,
                        fontWeight: FontWeight.w700,
                        color: widget.navyBlue,
                      ),
                    ),
                    if (!isMobile) ...[
                      SizedBox(height: 4),
                      Text(
                        'Kelola komentar dan ucapan dari tamu undangan',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 12 : 20),
          _buildStatistikCards(isMobile),
        ],
      ),
    );
  }

  Widget _buildStatistikCards(bool isMobile) {
    return StreamBuilder<Map<String, int>>(
      stream: _getKehadiranStatsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final stats = snapshot.data!;
        final total = stats['total'] ?? 0;
        final hadir = stats['hadir'] ?? 0;
        final tidakHadir = stats['tidakHadir'] ?? 0;
        final ragu = stats['ragu'] ?? 0;

        if (isMobile) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total',
                      total.toString(),
                      Icons.chat_bubble,
                      widget.navyBlue,
                      isMobile,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      'Hadir',
                      hadir.toString(),
                      Icons.check_circle,
                      Colors.green,
                      isMobile,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Tidak',
                      tidakHadir.toString(),
                      Icons.cancel,
                      Colors.red,
                      isMobile,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      'Ragu',
                      ragu.toString(),
                      Icons.help,
                      widget.orange,
                      isMobile,
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Komentar',
                total.toString(),
                Icons.chat_bubble,
                widget.navyBlue,
                isMobile,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Hadir',
                hadir.toString(),
                Icons.check_circle,
                Colors.green,
                isMobile,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Tidak Hadir',
                tidakHadir.toString(),
                Icons.cancel,
                Colors.red,
                isMobile,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Ragu',
                ragu.toString(),
                Icons.help,
                widget.orange,
                isMobile,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 10 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: widget.lightGray),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: isMobile ? 20 : 28),
          SizedBox(height: isMobile ? 4 : 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 9 : 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child: isMobile
          ? Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) =>
                      setState(() => _searchQuery = value.toLowerCase()),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: widget.navyBlue,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari nama atau ucapan...',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: widget.lightBlue,
                      size: 18,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: widget.lightGray,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: widget.lightGray,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: widget.lightBlue, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.lightBlue.withOpacity(0.1),
                        widget.orange.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.lightBlue.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _filterKehadiran,
                    isExpanded: true,
                    underline: SizedBox(),
                    icon: Icon(
                      Icons.filter_list,
                      color: widget.lightBlue,
                      size: 18,
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: widget.navyBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    dropdownColor: Colors.white,
                    items: ['Semua', 'Hadir', 'Tidak Hadir', 'Ragu']
                        .map(
                          (filter) => DropdownMenuItem(
                            value: filter,
                            child: Text(filter),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _filterKehadiran = value!),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) =>
                        setState(() => _searchQuery = value.toLowerCase()),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: widget.navyBlue,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari nama atau ucapan...',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                      prefixIcon: Icon(
                        Icons.search,
                        color: widget.lightBlue,
                        size: 20,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: widget.lightGray,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: widget.lightGray,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: widget.lightBlue,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.lightBlue.withOpacity(0.1),
                        widget.orange.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: widget.lightBlue.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _filterKehadiran,
                    underline: SizedBox(),
                    icon: Icon(
                      Icons.filter_list,
                      color: widget.lightBlue,
                      size: 20,
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: widget.navyBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    dropdownColor: Colors.white,
                    items: ['Semua', 'Hadir', 'Tidak Hadir', 'Ragu']
                        .map(
                          (filter) => DropdownMenuItem(
                            value: filter,
                            child: Text(filter),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _filterKehadiran = value!),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildKomentarList(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getAllUcapan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: widget.lightBlue),
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
                    'Terjadi kesalahan saat memuat data',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
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
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada komentar',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Komentar dari tamu akan muncul di sini',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            );
          }

          var filteredDocs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final name = (data['name'] ?? '').toString().toLowerCase();
            final ucapan = (data['ucapan'] ?? '').toString().toLowerCase();
            final kehadiran = data['kehadiran'] ?? 'Hadir';

            bool matchSearch =
                _searchQuery.isEmpty ||
                name.contains(_searchQuery) ||
                ucapan.contains(_searchQuery);
            bool matchFilter =
                _filterKehadiran == 'Semua' || kehadiran == _filterKehadiran;

            return matchSearch && matchFilter;
          }).toList();

          if (filteredDocs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                  SizedBox(height: 16),
                  Text(
                    'Tidak ada hasil',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.only(bottom: 24),
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              final doc = filteredDocs[index];
              final data = doc.data() as Map<String, dynamic>;
              return _buildCompactKomentarCard(doc.id, data, isMobile);
            },
          );
        },
      ),
    );
  }

  Widget _buildCompactKomentarCard(
    String docId,
    Map<String, dynamic> data,
    bool isMobile,
  ) {
    final name = data['name'] ?? 'Anonim';
    final ucapan = data['ucapan'] ?? '';
    final kehadiran = data['kehadiran'] ?? 'Hadir';
    final timestamp = data['createdAt'] as Timestamp?;
    final replies = data['replies'] as List<dynamic>? ?? [];

    Color kehadiranColor;
    IconData kehadiranIcon;

    switch (kehadiran) {
      case 'Hadir':
        kehadiranColor = Colors.green;
        kehadiranIcon = Icons.check_circle;
        break;
      case 'Tidak Hadir':
        kehadiranColor = Colors.red;
        kehadiranIcon = Icons.cancel;
        break;
      default:
        kehadiranColor = widget.orange;
        kehadiranIcon = Icons.help;
    }

    if (isMobile) {
      return Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: widget.lightGray, width: 1.5),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.lightBlue,
                          widget.lightBlue.withOpacity(0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, color: Colors.white, size: 16),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: widget.navyBlue,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: kehadiranColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: kehadiranColor.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    kehadiranIcon,
                                    size: 10,
                                    color: kehadiranColor,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    kehadiran,
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: kehadiranColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (timestamp != null)
                          Text(
                            _formatTimestamp(timestamp),
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        SizedBox(height: 6),
                        Text(
                          ucapan,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (replies.isNotEmpty) ...[
                          SizedBox(height: 6),
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: widget.lightBlue.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.reply,
                                  size: 10,
                                  color: widget.lightBlue,
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${replies.length} balasan admin',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: widget.lightBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: widget.lightGray.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showReplyDialog(docId, name, ucapan),
                    icon: Icon(Icons.reply, size: 14),
                    label: Text(
                      'Balas',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: widget.lightBlue,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: () => _showDeleteConfirmation(docId, name),
                    icon: Icon(Icons.delete_outline, size: 14),
                    label: Text(
                      'Hapus',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Desktop - Compact 1 Row
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: widget.lightGray, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.lightBlue, widget.lightBlue.withOpacity(0.7)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
            SizedBox(width: 12),

            // Nama & Time
            SizedBox(
              width: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: widget.navyBlue,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (timestamp != null)
                    Text(
                      _formatTimestamp(timestamp),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(width: 12),

            // Ucapan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ucapan,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (replies.isNotEmpty)
                    Text(
                      '${replies.length} balasan',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: widget.lightBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(width: 12),

            // Status Kehadiran
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: kehadiranColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kehadiranColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(kehadiranIcon, size: 12, color: kehadiranColor),
                  SizedBox(width: 6),
                  Text(
                    kehadiran,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: kehadiranColor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 12),

            // Action Buttons
            Row(
              children: [
                IconButton(
                  onPressed: () => _showReplyDialog(docId, name, ucapan),
                  icon: Icon(Icons.reply, size: 18),
                  tooltip: 'Balas',
                  color: widget.lightBlue,
                  padding: EdgeInsets.all(8),
                  constraints: BoxConstraints(),
                ),
                SizedBox(width: 4),
                IconButton(
                  onPressed: () => _showDeleteConfirmation(docId, name),
                  icon: Icon(Icons.delete_outline, size: 18),
                  tooltip: 'Hapus',
                  color: Colors.red,
                  padding: EdgeInsets.all(8),
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReplyDialog(String docId, String name, String ucapan) {
    final TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.lightBlue.withOpacity(0.1),
                widget.orange.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.lightBlue,
                      widget.lightBlue.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: widget.lightBlue.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(Icons.reply, color: Colors.white, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'Balas Komentar',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: widget.navyBlue,
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.lightGray.withOpacity(0.3),
                      widget.lightBlue.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: widget.lightBlue.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, size: 16, color: widget.lightBlue),
                        SizedBox(width: 6),
                        Text(
                          'Dari: $name',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: widget.navyBlue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      ucapan,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Tulis balasan Anda:',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: widget.navyBlue,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: replyController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'Terima kasih atas ucapan dan doa restu dari $name...',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[400],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: widget.lightGray),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: widget.lightGray, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: widget.lightBlue, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: EdgeInsets.all(12),
                ),
                style: GoogleFonts.poppins(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              replyController.dispose();
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: widget.lightGray, width: 1.5),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final replyText = replyController.text.trim();
              if (replyText.isEmpty) {
                _showErrorSnackbar('Balasan tidak boleh kosong');
                return;
              }

              try {
                await _firestoreService.addReplyToUcapan(docId, replyText);
                replyController.dispose();
                Navigator.pop(context);
                _showSuccessSnackbar('Balasan berhasil dikirim!');
              } catch (e) {
                _showErrorSnackbar('Gagal mengirim balasan: ${e.toString()}');
              }
            },
            icon: Icon(Icons.send, size: 16),
            label: Text(
              'Kirim Balasan',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.lightBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              shadowColor: widget.lightBlue.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String docId, String name) {
    showDialog(
      context: context,
      barrierColor: widget.navyBlue.withOpacity(0.3),
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red.withOpacity(0.1),
                Colors.orange.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Konfirmasi Hapus',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: widget.navyBlue,
                ),
              ),
            ],
          ),
        ),
        content: RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            children: [
              TextSpan(
                text: 'Apakah Anda yakin ingin menghapus komentar dari ',
              ),
              TextSpan(
                text: name,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: widget.navyBlue,
                ),
              ),
              TextSpan(text: '? Tindakan ini tidak dapat dibatalkan.'),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: widget.lightGray, width: 1.5),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteKomentar(docId, name);
            },
            icon: Icon(Icons.delete_forever, size: 18),
            label: Text(
              'Hapus',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              shadowColor: Colors.red.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteKomentar(String docId, String name) async {
    setState(() => _isLoading = true);

    try {
      await _firestoreService.deleteUcapan(docId);
      _showSuccessSnackbar('Komentar dari $name berhasil dihapus');
      print("✅ Komentar berhasil dihapus: $docId");
    } catch (e, stack) {
      print("❌ Gagal menghapus komentar: $e");
      print(stack);
      _showErrorSnackbar('Gagal menghapus komentar: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }

  Stream<Map<String, int>> _getKehadiranStatsStream() {
    return _firestoreService.getAllUcapan().map((snapshot) {
      int hadir = 0;
      int tidakHadir = 0;
      int ragu = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
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
        'total': snapshot.docs.length,
        'hadir': hadir,
        'tidakHadir': tidakHadir,
        'ragu': ragu,
      };
    });
  }

  void _showSuccessSnackbar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(fontSize: 13)),
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
        content: Text(message, style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 4),
      ),
    );
  }
}
