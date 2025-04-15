import 'package:company_task/services/auth_gate.dart';
import 'package:company_task/view/data_enter_page.dart';
import 'package:company_task/view/login_page.dart';
import 'package:company_task/view/scanning_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp1ZXR4ZmZ6em53dW5rbGZyandzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQyNTc0MjUsImV4cCI6MjA1OTgzMzQyNX0.w4XwdfO642QzTvYTyCTzKSJXGwZbSXbi72cDkujqhyo",
  url: "https://juetxffzznwunklfrjws.supabase.co");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
