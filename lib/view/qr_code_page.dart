import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QRGeneratorScreen extends StatefulWidget {
  const 
  
  QRGeneratorScreen({super.key});

  @override
  _QRGeneratorScreenState createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  String qrData = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateDailyQRData();
  }

  Future<void> _generateDailyQRData() async {
    setState(() {
      isLoading = true;
    });

    final now = DateTime.now();
    final generatedQR = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    try {
      final supabase = Supabase.instance.client;

      // Check if QR already exists
      final existing = await supabase
          .from('qr_codes')
          .select()
          .eq('qr_text', generatedQR)
          .maybeSingle();

      // If not exists, insert it
      if (existing == null) {
        await supabase.from('qr_codes').insert({'qr_text': generatedQR});
        print('QR inserted into Supabase ✅');
      } else {
        print('QR already exists in Supabase ⚠️');
      }

      setState(() {
        qrData = generatedQR;
        isLoading = false;
      });
    } catch (e) {
      print("Supabase error: $e");
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save QR to Supabase: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily QR Code'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 300.0,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'QR for Date:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    qrData,
                    style: const TextStyle(fontSize: 18),
                  ),
                  // const SizedBox(height: 30),
                  // ElevatedButton.icon(
                  //   icon: const Icon(Icons.refresh),
                  //   label: const Text("Regenerate QR"),
                  //   onPressed: _generateDailyQRData,
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.teal,
                  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  //   ),
                  // ),
                ],
              ),
      ),
    );
  }
}
