import 'package:digitalinvitationaksala/services/excel_services.dart';
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

  // Search and Filter
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _filterUnsur;
  String? _filterStatus;
  List<String> _availableUnsur = [];
  bool _showUnsurFilter = false;
  bool _showStatusFilter = false;
  final LayerLink _unsurLayerLink = LayerLink();
  final LayerLink _statusLayerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  // Edit Dialog Controllers
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editUnsurController = TextEditingController();
  final TextEditingController _editAddressController = TextEditingController();
  final _editFormKey = GlobalKey<FormState>();
  bool _editIsShared = false;

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService();
    _excelService = ExcelService(_firestoreService);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _editNameController.dispose();
    _editUnsurController.dispose();
    _editAddressController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_showUnsurFilter || _showStatusFilter) {
      _showUnsurFilter = false;
      _showStatusFilter = false;
    }
  }

  List<QueryDocumentSnapshot> _filterGuests(
    List<QueryDocumentSnapshot> guests,
  ) {
    // Update available unsur list
    _availableUnsur =
        guests
            .map(
              (doc) => (doc.data() as Map<String, dynamic>)['unsur'] as String?,
            )
            .where((unsur) => unsur != null && unsur.isNotEmpty)
            .cast<String>()
            .toSet()
            .toList()
          ..sort();

    return guests.where((guest) {
      final data = guest.data() as Map<String, dynamic>;
      final name = (data['name'] ?? '').toString().toLowerCase();
      final unsur = (data['unsur'] ?? '').toString().toLowerCase();
      final address = (data['address'] ?? '').toString().toLowerCase();
      final isShared = data['isShared'] ?? false;

      // Search filter
      if (_searchQuery.isNotEmpty) {
        if (!name.contains(_searchQuery) &&
            !unsur.contains(_searchQuery) &&
            !address.contains(_searchQuery)) {
          return false;
        }
      }

      // Unsur filter
      if (_filterUnsur != null && _filterUnsur!.isNotEmpty) {
        if (unsur != _filterUnsur!.toLowerCase()) {
          return false;
        }
      }

      // Status filter
      if (_filterStatus != null) {
        if (_filterStatus == 'terkirim' && !isShared) return false;
        if (_filterStatus == 'belum' && isShared) return false;
      }

      return true;
    }).toList();
  }

  void _showEditDialog(QueryDocumentSnapshot guest) {
    final data = guest.data() as Map<String, dynamic>;

    // Populate controllers with current data
    _editNameController.text = data['name'] ?? '';
    _editUnsurController.text = data['unsur'] ?? '';
    _editAddressController.text = data['address'] ?? '';
    _editIsShared = data['isShared'] ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.edit, color: widget.orange, size: 28),
              SizedBox(width: 12),
              Text(
                'Edit Tamu',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: widget.navyBlue,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _editFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Field
                  Text(
                    'Nama Tamu',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: widget.navyBlue,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _editNameController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama tamu',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[400],
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        size: 20,
                        color: widget.lightBlue,
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: widget.lightBlue,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 13),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Unsur Field
                  Text(
                    'Unsur',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: widget.navyBlue,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _editUnsurController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan unsur',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[400],
                      ),
                      prefixIcon: Icon(
                        Icons.group,
                        size: 20,
                        color: widget.lightBlue,
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: widget.lightBlue,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),

                  SizedBox(height: 16),

                  // Alamat Field
                  Text(
                    'Alamat',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: widget.navyBlue,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _editAddressController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Masukkan alamat',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[400],
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 50),
                        child: Icon(
                          Icons.location_on,
                          size: 20,
                          color: widget.lightBlue,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: widget.lightBlue,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),

                  SizedBox(height: 16),

                  // Status Field
                  Text(
                    'Status Undangan',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: widget.navyBlue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setDialogState(() {
                                _editIsShared = false;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !_editIsShared
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: !_editIsShared
                                    ? Border.all(color: Colors.red, width: 1.5)
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    size: 18,
                                    color: !_editIsShared
                                        ? Colors.red
                                        : Colors.grey[400],
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Belum Terkirim',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: !_editIsShared
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: !_editIsShared
                                          ? Colors.red
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setDialogState(() {
                                _editIsShared = true;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _editIsShared
                                    ? Color(0xFF10B981).withOpacity(0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: _editIsShared
                                    ? Border.all(
                                        color: Color(0xFF10B981),
                                        width: 1.5,
                                      )
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 18,
                                    color: _editIsShared
                                        ? Color(0xFF10B981)
                                        : Colors.grey[400],
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Terkirim',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: _editIsShared
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: _editIsShared
                                          ? Color(0xFF10B981)
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _editNameController.clear();
                _editUnsurController.clear();
                _editAddressController.clear();
              },
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _handleEditGuest(guest.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Simpan',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleEditGuest(String guestId) async {
    if (!_editFormKey.currentState!.validate()) {
      return;
    }

    try {
      await _firestoreService.updateGuest(guestId, {
        'name': _editNameController.text.trim(),
        'unsur': _editUnsurController.text.trim(),
        'address': _editAddressController.text.trim(),
        'isShared': _editIsShared,
      });

      Navigator.pop(context);
      _editNameController.clear();
      _editUnsurController.clear();
      _editAddressController.clear();

      _showSuccessSnackbar('Data tamu berhasil diperbarui');
    } catch (e) {
      Navigator.pop(context);
      _showErrorSnackbar('Gagal memperbarui tamu: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return GestureDetector(
      onTap: () {
        // Close overlay when tapping outside
        if (_showUnsurFilter || _showStatusFilter) {
          _removeOverlay();
        }
        // Unfocus search bar
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          // Header with Export Button
          Container(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DATA TAMU',
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.w700,
                            color: widget.navyBlue,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: 3,
                          width: 50,
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Icon(Icons.download, size: isMobile ? 16 : 18),
                      label: Text(
                        _isExporting
                            ? 'Export...'
                            : (isMobile ? 'Export' : 'Export Excel'),
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 11 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.orange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 12 : 16,
                          vertical: isMobile ? 8 : 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Search Bar
                TextField(
                  controller: _searchController,
                  onTap: () {
                    // Close any open filter dropdown when focusing search
                    if (_showUnsurFilter || _showStatusFilter) {
                      _removeOverlay();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari nama, unsur, atau alamat...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[400],
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: widget.lightBlue,
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, size: 18),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: widget.lightBlue,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  style: GoogleFonts.poppins(fontSize: 13),
                ),

                SizedBox(height: 10),

                // Filters
                Row(
                  children: [
                    // Unsur Filter
                    Expanded(
                      child: CompositedTransformTarget(
                        link: _unsurLayerLink,
                        child: _buildFilterChip(
                          label: _filterUnsur ?? 'Semua Unsur',
                          icon: Icons.group,
                          isActive: _filterUnsur != null,
                          onTap: () => _toggleUnsurFilter(),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),

                    // Status Filter
                    Expanded(
                      child: CompositedTransformTarget(
                        link: _statusLayerLink,
                        child: _buildFilterChip(
                          label: _filterStatus == null
                              ? 'Semua Status'
                              : _filterStatus == 'terkirim'
                              ? 'Terkirim'
                              : 'Belum Terkirim',
                          icon: Icons.check_circle_outline,
                          isActive: _filterStatus != null,
                          onTap: () => _toggleStatusFilter(),
                        ),
                      ),
                    ),

                    // Clear All Filters
                    if (_filterUnsur != null ||
                        _filterStatus != null ||
                        _searchQuery.isNotEmpty) ...[
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                            _filterUnsur = null;
                            _filterStatus = null;
                          });
                          _removeOverlay();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Icon(
                            Icons.clear,
                            size: 18,
                            color: Colors.red[600],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Data Content
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getGuests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: widget.orange),
                  );
                }

                if (snapshot.hasError) {
                  return _buildErrorState(snapshot.error.toString());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                final filteredGuests = _filterGuests(snapshot.data!.docs);

                if (filteredGuests.isEmpty) {
                  return _buildNoResultsState();
                }

                return isMobile
                    ? _buildMobileView(filteredGuests)
                    : _buildDesktopView(filteredGuests);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? widget.lightBlue.withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? widget.lightBlue : Colors.grey[300]!,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? widget.lightBlue : Colors.grey[600],
            ),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? widget.lightBlue : Colors.grey[700],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: isActive ? widget.lightBlue : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleUnsurFilter() {
    if (_showUnsurFilter) {
      _removeOverlay();
      return;
    }

    _removeOverlay();
    _showUnsurFilter = true;

    _overlayEntry = _createOverlayEntry(
      layerLink: _unsurLayerLink,
      items: [
        {'label': 'Semua Unsur', 'value': null},
        ..._availableUnsur.map((unsur) => {'label': unsur, 'value': unsur}),
      ],
      currentValue: _filterUnsur,
      onSelected: (value) {
        setState(() => _filterUnsur = value);
        _removeOverlay();
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _toggleStatusFilter() {
    if (_showStatusFilter) {
      _removeOverlay();
      return;
    }

    _removeOverlay();
    _showStatusFilter = true;

    _overlayEntry = _createOverlayEntry(
      layerLink: _statusLayerLink,
      items: [
        {'label': 'Semua Status', 'value': null},
        {'label': 'Terkirim', 'value': 'terkirim'},
        {'label': 'Belum Terkirim', 'value': 'belum'},
      ],
      currentValue: _filterStatus,
      onSelected: (value) {
        setState(() => _filterStatus = value);
        _removeOverlay();
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry({
    required LayerLink layerLink,
    required List<Map<String, dynamic>> items,
    required String? currentValue,
    required Function(String?) onSelected,
  }) {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Transparent barrier to detect outside taps
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                _removeOverlay();
              },
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          // The actual dropdown menu
          CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, 40),
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 200,
                constraints: BoxConstraints(maxHeight: 250),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    shrinkWrap: true,
                    children: items.map((item) {
                      final isSelected = currentValue == item['value'];
                      return InkWell(
                        onTap: () => onSelected(item['value']),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          color: isSelected
                              ? widget.lightBlue.withOpacity(0.1)
                              : null,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['label'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? widget.lightBlue
                                        : Colors.grey[800],
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check,
                                  size: 16,
                                  color: widget.lightBlue,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileView(List<QueryDocumentSnapshot> guests) {
    return Container(
      color: Colors.grey[50],
      child: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: guests.length,
        itemBuilder: (context, index) {
          final guest = guests[index];
          final data = guest.data() as Map<String, dynamic>;
          final isShared = data['isShared'] ?? false;

          return Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Number, Name and Status in one row
                Row(
                  children: [
                    Text(
                      '#${index + 1}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: widget.lightBlue,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data['name'] ?? '',
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
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isShared
                            ? Color(0xFF10B981).withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 5,
                            color: isShared ? Color(0xFF10B981) : Colors.red,
                          ),
                          SizedBox(width: 4),
                          Text(
                            isShared ? 'Terkirim' : 'Belum',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: isShared ? Color(0xFF10B981) : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 6),

                // Unsur and Address in compact layout
                Row(
                  children: [
                    Icon(Icons.group, size: 11, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      data['unsur'] ?? '-',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.location_on, size: 11, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        data['address'] ?? '-',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                // Actions in compact horizontal layout
                Row(
                  children: [
                    Expanded(
                      child: _buildCompactActionButton(
                        icon: Icons.content_copy,
                        label: 'Salin',
                        color: widget.lightBlue,
                        onPressed: () => _handleCopyLink(data['link']),
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: _buildCompactActionButton(
                        icon: Icons.send,
                        label: 'Kirim',
                        color: Color(0xFF10B981),
                        onPressed: () => _handleShareWhatsApp(guest),
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(width: 4),
                    Expanded(
                      child: _buildCompactActionButton(
                        icon: Icons.edit,
                        label: 'Edit',
                        color: widget.orange,
                        onPressed: () => _showEditDialog(guest),
                      ),
                    ),
                    Expanded(
                      child: _buildCompactActionButton(
                        icon: Icons.delete_outline,
                        label: 'Hapus',
                        color: Colors.red[400]!,
                        onPressed: () => _showDeleteConfirmation(guest.id),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompactActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 8,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopView(List<QueryDocumentSnapshot> guests) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Table(
              columnWidths: {
                0: FixedColumnWidth(70),
                1: FlexColumnWidth(2.5),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(2.5),
                4: FixedColumnWidth(260),
              },
              border: TableBorder.all(color: Colors.grey[200]!, width: 1),
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(color: widget.navyBlue),
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
                      color: index % 2 == 0 ? Colors.grey[50] : Colors.white,
                    ),
                    children: [
                      _buildDataCell(
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
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
                                fontSize: 12,
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
                            fontSize: 12,
                            color: widget.navyBlue,
                          ),
                        ),
                      ),
                      _buildDataCell(
                        Text(
                          data['address'] ?? '-',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
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
                                    isShared
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    size: 12,
                                    color: isShared
                                        ? Color(0xFF10B981)
                                        : Colors.red,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    isShared ? 'Terkirim' : 'Belum',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
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
                              icon: Icons.edit,
                              tooltip: 'Edit',
                              color: widget.orange,
                              onPressed: () => _showEditDialog(guest),
                            ),

                            SizedBox(width: 4),
                            _buildActionButton(
                              icon: Icons.delete,
                              color: Colors.red[400]!,
                              tooltip: 'Hapus',
                              onPressed: () =>
                                  _showDeleteConfirmation(guest.id),
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
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(Widget child) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
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
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'Tidak Ada Hasil',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Coba ubah filter atau pencarian Anda',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _filterUnsur = null;
                _filterStatus = null;
              });
            },
            icon: Icon(Icons.refresh, size: 18),
            label: Text('Reset Filter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.lightBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
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
            error,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _handleExportExcel() async {
    if (_isExporting) return;

    setState(() => _isExporting = true);

    try {
      final snapshot = await _firestoreService.getGuests().first;

      if (snapshot.docs.isEmpty) {
        _showErrorSnackbar('Tidak ada data untuk diekspor');
        setState(() => _isExporting = false);
        return;
      }

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

      final result = await _excelService.exportToExcel(guests);

      if (result != null && result.isNotEmpty) {
        _showSuccessSnackbar(
          'Data berhasil diekspor!\nTotal: ${guests.length} tamu',
        );
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

    final message =
        '''
Assalamu'alaikum Warahmatullahi Wabarakatuh,

Dengan penuh rasa hormat, kami mengundang Bapak/Ibu/Saudara/i 
*$name* 
untuk hadir dan memberikan doa restu pada acara pernikahan Kami.

Link undangan digital: 
$link
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          style: GoogleFonts.poppins(fontSize: 14, color: widget.navyBlue),
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
