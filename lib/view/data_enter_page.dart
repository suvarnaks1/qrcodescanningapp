import 'dart:io';
import 'package:company_task/services/auth_service.dart';
import 'package:company_task/view/Data_seen_page.dart';
import 'package:company_task/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DataEnterPage extends StatefulWidget {
  const DataEnterPage({super.key});

  @override
  State<DataEnterPage> createState() => _DataEnterPageState();
}

class _DataEnterPageState extends State<DataEnterPage> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedDate;
  String? _selectedTime;
  String? _selectedJobRole;
  File? _imageFile;

  final List<String> _jobRoles = [
    'Developer',
    'Designer',
    'Tester',
    'Manager',
    'Support',
  ];

  final AuthService _authService = AuthService(); // Create instance of AuthService

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _selectedDate = prefs.getString('date');
      _selectedTime = prefs.getString('time');
      _selectedJobRole = prefs.getString('jobRole');
      final imagePath = prefs.getString('imagePath');
      if (imagePath != null) {
        _imageFile = File(imagePath);
      }
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('date', _selectedDate ?? '');
    await prefs.setString('time', _selectedTime ?? '');
    await prefs.setString('jobRole', _selectedJobRole ?? '');
    if (_imageFile != null) {
      await prefs.setString('imagePath', _imageFile!.path);
    }
  }

  Future<void> _pickDate() async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2023, 1, 1),
        maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
      setState(() {
        _selectedDate = "${date.day}/${date.month}/${date.year}";
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  Future<void> _pickTime() async {
    DatePicker.showTimePicker(context, showTitleActions: true,
        onConfirm: (time) {
      setState(() {
        _selectedTime = "${time.hour}:${time.minute}";
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() async {
    if (_nameController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _selectedJobRole == null ||
        _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    await _saveData();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data saved successfully!')),
    );

    print("Name: ${_nameController.text}");
    print("Date: $_selectedDate");
    print("Time: $_selectedTime");
    print("Job Role: $_selectedJobRole");
    print("Image: ${_imageFile!.path}");
  }

  // Sign out logic
  Future<void> _signOut() async {
    try {
      await _authService.signOut(); // Call the signOut method from AuthService
      // Navigate to the login page after signing out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()), // Replace with your LoginPage
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Details"),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut, // Call signOut when logout icon is pressed
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(_selectedDate ?? "Pick a Date"),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            ListTile(
              title: Text(_selectedTime ?? "Pick a Time"),
              trailing: const Icon(Icons.access_time),
              onTap: _pickTime,
            ),
            DropdownButtonFormField<String>(
              value: _selectedJobRole,
              decoration: const InputDecoration(
                labelText: 'Select Job Role',
                border: OutlineInputBorder(),
              ),
              items: _jobRoles.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedJobRole = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_imageFile!, height: 200))
                : const Text("No image selected"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Camera"),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
              
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DisplayDataPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "View Saved Data",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
