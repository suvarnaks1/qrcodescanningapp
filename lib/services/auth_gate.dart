import 'package:company_task/view/login_page.dart';
import 'package:company_task/view/scanning_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Check if there's a valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;

        // If there's a valid session, go to the QR Scan page
        if (session != null) {
          return QrScanPage();
        } else {
          return LoginPage();  // If no valid session, show login page
        }
      },
    );
  }
}
