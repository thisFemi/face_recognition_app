import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum DetectionStatus { noFace, fail, success }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Recognition Application',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isLoading = false;
  DetectionStatus? status;
  String url1 =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/President_Barack_Obama.jpg/220px-President_Barack_Obama.jpg"; // Replace with your demo URLs
  String url2 =
      "https://pbs.twimg.com/media/FkLYQa_XwAA9SEV?format=jpg&name=small";

  String get currentStatus {
    if (status == null) {
      return "Initializing...";
    }
    switch (status!) {
      case DetectionStatus.noFace:
        return "No Face Detected";
      case DetectionStatus.fail:
        return "Unrecognized Face Detected";
      case DetectionStatus.success:
        return "Recognition successful";
    }
  }

  Color get currentStatusColor {
    if (status == null) {
      return Colors.grey;
    }
    switch (status!) {
      case DetectionStatus.noFace:
        return Colors.grey;
      case DetectionStatus.fail:
        return Colors.red;
      case DetectionStatus.success:
        return Colors.greenAccent;
    }
  }

  Future<void> sendRecognitionRequest() async {
    setState(() {
      isLoading = true;
    });

    final data = {"url1": url1, "url2": url2};
    final response = await http.post(
      Uri.parse('https://attend-sense-b496e7923293.herokuapp.com/recognize'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: json.encode(data),
    );

    try {
      print(response);
      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

        if (responseData['data'] == null) {
          debugPrint('Server error occurred in recognizing face');
          status = DetectionStatus.noFace;
        } else {
          switch (responseData['data']) {
            case 0:
              status = DetectionStatus.noFace;
              break;
            case 1:
              status = DetectionStatus.fail;
              break;
            case 2:
              status = DetectionStatus.success;
              break;
            default:
              status = DetectionStatus.noFace;
              break;
          }
        }
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle JSON decoding errors
      debugPrint('Error decoding JSON: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Recognition Application'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                sendRecognitionRequest();
              },
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Text('Recognize Faces'),
            ),
            SizedBox(height: 20),
            Text(
              isLoading ? "Loading..." : currentStatus,
              style: TextStyle(fontSize: 20, color: currentStatusColor),
            ),
          ],
        ),
      ),
    );
  }
}
