
import 'package:company_task/view/data_enter_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
   // allowDuplicates: false,
    onDetect: (BarcodeCapture capture) {
      final List<Barcode> barcodes = capture.barcodes;
      for (final barcode in barcodes) {
        final String? code = barcode.rawValue;
        if (code != null && !isScanned) {
          setState(() {
            scannedUrl = code;
            isScanned = true;
          });
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
                          //onPressed: () => _launchInBrowser(scannedUrl!),
                          onPressed: (){
 Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => DataEnterPage()),
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

  // Future<void> _launchInBrowser(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}
