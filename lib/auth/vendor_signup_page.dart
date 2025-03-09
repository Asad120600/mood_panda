import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:multi_vendor_app/frontendpage.dart';

class VendorSignupPage extends StatefulWidget {
  @override
  _VendorSignupPageState createState() => _VendorSignupPageState();
}

class _VendorSignupPageState extends State<VendorSignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController altPhoneController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController businessCategoryController =
      TextEditingController();
  final TextEditingController avgSalesController = TextEditingController();
  final TextEditingController shopOwnershipController = TextEditingController();

  bool _isLoading = false;
  File? utilityBill,
      billAndLicense,
      pictureSelf,
      idCardFront,
      idCardBack,
      shopPicture;
  String selectedCity = 'Jampur';
  String? selectedTown;
  final List<String> towns = ['Traffic Chowk', 'Model Bazaar'];

  Future<void> pickImage(Function(File?) onImageSelected) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => onImageSelected(File(pickedFile.path)));
    }
  }

  bool validateFields() {
    return nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        altPhoneController.text.isNotEmpty &&
        cnicController.text.isNotEmpty &&
        storeNameController.text.isNotEmpty &&
        selectedCity.isNotEmpty &&
        selectedTown != null &&
        addressController.text.isNotEmpty &&
        businessCategoryController.text.isNotEmpty &&
        avgSalesController.text.isNotEmpty &&
        shopOwnershipController.text.isNotEmpty;
  }

  Future<void> signup() async {
    if (!validateFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all the fields.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://moodpandaa.com/public/api/vendor/register');
    final request = http.MultipartRequest("POST", url);

    request.fields.addAll({
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "phone": phoneController.text,
      "alt_phone": altPhoneController.text,
      "cnic": cnicController.text,
      "store_name": storeNameController.text,
      "city": selectedCity,
      "town": selectedTown!,
      "address": addressController.text,
      "business_category": businessCategoryController.text,
      "avg_sales": avgSalesController.text,
      "shop_ownership": shopOwnershipController.text,
      "date": DateTime.now().toIso8601String(),
      "role": "Vendor",
    });

    // Adding images to the request
    Future<void> addFile(String fieldName, File? file) async {
      if (file != null) {
        request.files
            .add(await http.MultipartFile.fromPath(fieldName, file.path));
      }
    }

    await addFile('utility_bill', utilityBill);
    await addFile('bill_and_license', billAndLicense);
    await addFile('picture_self', pictureSelf);
    await addFile('id_card_front', idCardFront);
    await addFile('id_card_back', idCardBack);
    await addFile('shop_picture', shopPicture);

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("Response Status: ${response.statusCode}");
      print("Response Body: $responseBody");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Signup Successful")));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => FrontendPage()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Signup Failed")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildImagePicker(
      String label, File? imageFile, Function(File?) onImagePicked) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () => pickImage(onImagePicked),
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: imageFile == null
                ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                : Image.file(imageFile, fit: BoxFit.cover),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Vendor Signup'), backgroundColor: Colors.teal),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(nameController, 'Name'),
            _buildTextField(emailController, 'Email'),
            _buildTextField(passwordController, 'Password', isPassword: true),
            _buildTextField(phoneController, 'Phone'),
            _buildTextField(altPhoneController, 'Alternate Phone'),
            _buildTextField(cnicController, 'CNIC'),
            _buildTextField(storeNameController, 'Store Name'),
            DropdownButtonFormField<String>(
              value: selectedCity,
              decoration: InputDecoration(
                  labelText: 'City', border: OutlineInputBorder()),
              items: [DropdownMenuItem(value: 'Jampur', child: Text('Jampur'))],
              onChanged: (value) => setState(() => selectedCity = value!),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedTown,
              decoration: InputDecoration(
                  labelText: 'Town', border: OutlineInputBorder()),
              items: towns
                  .map((town) =>
                      DropdownMenuItem(value: town, child: Text(town)))
                  .toList(),
              onChanged: (value) => setState(() => selectedTown = value),
            ),
            SizedBox(height: 16),
            _buildTextField(addressController, 'Address'),
            _buildTextField(businessCategoryController, 'Business Category'),
            _buildTextField(avgSalesController, 'Average Sales'),
            _buildTextField(shopOwnershipController, 'Shop Ownership'),
            _buildImagePicker(
                "Utility Bill", utilityBill, (file) => utilityBill = file),
            _buildImagePicker("Bill & License", billAndLicense,
                (file) => billAndLicense = file),
            _buildImagePicker(
                "Picture Self", pictureSelf, (file) => pictureSelf = file),
            _buildImagePicker(
                "ID Card Front", idCardFront, (file) => idCardFront = file),
            _buildImagePicker(
                "ID Card Back", idCardBack, (file) => idCardBack = file),
            _buildImagePicker(
                "Shop Picture", shopPicture, (file) => shopPicture = file),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: signup,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Submit Form'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }
}
