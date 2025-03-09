import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:multi_vendor_app/frontendpage.dart';

class RiderSignupPage extends StatefulWidget {
  @override
  _RiderSignupPageState createState() => _RiderSignupPageState();
}

class _RiderSignupPageState extends State<RiderSignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController alternatePhoneController =
      TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController bikeNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool _isLoading = false;

  DateTime? selectedDate;
  XFile? selfPicture;
  XFile? idFront;
  XFile? idBack;
  XFile? bikePicture;
  XFile? billLicenseImage;

  final ImagePicker _picker = ImagePicker();

  // City and Town Dropdowns
  String selectedCity = 'Jampur';
  String? selectedTown;
  final List<String> towns = ['Traffic Chowk', 'Model Bazaar', 'New'];

  Future<void> pickImage(ImageSource source, Function(XFile?) setImage) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    setState(() {
      setImage(pickedImage);
    });
  }

  Future<void> signup() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://moodpandaa.com/public/api/rider/register');

    final Map<String, dynamic> body = {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "phone": phoneController.text,
      "date": selectedDate != null
          ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
          : "",
      "role": "Rider",
      "cnic": cnicController.text,
      "city": selectedCity,
      "alt_phone": alternatePhoneController.text,
      "town": selectedTown,
      "address": addressController.text,
      "bike_number": bikeNumberController.text,
      "bill_and_license": billLicenseImage?.path ?? "image_url",
      "picture_self": selfPicture?.path ?? "image_url",
      "id_card_front": idFront?.path ?? "image_url",
      "id_card_back": idBack?.path ?? "image_url",
      "shop_picture": bikePicture?.path ?? "image_url",
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      print("API Response: ${response.body}");

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Signup Successful: ${responseData['message']}")),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => FrontendPage()));
      } else {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup Failed: ${responseData['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rider Signup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(nameController, 'Applicant Name'),
            _buildTextField(emailController, 'Email'),
            _buildTextField(passwordController, 'Password', isPassword: true),
            _buildTextField(cnicController, 'CNIC'),
            _buildTextField(phoneController, 'Mobile Number'),
            _buildTextField(alternatePhoneController, 'Alternate Phone Number'),
            _buildTextField(locationController, 'Location'),
            _buildTextField(bikeNumberController, 'Bike Number'),

            // City Dropdown
            DropdownButtonFormField<String>(
              value: selectedCity,
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'Jampur',
                  child: Text('Jampur'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCity = value!;
                  selectedTown = null; // Reset town when city changes
                });
              },
            ),
            SizedBox(height: 16),

            // Town Dropdown
            DropdownButtonFormField<String>(
              value: selectedTown,
              decoration: InputDecoration(
                labelText: 'Town',
                border: OutlineInputBorder(),
              ),
              items: towns.map((town) {
                return DropdownMenuItem(
                  value: town,
                  child: Text(town),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTown = value;
                });
              },
            ),

            _buildTextField(addressController, 'Address'),
            SizedBox(height: 10),

            // Date Picker
            ListTile(
              title: Text(selectedDate == null
                  ? 'Select Date'
                  : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () => selectDate(context),
            ),
            SizedBox(height: 16),

            // Image Pickers with Previews
            _buildImagePicker(
                "Self Picture",
                selfPicture,
                () =>
                    pickImage(ImageSource.gallery, (img) => selfPicture = img)),
            _buildImagePicker("ID Front", idFront,
                () => pickImage(ImageSource.gallery, (img) => idFront = img)),
            _buildImagePicker("ID Back", idBack,
                () => pickImage(ImageSource.gallery, (img) => idBack = img)),
            _buildImagePicker(
                "Bike Picture",
                bikePicture,
                () =>
                    pickImage(ImageSource.gallery, (img) => bikePicture = img)),
            _buildImagePicker(
                "Bill & License",
                billLicenseImage,
                () => pickImage(
                    ImageSource.gallery, (img) => billLicenseImage = img)),
            SizedBox(
              height: 10,
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                textStyle: TextStyle(fontSize: 16),
              ),
              onPressed: signup,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Submit Form'),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(String label, XFile? image, VoidCallback onPick) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPick,
          child: Text('Pick $label'),
        ),
        if (image != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.file(File(image.path),
                height: 100, width: 100, fit: BoxFit.cover),
          ),
      ],
    );
  }
}

Widget _buildTextField(TextEditingController controller, String labelText,
    {bool isPassword = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    ),
  );
}
