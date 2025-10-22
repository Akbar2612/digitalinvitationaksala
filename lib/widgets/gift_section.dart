import 'package:digitalinvitationaksala/data/wedding_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class WeddingGiftSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Text(
            'Wedding Gift',
            style: GoogleFonts.robotoSlab(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF5F5F5),
              letterSpacing: 0.5,
            ),
          ),
          
          SizedBox(height: 12),
          
          Text(
            'Doa Restu Anda merupakan karunia yang sangat berarti bagi kami.\nDan jika memberi adalah ungkapan tanda kasih Anda,\nAnda dapat memberi kado secara cashless.',
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFFE0E0E0),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 28),

          // Card 1
          _buildBankCard(
            context: context,
            accountNumber: accountNumberBride,
            accountName: brideName,
          ),

          SizedBox(height: 16),

          // Card 2
          _buildBankCard(
            context: context,
            accountNumber: accountNumberGroom,
            accountName: groomName,
          ),
        ],
      ),
    );
  }

  Widget _buildBankCard({
    required BuildContext context,
    required String accountNumber,
    required String accountName,
  }) {
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
      child: Column(
        children: [
          // Bank Logo & Name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Color(0xFFF5F5F5),
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    'assets/images/bri.png',
                    height: 24,
                    width: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Bank Rakyat Indonesia',
                style: GoogleFonts.robotoSlab(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF5F5F5),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Divider
          Container(
            height: 1,
            color: Color(0xFFF5F5F5).withOpacity(0.1),
          ),

          SizedBox(height: 16),

          // Account Number
          Text(
            accountNumber,
            style: GoogleFonts.robotoMono(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF5F5F5),
              letterSpacing: 1.2,
            ),
          ),

          SizedBox(height: 8),

          // Account Name
          Text(
            accountName,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFFE0E0E0),
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 16),

          // Copy Button
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: accountNumber));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Nomor rekening berhasil disalin'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green.shade700,
                ),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(0xFFF5F5F5).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.copy,
                    size: 16,
                    color: Color(0xFFF5F5F5),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Salin Nomor Rekening',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFF5F5F5),
                      letterSpacing: 0.3,
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
}