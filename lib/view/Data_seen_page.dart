import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayDataPage extends StatefulWidget {
  const DisplayDataPage({super.key});

  @override
  State<DisplayDataPage> createState() => _DisplayDataPageState();
}

class _DisplayDataPageState extends State<DisplayDataPage> {
  String? name, date, time, jobRole, imagePath;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      date = prefs.getString('date');
      time = prefs.getString('time');
      jobRole = prefs.getString('jobRole');
      imagePath = prefs.getString('imagePath');
      if (imagePath != null) {
        imageFile = File(imagePath!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Data"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: name == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Name: $name"),
                  _buildLabel("Date: $date"),
                  _buildLabel("Time: $time"),
                  _buildLabel("Job Role: $jobRole"),
                  const SizedBox(height: 20),
                  imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(imageFile!, height: 200))
                      : const Text("No image available"),
                ],
              ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}
