import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html;
import '../services/firestore_service.dart';

class ExcelService {
  final FirestoreService _firestoreService;

  ExcelService(this._firestoreService);

  Future<String> downloadTemplate() async {
    try {
      print("🔧 Membuat Excel template...");
      
      var excel = excel_pkg.Excel.createExcel();
      final defaultName = excel.getDefaultSheet();
      const targetName = 'Template Data Tamu';
      
      if (defaultName != null && defaultName != targetName) {
        try {
          excel.rename(defaultName, targetName);
        } catch (e) {
          print("⚠️ Tidak bisa rename sheet: $e");
        }
      }
      
      var sheet = excel[targetName];

      // Header
      sheet.appendRow([
        excel_pkg.TextCellValue('NAMA'),
        excel_pkg.TextCellValue('UNSUR'),
        excel_pkg.TextCellValue('ALAMAT'),
      ]);
      
      // Contoh data
      sheet.appendRow([
        excel_pkg.TextCellValue('Contoh: Budi Santoso'),
        excel_pkg.TextCellValue('Contoh: Keluarga'),
        excel_pkg.TextCellValue('Contoh: Jl. Merdeka No. 123'),
      ]);

      var fileBytes = excel.save();
      if (fileBytes == null) {
        throw Exception('Gagal membuat file template');
      }
      
      const filename = 'Template_Data_Tamu.xlsx';

      if (kIsWeb) {
        print("🌐 Download untuk Web...");
        final blob = html.Blob([Uint8List.fromList(fileBytes)]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename)
          ..click();
        html.Url.revokeObjectUrl(url);
        print("✅ Template berhasil diunduh (Web)");
        return filename;
      } else {
        print("📱 Download untuk Mobile/Desktop...");
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/$filename';
        File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
        print("✅ Template berhasil diunduh ke: $path");
        return path;
      }
    } catch (e, stackTrace) {
      print("❌ Error di downloadTemplate: $e");
      print(stackTrace);
      throw Exception('Gagal mengunduh template: $e');
    }
  }

  Future<Map<String, int>?> importFromExcel() async {
    try {
      print("📂 Membuka file picker...");
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        allowMultiple: false,
        withData: kIsWeb, // ✅ Penting untuk Web
      );

      if (result == null) {
        print("⚠️ User membatalkan pemilihan file");
        return null;
      }

      print("📂 File dipilih: ${result.files.single.name}");

      // ✅ Handle bytes untuk Web dan Mobile
      Uint8List? bytes;
      
      if (kIsWeb) {
        print("🌐 Membaca file dari Web...");
        bytes = result.files.single.bytes;
        if (bytes == null) {
          throw Exception('Gagal membaca file di platform Web');
        }
      } else {
        print("📱 Membaca file dari Mobile/Desktop...");
        final path = result.files.single.path;
        if (path == null) {
          throw Exception('Path file tidak ditemukan');
        }
        File file = File(path);
        bytes = await file.readAsBytes();
      }

      print("📊 Total bytes terbaca: ${bytes.length}");

      // Decode Excel
      print("📊 Decoding Excel file...");
      var excel = excel_pkg.Excel.decodeBytes(bytes);
      print("📊 Excel decoded. Jumlah sheet: ${excel.tables.keys.length}");

      int successCount = 0;
      int errorCount = 0;

      // Iterasi semua sheet
      for (var tableName in excel.tables.keys) {
        print("📊 Processing sheet: $tableName");
        var sheet = excel.tables[tableName];
        if (sheet == null) {
          print("⚠️ Sheet $tableName kosong, skip");
          continue;
        }

        print("📊 Sheet '$tableName' memiliki ${sheet.maxRows} baris");

        // Mulai dari baris ke-2 (index 1) karena baris pertama adalah header
        for (var i = 1; i < sheet.maxRows; i++) {
          try {
            var row = sheet.row(i);
            
            // Ambil data dari setiap kolom
            String name = '';
            String unsur = '';
            String address = '';

            if (row.isNotEmpty) {
              // Kolom 0: Nama
              if (row.length > 0 && row[0]?.value != null) {
                name = row[0]!.value.toString().trim();
              }
              
              // Kolom 1: Unsur
              if (row.length > 1 && row[1]?.value != null) {
                unsur = row[1]!.value.toString().trim();
              }
              
              // Kolom 2: Alamat
              if (row.length > 2 && row[2]?.value != null) {
                address = row[2]!.value.toString().trim();
              }
            }

            // Validasi: skip jika nama kosong atau mengandung kata "contoh" atau "nama"
            if (name.isEmpty) {
              print("⏭️ Baris $i: Nama kosong, skip");
              continue;
            }
            
            if (name.toLowerCase().contains('contoh') || 
                name.toLowerCase().contains('nama')) {
              print("⏭️ Baris $i: Baris contoh/header, skip");
              continue;
            }

            // Tambahkan ke Firestore
            print("➕ Baris $i: Menambahkan '$name'");
            await _firestoreService.addGuest(name, unsur, address);
            successCount++;
            
          } catch (e, stackTrace) {
            print("❌ Error pada baris $i: $e");
            print(stackTrace);
            errorCount++;
          }
        }
      }

      print("✅ Import selesai. Berhasil: $successCount, Gagal: $errorCount");
      return {'success': successCount, 'error': errorCount};
      
    } catch (e, stackTrace) {
      print("❌ Error di importFromExcel: $e");
      print(stackTrace);
      
      // ✅ Jangan throw exception, return null agar bisa dihandle di UI
      return null;
    }
  }

  Future<String> exportToExcel(List<Map<String, dynamic>> guests) async {
    try {
      if (guests.isEmpty) {
        throw Exception('Tidak ada data untuk diekspor');
      }

      print("📊 Membuat Excel export untuk ${guests.length} tamu...");

      var excel = excel_pkg.Excel.createExcel();
      final defaultName = excel.getDefaultSheet();
      const targetName = 'Data Tamu';
      
      if (defaultName != null && defaultName != targetName) {
        try {
          excel.rename(defaultName, targetName);
        } catch (e) {
          print("⚠️ Tidak bisa rename sheet: $e");
        }
      }
      
      var sheet = excel[targetName];

      // Header
      sheet.appendRow([
        excel_pkg.TextCellValue('NO'),
        excel_pkg.TextCellValue('NAMA'),
        excel_pkg.TextCellValue('UNSUR'),
        excel_pkg.TextCellValue('ALAMAT'),
        excel_pkg.TextCellValue('LINK'),
        excel_pkg.TextCellValue('STATUS SHARE'),
      ]);

      // Data
      for (var i = 0; i < guests.length; i++) {
        var guest = guests[i];
        final isShared = guest['isShared'] ?? false;
        
        sheet.appendRow([
          excel_pkg.IntCellValue(i + 1),
          excel_pkg.TextCellValue(guest['name']?.toString() ?? ''),
          excel_pkg.TextCellValue(guest['unsur']?.toString() ?? ''),
          excel_pkg.TextCellValue(guest['address']?.toString() ?? ''),
          excel_pkg.TextCellValue(guest['link']?.toString() ?? ''),
          excel_pkg.TextCellValue(isShared ? 'Sudah' : 'Belum'),
        ]);
      }

      var fileBytes = excel.save();
      if (fileBytes == null) {
        throw Exception('Gagal membuat file Excel');
      }
      
      final filename = 'Data_Tamu_${DateTime.now().millisecondsSinceEpoch}.xlsx';

      if (kIsWeb) {
        print("🌐 Export untuk Web...");
        final blob = html.Blob([Uint8List.fromList(fileBytes)]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename)
          ..click();
        html.Url.revokeObjectUrl(url);
        print("✅ Export berhasil (Web)");
        return filename;
      } else {
        print("📱 Export untuk Mobile/Desktop...");
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/$filename';
        File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
        print("✅ Export berhasil ke: $path");
        return path;
      }
    } catch (e, stackTrace) {
      print("❌ Error di exportToExcel: $e");
      print(stackTrace);
      throw Exception('Gagal ekspor data: $e');
    }
  }
}