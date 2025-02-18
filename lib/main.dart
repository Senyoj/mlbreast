import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(JoeyApp());
}

class JoeyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InputScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();
  final TextEditingController _field3Controller = TextEditingController();
  final TextEditingController _field4Controller = TextEditingController();

  String _result = "Result will be displayed here";
  bool _isLoading = false;

  // Function to send data to the API
  void _submitData() async {
    setState(() {
      _isLoading = true;
      _result = "Processing...";
    });

    final String apiUrl = "https://72b7-102-176-94-120.ngrok-free.app/predict";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "field1": _field1Controller.text,
          "field2": _field2Controller.text,
          "field3": _field3Controller.text,
          "field4": _field4Controller.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _result =
              "Response: ${data['prediction']}"; 
        });
      } else {
        setState(() {
          _result = "Error: Failed to get response";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Error: Unable to connect to API";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ML App Input UI'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Field 1",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
                controller: _field1Controller,
                decoration: InputDecoration(hintText: 'Enter input 1')),
            SizedBox(height: 16),
            Text("Field 2",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
                controller: _field2Controller,
                decoration: InputDecoration(hintText: 'Enter input 2')),
            SizedBox(height: 16),
            Text("Field 3",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
                controller: _field3Controller,
                decoration: InputDecoration(hintText: 'Enter input 3')),
            SizedBox(height: 16),
            Text("Field 4",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
                controller: _field4Controller,
                decoration: InputDecoration(hintText: 'Enter input 4')),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitData,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Submit"),
              ),
            ),
            SizedBox(height: 24),
            Text("Result:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8)),
              child: Text(_result, style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
