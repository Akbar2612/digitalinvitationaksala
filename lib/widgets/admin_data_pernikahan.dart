import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/firestore_service.dart';
import '../data/wedding_data.dart';

class AdminDataPernikahan extends StatefulWidget {
  final Color navyBlue;
  final Color lightBlue;
  final Color orange;
  final Color lightGray;
  final Color yellow;

  const AdminDataPernikahan({
    super.key,
    required this.navyBlue,
    required this.lightBlue,
    required this.orange,
    required this.lightGray,
    required this.yellow,
  });

  @override
  State<AdminDataPernikahan> createState() => _AdminDataPernikahanState();
}

class _AdminDataPernikahanState extends State<AdminDataPernikahan> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = true;
  Map<String, dynamic> _weddingData = {};

  // Expanded states untuk mobile
  bool _isGroomExpanded = false;
  bool _isBrideExpanded = false;
  bool _isResepsiExpanded = false;
  bool _isAkadExpanded = false;
  bool _isOtherExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadWeddingData();
  }

  Future<void> _loadWeddingData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _firestoreService.getWeddingData();
      if (data.exists && data.data() != null) {
        setState(() {
          _weddingData = data.data() as Map<String, dynamic>;
          _isLoading = false;
        });
      } else {
        setState(() {
          _weddingData = _getDefaultWeddingData();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
    }
  }

  Map<String, dynamic> _getDefaultWeddingData() {
    return {
      'brideName': brideName,
      'groomName': groomName,
      'groomnickName': groomnickName,
      'bridenickName': bridenickName,
      'FatherparentsBride': FatherparentsBride,
      'MotherparentsBride': MotherparentsBride,
      'FatherparentsGroom': FatherparentsGroom,
      'MotherparentsGroom': MotherparentsGroom,
      'ResepsiDate': ResepsiDate,
      'AkadDate': AkadDate,
      'ResepsiTime': ResepsiTime,
      'AkadTime': AkadTime,
      'ResepsiLocation': ResepsiLocation,
      'locationUrl': locationUrl,
      'accountNumberBride': accountNumberBride,
      'accountNumberGroom': accountNumberGroom,
    };
  }

  void _showEditDialog() {
    final TextEditingController brideNameController = TextEditingController(
      text: _weddingData['brideName'] ?? '',
    );
    final TextEditingController groomNameController = TextEditingController(
      text: _weddingData['groomName'] ?? '',
    );
    final TextEditingController groomnickNameController = TextEditingController(
      text: _weddingData['groomnickName'] ?? '',
    );
    final TextEditingController bridenickNameController = TextEditingController(
      text: _weddingData['bridenickName'] ?? '',
    );
    final TextEditingController FatherparentsBrideController =
        TextEditingController(text: _weddingData['FatherparentsBride'] ?? '');
    final TextEditingController MotherparentsBrideController =
        TextEditingController(text: _weddingData['MotherparentsBride'] ?? '');
    final TextEditingController FatherparentsGroomController =
        TextEditingController(text: _weddingData['FatherparentsGroom'] ?? '');
    final TextEditingController MotherparentsGroomController =
        TextEditingController(text: _weddingData['MotherparentsGroom'] ?? '');
    final TextEditingController ResepsiDateController = TextEditingController(
      text: _weddingData['ResepsiDate'] ?? '',
    );
    final TextEditingController ResepsiTimeController = TextEditingController(
      text: _weddingData['ResepsiTime'] ?? '',
    );
    final TextEditingController ResepsiLocationController =
        TextEditingController(text: _weddingData['ResepsiLocation'] ?? '');
    final TextEditingController AkadDateController = TextEditingController(
      text: _weddingData['AkadDate'] ?? '',
    );
    final TextEditingController AkadTimeController = TextEditingController(
      text: _weddingData['AkadTime'] ?? '',
    );
    final TextEditingController AkadLocationController = TextEditingController(
      text: _weddingData['AkadLocation'] ?? '',
    );
    final TextEditingController locationUrlController = TextEditingController(
      text: _weddingData['locationUrl'] ?? '',
    );
    final TextEditingController accountNumberBrideController =
        TextEditingController(text: _weddingData['accountNumberBride'] ?? '');
    final TextEditingController accountNumberGroomController =
        TextEditingController(text: _weddingData['accountNumberGroom'] ?? '');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  border: Border(
                    bottom: BorderSide(color: widget.lightGray, width: 1.5),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [widget.orange, Colors.amber],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.edit, color: Colors.white, size: 18),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EDIT DATA',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: widget.navyBlue,
                            ),
                          ),
                          Container(
                            height: 2,
                            width: 40,
                            margin: EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [widget.orange, Colors.amber],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: widget.navyBlue, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: widget.lightGray.withOpacity(0.3),
                        padding: EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormSection('Pengantin Laki-laki'),
                        _buildTextField('Nama Lengkap', groomNameController),
                        _buildTextField(
                          'Nama Panggilan',
                          groomnickNameController,
                        ),
                        _buildTextField(
                          'Nama Bapak',
                          FatherparentsGroomController,
                        ),
                        _buildTextField(
                          'Nama Ibu',
                          MotherparentsGroomController,
                        ),
                        _buildTextField(
                          'No. Rekening',
                          accountNumberGroomController,
                        ),

                        SizedBox(height: 20),
                        _buildFormSection('Pengantin Perempuan'),
                        _buildTextField('Nama Lengkap', brideNameController),
                        _buildTextField(
                          'Nama Panggilan',
                          bridenickNameController,
                        ),
                        _buildTextField(
                          'Nama Bapak',
                          FatherparentsBrideController,
                        ),
                        _buildTextField(
                          'Nama Ibu',
                          MotherparentsBrideController,
                        ),
                        _buildTextField(
                          'No. Rekening',
                          accountNumberBrideController,
                        ),

                        SizedBox(height: 20),
                        _buildFormSection('Detail Acara'),
                        _buildTextField(
                          'Tanggal Resepsi',
                          ResepsiDateController,
                        ),
                        _buildTextField('Waktu Resepsi', ResepsiTimeController),
                        _buildTextField(
                          'Lokasi Resepsi',
                          ResepsiLocationController,
                          maxLines: 2,
                        ),
                        _buildTextField('Tanggal Akad', AkadDateController),
                        _buildTextField('Waktu Akad', AkadTimeController),
                        _buildTextField(
                          'Lokasi Akad',
                          AkadLocationController,
                          maxLines: 2,
                        ),
                        _buildTextField('URL Lokasi', locationUrlController),
                      ],
                    ),
                  ),
                ),
              ),

              // Footer Buttons
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  border: Border(
                    top: BorderSide(color: widget.lightGray, width: 1.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: widget.lightGray, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final newData = {
                              'brideName': brideNameController.text,
                              'groomName': groomNameController.text,
                              'groomnickName': groomnickNameController.text,
                              'bridenickName': bridenickNameController.text,
                              'FatherparentsBride':
                                  FatherparentsBrideController.text,
                              'MotherparentsBride':
                                  MotherparentsBrideController.text,
                              'FatherparentsGroom':
                                  FatherparentsGroomController.text,
                              'MotherparentsGroom':
                                  MotherparentsGroomController.text,
                              'ResepsiDate': ResepsiDateController.text,
                              'ResepsiTime': ResepsiTimeController.text,
                              'ResepsiLocation': ResepsiLocationController.text,
                              'AkadDate': AkadDateController.text,
                              'AkadTime': AkadTimeController.text,
                              'AkadLocation': AkadLocationController.text,
                              'locationUrl': locationUrlController.text,
                              'accountNumberBride':
                                  accountNumberBrideController.text,
                              'accountNumberGroom':
                                  accountNumberGroomController.text,
                              'updatedAt': DateTime.now().toIso8601String(),
                            };

                            await _firestoreService.saveWeddingData(newData);

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Data berhasil disimpan!'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            _loadWeddingData();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.orange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Simpan',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildFormSection(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.navyBlue, widget.navyBlue.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: widget.navyBlue,
            ),
          ),
          SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widget.lightGray, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widget.lightGray, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widget.orange, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DATA PERNIKAHAN',
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.w700,
                        color: widget.navyBlue,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 3,
                      width: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [widget.orange, Colors.amber],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                ElevatedButton.icon(
                  onPressed: _showEditDialog,
                  icon: Icon(Icons.edit, size: 18),
                  label: Text('Edit Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          ),

          if (isMobile) ...[
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showEditDialog,
                icon: Icon(Icons.edit, size: 18),
                label: Text('Edit Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],

          SizedBox(height: 24),

          if (isMobile) _buildMobileLayout() else _buildDesktopLayout(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Pengantin Laki-laki'),
                  SizedBox(height: 16),
                  _buildDataField(
                    'NAMA LENGKAP',
                    _weddingData['groomName'] ?? '-',
                  ),
                  SizedBox(height: 16),
                  _buildDataField(
                    'NAMA PANGGILAN',
                    _weddingData['groomnickName'] ?? '-',
                  ),
                  SizedBox(height: 16),
                  _buildDataField(
                    'NAMA BAPAK',
                    _weddingData['FatherparentsGroom'] ?? '-',
                  ),
                  SizedBox(height: 16),
                  _buildDataField(
                    'NAMA IBU',
                    _weddingData['MotherparentsGroom'] ?? '-',
                  ),
                  SizedBox(height: 16),
                  _buildDataField(
                    'NO. REKENING',
                    _weddingData['accountNumberGroom'] ?? '-',
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Pengantin Perempuan'),
                  SizedBox(height: 16),
                  _buildDataField(
                    'NAMA LENGKAP',
                    _weddingData['brideName'] ?? '-',
                  ),
                  SizedBox(height: 16),
                  _buildDataField(
                    'NAMA PANGGILAN',
                    _weddingData['bridenickName'] ?? '-',
                  ),
                  SizedBox(height: 16),
                  _buildDataField(
                    'NAMA BAPAK',
                    _weddingData['FatherparentsBride'] ?? '-',
                  ),
                  SizedBox(height: 16),
                  _buildDataField(
                    'NAMA IBU',
                    _weddingData['MotherparentsBride'] ?? '-',
                  ),
                  SizedBox(height: 16),
                  _buildDataField(
                    'NO. REKENING',
                    _weddingData['accountNumberBride'] ?? '-',
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 32),
        _buildSectionTitle('Detail Acara'),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDataField(
                    'TANGGAL RESEPSI',
                    _weddingData['ResepsiDate'] ?? '-',
                  ),
                  SizedBox(height: 16),
                  _buildDataField(
                    'WAKTU RESEPSI',
                    _weddingData['ResepsiTime'] ?? '-',
                  ),
                  SizedBox(height: 16),
                  _buildDataField(
                    'LOKASI RESEPSI',
                    _weddingData['ResepsiLocation'] ?? '-',
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDataField(
                    'TANGGAL AKAD NIKAH',
                    _weddingData['AkadDate'] ?? '-',
                  ),
                  SizedBox(height: 16),
                  _buildDataField(
                    'WAKTU AKAD NIKAH',
                    _weddingData['AkadTime'] ?? '-',
                  ),
                  SizedBox(height: 16),
                  _buildDataField(
                    'LOKASI AKAD NIKAH',
                    _weddingData['AkadLocation'] ?? '-',
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 32),
        _buildSectionTitle('Lain-Lain'),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDataField(
                'URL LOKASI',
                _weddingData['locationUrl'] ?? '-',
              ),
            ),
            SizedBox(width: 16),
            InkWell(
              onTap: () async {
                final url = _weddingData['locationUrl'];
                if (url != null && url.isNotEmpty && url != '-') {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [widget.orange, widget.yellow],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.orange.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  'CEK LOKASI',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildExpandableCard(
          'Pengantin Laki-laki',
          Icons.man,
          _isGroomExpanded,
          () => setState(() => _isGroomExpanded = !_isGroomExpanded),
          [
            _buildDataField('NAMA LENGKAP', _weddingData['groomName'] ?? '-'),
            SizedBox(height: 12),
            _buildDataField(
              'NAMA PANGGILAN',
              _weddingData['groomnickName'] ?? '-',
            ),
            SizedBox(height: 12),
            _buildDataField(
              'NAMA BAPAK',
              _weddingData['FatherparentsGroom'] ?? '-',
            ),
            SizedBox(height: 12),
            _buildDataField(
              'NAMA IBU',
              _weddingData['MotherparentsGroom'] ?? '-',
            ),
            SizedBox(height: 12),
            _buildDataField(
              'NO. REKENING',
              _weddingData['accountNumberGroom'] ?? '-',
            ),
          ],
        ),

        SizedBox(height: 12),

        _buildExpandableCard(
          'Pengantin Perempuan',
          Icons.woman,
          _isBrideExpanded,
          () => setState(() => _isBrideExpanded = !_isBrideExpanded),
          [
            _buildDataField('NAMA LENGKAP', _weddingData['brideName'] ?? '-'),
            SizedBox(height: 12),
            _buildDataField(
              'NAMA PANGGILAN',
              _weddingData['bridenickName'] ?? '-',
            ),
            SizedBox(height: 12),
            _buildDataField(
              'NAMA BAPAK',
              _weddingData['FatherparentsBride'] ?? '-',
            ),
            SizedBox(height: 12),
            _buildDataField(
              'NAMA IBU',
              _weddingData['MotherparentsBride'] ?? '-',
            ),
            SizedBox(height: 12),
            _buildDataField(
              'NO. REKENING',
              _weddingData['accountNumberBride'] ?? '-',
            ),
          ],
        ),

        SizedBox(height: 12),

        _buildExpandableCard(
          'Resepsi',
          Icons.celebration,
          _isResepsiExpanded,
          () => setState(() => _isResepsiExpanded = !_isResepsiExpanded),
          [
            _buildDataField(
              'TANGGAL RESEPSI',
              _weddingData['ResepsiDate'] ?? '-',
            ),
            SizedBox(height: 12),
            _buildDataField(
              'WAKTU RESEPSI',
              _weddingData['ResepsiTime'] ?? '-',
            ),
            SizedBox(height: 12),
            _buildDataField(
              'LOKASI RESEPSI',
              _weddingData['ResepsiLocation'] ?? '-',
            ),
          ],
        ),

        SizedBox(height: 12),

        _buildExpandableCard(
          'Akad Nikah',
          Icons.favorite,
          _isAkadExpanded,
          () => setState(() => _isAkadExpanded = !_isAkadExpanded),
          [
            _buildDataField(
              'TANGGAL AKAD NIKAH',
              _weddingData['AkadDate'] ?? '-',
            ),
            SizedBox(height: 12),
            _buildDataField(
              'WAKTU AKAD NIKAH',
              _weddingData['AkadTime'] ?? '-',
            ),
            SizedBox(height: 12),
            _buildDataField(
              'LOKASI AKAD NIKAH',
              _weddingData['AkadLocation'] ?? '-',
            ),
          ],
        ),

        SizedBox(height: 12),

        _buildExpandableCard(
          'Lain-Lain',
          Icons.more_horiz,
          _isOtherExpanded,
          () => setState(() => _isOtherExpanded = !_isOtherExpanded),
          [
            _buildDataField('URL LOKASI', _weddingData['locationUrl'] ?? '-'),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: InkWell(
                onTap: () async {
                  final url = _weddingData['locationUrl'];
                  if (url != null && url.isNotEmpty && url != '-') {
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  }
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [widget.orange, widget.yellow],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: widget.orange.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'CEK LOKASI',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandableCard(
    String title,
    IconData icon,
    bool isExpanded,
    VoidCallback onTap,
    List<Widget> children,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.lightGray, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    isExpanded ? widget.orange : widget.navyBlue,
                    isExpanded
                        ? widget.yellow
                        : widget.navyBlue.withOpacity(0.8),
                  ],
                ),
                borderRadius: isExpanded
                    ? BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      )
                    : BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: SizedBox.shrink(),
            secondChild: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.navyBlue, widget.navyBlue.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDataField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: widget.navyBlue,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: widget.lightGray, width: 1.5),
          ),
          child: Text(
            value.isEmpty ? '-' : value,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}
