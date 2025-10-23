import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class AdminKisahCinta extends StatefulWidget {
  final Color navyBlue;
  final Color lightBlue;
  final Color orange;
  final Color yellow;
  final Color lightGray;

  const AdminKisahCinta({
    super.key,
    required this.navyBlue,
    required this.lightBlue,
    required this.orange,
    required this.yellow,
    required this.lightGray,
  });

  @override
  State<AdminKisahCinta> createState() => _AdminKisahCintaState();
}

class _AdminKisahCintaState extends State<AdminKisahCinta> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeaderSection(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildSearchSection(),
        ),
        const SizedBox(height: 24),
        Expanded(child: _buildKisahCintaList()),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(24),
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
                padding: const EdgeInsets.all(12),
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
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KELOLA KISAH CINTA',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: widget.navyBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tambahkan dan kelola momen spesial perjalanan cinta Anda',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatistikCard(),
        ],
      ),
    );
  }

  Widget _buildStatistikCard() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getAllKisahCinta(),
      builder: (context, snapshot) {
        int total = 0;
        if (snapshot.hasData) {
          total = snapshot.data!.docs.length;
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: widget.lightGray),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.timeline, color: widget.orange, size: 28),
              const SizedBox(width: 12),
              Text(
                total.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: widget.orange,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Total Momen Kisah Cinta',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchSection() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
            style: GoogleFonts.poppins(fontSize: 14, color: widget.navyBlue),
            decoration: InputDecoration(
              hintText: 'Cari judul atau cerita...',
              hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
              prefixIcon: Icon(Icons.search, color: widget.lightBlue, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: widget.lightGray, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: widget.lightGray, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: widget.lightBlue, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () => _showFormDialog(),
          icon: const Icon(Icons.add, size: 18),
          label: Text(
            'Tambah',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.lightBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () => _showPenutupDialog(),
          icon: const Icon(Icons.auto_stories, size: 18),
          label: Text(
            'Penutup',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildKisahCintaList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getAllKisahCinta(),
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
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi kesalahan saat memuat data',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.red[400],
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
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada kisah cinta',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan momen spesial perjalanan cinta Anda',
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
            final judul = (data['judul'] ?? '').toString().toLowerCase();
            final cerita = (data['cerita'] ?? '').toString().toLowerCase();
            return _searchQuery.isEmpty ||
                judul.contains(_searchQuery) ||
                cerita.contains(_searchQuery);
          }).toList();

          if (filteredDocs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
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
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              final doc = filteredDocs[index];
              final data = doc.data() as Map<String, dynamic>;
              return _buildKisahCintaCard(doc.id, data);
            },
          );
        },
      ),
    );
  }

  Widget _buildKisahCintaCard(String docId, Map<String, dynamic> data) {
    final judul = data['judul'] ?? '';
    final tanggal = data['tanggal'] ?? '';
    final cerita = data['cerita'] ?? '';
    final timestamp = data['createdAt'] as Timestamp?;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.lightGray, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.orange.withOpacity(0.05),
                  widget.lightBlue.withOpacity(0.02),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [widget.orange, widget.orange.withOpacity(0.7)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        judul,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: widget.navyBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            tanggal,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (timestamp != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.lightBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatTimestamp(timestamp),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              cerita,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: widget.lightGray.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showFormDialog(docId: docId, data: data),
                  icon: const Icon(Icons.edit, size: 16),
                  label: Text(
                    'Edit',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: widget.lightBlue,
                    side: BorderSide(color: widget.lightBlue, width: 1.5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showDeleteConfirmation(docId, judul),
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: Text(
                    'Hapus',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFormDialog({String? docId, Map<String, dynamic>? data}) {
    final judulController = TextEditingController(text: data?['judul'] ?? '');
    final tanggalController = TextEditingController(
      text: data?['tanggal'] ?? '',
    );
    final ceritaController = TextEditingController(text: data?['cerita'] ?? '');
    final isEditing = docId != null;
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 500,
              constraints: const BoxConstraints(maxHeight: 600),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      border: Border(
                        bottom: BorderSide(color: widget.lightGray),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isEditing ? Icons.edit : Icons.add_circle_outline,
                          color: widget.lightBlue,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isEditing ? 'Edit Kisah Cinta' : 'Tambah Kisah Cinta',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: widget.navyBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDialogTextField(
                            controller: judulController,
                            label: 'Judul Momen',
                            hint: 'Contoh: Pertemuan Pertama, Lamaran, dll',
                            icon: Icons.title,
                          ),
                          const SizedBox(height: 16),
                          _buildDialogTextField(
                            controller: tanggalController,
                            label: 'Tanggal',
                            hint: 'Contoh: 14 Februari 2020',
                            icon: Icons.calendar_today,
                          ),
                          const SizedBox(height: 16),
                          _buildDialogTextField(
                            controller: ceritaController,
                            label: 'Cerita',
                            hint: 'Tuliskan cerita momen spesial Anda...',
                            icon: Icons.description,
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      border: Border(top: BorderSide(color: widget.lightGray)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () => Navigator.pop(context),
                          child: Text(
                            'Batal',
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  final judul = judulController.text.trim();
                                  final tanggal = tanggalController.text.trim();
                                  final cerita = ceritaController.text.trim();

                                  if (judul.isEmpty ||
                                      tanggal.isEmpty ||
                                      cerita.isEmpty) {
                                    _showErrorSnackbar(
                                      'Semua field harus diisi!',
                                    );
                                    return;
                                  }

                                  setDialogState(() => isLoading = true);

                                  try {
                                    if (isEditing) {
                                      await _firestoreService.updateKisahCinta(
                                        docId,
                                        judul,
                                        tanggal,
                                        cerita,
                                      );
                                      _showSuccessSnackbar(
                                        'Kisah cinta berhasil diupdate!',
                                      );
                                    } else {
                                      await _firestoreService.addKisahCinta(
                                        judul,
                                        tanggal,
                                        cerita,
                                      );
                                      _showSuccessSnackbar(
                                        'Kisah cinta berhasil ditambahkan!',
                                      );
                                    }
                                    Navigator.pop(context);
                                  } catch (e) {
                                    _showErrorSnackbar(
                                      'Gagal menyimpan: ${e.toString()}',
                                    );
                                  } finally {
                                    setDialogState(() => isLoading = false);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.lightBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  isEditing ? 'Update' : 'Simpan',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPenutupDialog() {
    final titleController = TextEditingController();
    final kisahController = TextEditingController();
    bool isLoading = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          // Load data setelah dialog muncul
          if (isLoading) {
            _firestoreService
                .getKisahCintaPenutup()
                .then((penutupDoc) {
                  if (penutupDoc.exists) {
                    final penutupData =
                        penutupDoc.data() as Map<String, dynamic>?;
                    titleController.text = penutupData?['title'] ?? '';
                    kisahController.text = penutupData?['kisah'] ?? '';
                  }
                  setDialogState(() => isLoading = false);
                })
                .catchError((error) {
                  print('Error loading penutup: $error');
                  setDialogState(() => isLoading = false);
                });
          }

          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 500,
              constraints: const BoxConstraints(maxHeight: 600),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      border: Border(
                        bottom: BorderSide(color: widget.lightGray),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_stories,
                          color: widget.orange,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Kisah Cinta Penutup',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: widget.navyBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDialogTextField(
                                  controller: titleController,
                                  label: 'Judul Penutup',
                                  hint: 'Contoh: Selamanya...',
                                  icon: Icons.title,
                                ),
                                const SizedBox(height: 16),
                                _buildDialogTextField(
                                  controller: kisahController,
                                  label: 'Kisah Penutup',
                                  hint:
                                      'Tuliskan kata-kata penutup yang indah...',
                                  icon: Icons.description,
                                  maxLines: 8,
                                ),
                              ],
                            ),
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      border: Border(top: BorderSide(color: widget.lightGray)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () => Navigator.pop(context),
                          child: Text(
                            'Batal',
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  final title = titleController.text.trim();
                                  final kisah = kisahController.text.trim();

                                  if (title.isEmpty || kisah.isEmpty) {
                                    _showErrorSnackbar(
                                      'Semua field harus diisi!',
                                    );
                                    return;
                                  }

                                  setDialogState(() => isLoading = true);

                                  try {
                                    await _firestoreService
                                        .setKisahCintaPenutup(title, kisah);
                                    if (!mounted) return;
                                    _showSuccessSnackbar(
                                      'Kisah cinta penutup berhasil disimpan!',
                                    );
                                    Navigator.pop(context);
                                  } catch (e) {
                                    if (!mounted) return;
                                    _showErrorSnackbar(
                                      'Gagal menyimpan: ${e.toString()}',
                                    );
                                  } finally {
                                    if (mounted) {
                                      setDialogState(() => isLoading = false);
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Simpan',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: widget.navyBlue,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.poppins(fontSize: 14, color: widget.navyBlue),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: 13,
            ),
            prefixIcon: Icon(icon, color: widget.lightBlue, size: 20),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.lightGray, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.lightGray, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.lightBlue, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(String docId, String judul) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 12),
            Text(
              'Konfirmasi Hapus',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: widget.navyBlue,
              ),
            ),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            children: [
              const TextSpan(
                text: 'Apakah Anda yakin ingin menghapus kisah cinta "',
              ),
              TextSpan(
                text: judul,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const TextSpan(text: '"? Tindakan ini tidak dapat dibatalkan.'),
            ],
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
              Navigator.pop(context);
              await _deleteKisahCinta(docId, judul);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteKisahCinta(String docId, String judul) async {
    try {
      await _firestoreService.deleteKisahCinta(docId);
      _showSuccessSnackbar('Kisah cinta "$judul" berhasil dihapus');
    } catch (e) {
      _showErrorSnackbar('Gagal menghapus: ${e.toString()}');
    }
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

  void _showSuccessSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
