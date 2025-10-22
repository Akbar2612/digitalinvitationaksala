import 'package:digitalinvitationaksala/services/excel_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/firestore_service.dart';

class AdminTambahTamu extends StatefulWidget {
  final Color navyBlue;
  final Color lightBlue;
  final Color orange;
  final Color yellow;
  final Color lightGray;

  const AdminTambahTamu({
    super.key,
    required this.navyBlue,
    required this.lightBlue,
    required this.orange,
    required this.yellow,
    required this.lightGray,
  });

  @override
  State<AdminTambahTamu> createState() => _AdminTambahTamuState();
}

class _AdminTambahTamuState extends State<AdminTambahTamu> {
  final _guestNameController = TextEditingController();
  final _unsurController = TextEditingController();
  final _addressController = TextEditingController();

  late FirestoreService _firestoreService;
  late ExcelService _excelService;

  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      print("🔧 Inisialisasi services...");
      
      // ✅ Inisialisasi FirestoreService
      _firestoreService = FirestoreService();
      _excelService = ExcelService(_firestoreService);
      
      setState(() {
        _isInitialized = true;
      });
      
      print("✅ Services berhasil diinisialisasi");
    } catch (e, stack) {
      print("❌ Gagal inisialisasi services: $e");
      print(stack);
      
      if (mounted) {
        _showErrorSnackbar('Gagal inisialisasi: $e');
      }
    }
  }

  @override
  void dispose() {
    _guestNameController.dispose();
    _unsurController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Tampilkan loading saat services belum ready
    if (!_isInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: widget.lightBlue),
            const SizedBox(height: 16),
            Text(
              'Memuat...',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: widget.navyBlue,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INPUT DATA TAMU',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: widget.navyBlue,
            ),
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 24),

          // Form Input Manual
          _buildFormInput(),

          const SizedBox(height: 32),

          // Import Export Section
          _buildImportExportSection(),
        ],
      ),
    );
  }

  Widget _buildFormInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.lightGray, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Input Manual',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: widget.navyBlue,
            ),
          ),
          const SizedBox(height: 20),
          _buildInputField(
            controller: _guestNameController,
            label: 'NAMA TAMU *',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _unsurController,
            label: 'UNSUR',
            icon: Icons.group_outlined,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _addressController,
            label: 'ALAMAT',
            icon: Icons.location_on_outlined,
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleAddGuest,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.navyBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_circle_outline, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'TAMBAH TAMU',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportExportSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Icon(Icons.upload_file, color: widget.lightBlue, size: 24),
              const SizedBox(width: 12),
              Text(
                'Import/Export Excel',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: widget.navyBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Import data tamu dalam jumlah banyak menggunakan file Excel',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _handleDownloadTemplate,
                  icon: const Icon(Icons.download, size: 18),
                  label: Text(
                    'Download\nTemplate',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: widget.navyBlue,
                    side: BorderSide(color: widget.navyBlue, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleImportExcel,
                  icon: const Icon(Icons.cloud_upload, size: 18),
                  label: Text(
                    'Import\nExcel',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
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
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(icon, color: widget.lightBlue, size: 20),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  // ===== HANDLERS =====

  Future<void> _handleAddGuest() async {
    if (_guestNameController.text.trim().isEmpty) {
      _showErrorSnackbar('Nama tamu wajib diisi');
      return;
    }

    setState(() => _isLoading = true);

    try {
      print("➕ Menambahkan tamu: ${_guestNameController.text.trim()}");
      
      await _firestoreService.addGuest(
        _guestNameController.text.trim(),
        _unsurController.text.trim(),
        _addressController.text.trim(),
      );

      _guestNameController.clear();
      _unsurController.clear();
      _addressController.clear();

      _showSuccessSnackbar('Tamu berhasil ditambahkan!');
      print("✅ Tamu berhasil ditambahkan ke Firestore");
    } catch (e, stack) {
      print("❌ Gagal menambahkan tamu: $e");
      print(stack);
      _showErrorSnackbar('Gagal menambahkan tamu: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleDownloadTemplate() async {
    setState(() => _isLoading = true);

    try {
      print("⬇️ Mengunduh template Excel...");
      final path = await _excelService.downloadTemplate();
      print("✅ Template berhasil diunduh ke: $path");
      
      if (mounted) {
        _showSuccessSnackbar('Template berhasil diunduh ke:\n$path');
      }
    } catch (e, stack) {
      print("❌ Gagal download template: $e");
      print(stack);
      
      if (mounted) {
        _showErrorSnackbar('Gagal mengunduh template: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

 Future<void> _handleImportExcel() async {
  if (!_isInitialized) {
    _showErrorSnackbar('Services belum siap. Mohon tunggu sebentar.');
    return;
  }

  setState(() => _isLoading = true);

  try {
    print("📂 Membuka file picker untuk import Excel...");
    
    final result = await _excelService.importFromExcel();
    
    // ✅ Handle jika null (dibatalkan atau error)
    if (result == null) {
      print("⚠️ Import dibatalkan atau gagal");
      if (mounted) {
        _showErrorSnackbar('Import dibatalkan atau terjadi kesalahan');
      }
      return;
    }
    
    final success = result['success'] ?? 0;
    final error = result['error'] ?? 0;

    print("✅ Import selesai. Berhasil: $success, Gagal: $error");

    if (mounted) {
      if (success > 0) {
        _showSuccessSnackbar(
            '🎉 Import berhasil!\n✅ Berhasil: $success tamu\n❌ Gagal: $error');
      } else {
        _showErrorSnackbar('❌ Tidak ada data yang berhasil diimport');
      }
    }
  } catch (e, stack) {
    print("❌ Exception di _handleImportExcel: $e");
    print(stack);
    
    if (mounted) {
      _showErrorSnackbar('❌ Gagal import: ${e.toString()}');
    }
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  // ===== SNACKBAR HELPERS =====

  void _showSuccessSnackbar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
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
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}