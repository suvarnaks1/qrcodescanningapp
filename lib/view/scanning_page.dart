import 'package:company_task/view/data_enter_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  String? scannedUrl;
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mobile Scanner"),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: MobileScannerController(
                facing: CameraFacing.back,
                torchEnabled: false,
              ),
              onDetect: (BarcodeCapture capture) async {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final String? code = barcode.rawValue;
                  if (code != null && !isScanned) {
                    // ✅ Check with Supabase
                    final response = await Supabase.instance.client
                        .from('qr_codes')
                        .select()
                        .eq('qr_text', code)
                        .maybeSingle();

                    if (response != null) {
                      // QR Code is valid
                      setState(() {
                        scannedUrl = code;
                        isScanned = true;
                      });
                    } else {
                      // ❌ Invalid QR
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid QR Code!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: (scannedUrl != null)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Scanned Data:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            scannedUrl!,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const DataEnterPage()),
                            );
                          },
                          child: const Text('Submit'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              scannedUrl = null;
                              isScanned = false;
                            });
                          },
                          child: const Text("Scan Again"),
                        )
                      ],
                    )
                  : const Text('Scan a QR code'),
            ),
          ),
        ],
      ),
    );
  }
}
