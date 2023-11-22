# face_recognition_flutter

A complete flutter application of using face recognition using Python for backend.

The Python was published on heroku using flask framework.
link: https://attend-sense-b496e7923293.herokuapp.com/

## Backend
The backend code is avaliable here:

https://github.com/thisFemi/face_recognition_python


## How to use in your flutter project?

  Future<void> sendRecognitionRequest(String url1, String url2) async {
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
     
    }
  }
  
## Video Tutorial
Coming soon...
