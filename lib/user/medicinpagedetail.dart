import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'dart:io'; // To work with picked images

class MedicinPageDetail extends StatefulWidget {
  final int userId; // To receive the id of the selected vendor

  MedicinPageDetail({required this.userId});

  @override
  _MedicinPageDetailState createState() => _MedicinPageDetailState();
}

class _MedicinPageDetailState extends State<MedicinPageDetail> {
  File? _image; // Variable to store the selected image

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Function to pick image from gallery
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path); // Store the image file
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Details'),
        backgroundColor: Colors.grey.withOpacity(0.2), // Teal color for AppBar
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the vendor ID that was passed
            Text(
              'Vendor ID: ${widget.userId}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Image Field
            GestureDetector(
              onTap: () {
                // Open a bottom sheet to choose between gallery or camera
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Wrap(
                      children: [
                        ListTile(
                          leading: Icon(Icons.camera_alt),
                          title: Text('Camera'),
                          onTap: () {
                            _pickImage(ImageSource.camera); // Open the camera
                            Navigator.pop(context); // Close the bottom sheet
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.photo),
                          title: Text('Gallery'),
                          onTap: () {
                            _pickImage(ImageSource.gallery); // Open the gallery
                            Navigator.pop(context); // Close the bottom sheet
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                height: 200,
                color: Colors.grey.shade200,
                child: _image == null
                    ? Center(
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.grey.withOpacity(0.9),
                          size: 50,
                        ),
                      )
                    : Image.file(
                        _image!, // Display the selected image
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_image != null) {
                  // Add your image submit logic here
                  // You can upload the image to a server or process it
                } else {
                  // If no image is selected, show a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select an image')),
                  );
                }
              },
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
