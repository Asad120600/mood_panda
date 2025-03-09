import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddVendorPage extends StatefulWidget {
  final String userName;

  AddVendorPage({Key? key, required this.userName}) : super(key: key);

  @override
  _AddVendorPageState createState() => _AddVendorPageState();
}

class _AddVendorPageState extends State<AddVendorPage> {
  final TextEditingController _vendorNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  File? _image;
  int? _selectedCategory;
  int? _selectedplateform;
  int? _selectedMenu;

  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _plateforms = [];
  List<Map<String, dynamic>> _menus = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchplateforms();
    _fetchMenus();
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse('https://moodpandaa.com/public/api/addcategory'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _categories = List<Map<String, dynamic>>.from(data['category']);
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> _fetchplateforms() async {
    final response = await http.get(Uri.parse('https://moodpandaa.com/public/api/addplateform'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _plateforms = List<Map<String, dynamic>>.from(data['plateform']);
      });
    } else {
      throw Exception('Failed to load plateforms');
    }
  }

  Future<void> _fetchMenus() async {
    final response = await http.get(Uri.parse('https://moodpandaa.com/public/api/addmenu'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _menus = List<Map<String, dynamic>>.from(data['menu']);
      });
    } else {
      throw Exception('Failed to load menus');
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera) ;
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Future<void> _submitData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('auth_token');
  //   String? userId = prefs.getString('user_id');  // Get the user ID from SharedPreferences

  //   if (token == null || userId == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Token or User ID is missing')));
  //     return;
  //   }

  //   final request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse('https://moodpandaa.com/public/api/store/product'),
  //   );
  //   request.headers.addAll({
  //     "Authorization": "Bearer $token",
  //     "Accept": "application/json"
  //   });
  //   request.fields['user_id'] = userId; // Send the user_id with the request
  //   request.fields['store_name'] = _vendorNameController.text;
  //   request.fields['category_id'] = _selectedCategory.toString();
  //   request.fields['plateform_id'] = _selectedplateform.toString();
  //   request.fields['menu_id'] = _selectedMenu.toString();
  //   request.fields['city'] = _cityController.text;
  //   request.fields['price'] = _priceController.text;

  //   if (_image != null) {
  //     request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
  //   }

  //   final response = await request.send();

  //   if (response.statusCode == 201) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vendor added successfully')));
  //   } else {
  //     response.stream.bytesToString().then((responseBody) {
  //       print('Failed to add vendor: $responseBody');
  //     });
  //   }
  // }
  
  

  Future<void> _submitData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');
  var userId = prefs.get('user_id'); // Can be either String or int

  // If userId is an int, convert it to String
  if (userId is int) {
    userId = userId.toString();
  }

  if (token == null || userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Token or User ID is missing')));
    return;
  }

  final request = http.MultipartRequest(
    'POST',
    Uri.parse('https://moodpandaa.com/public/api/store/product'),
  );
  request.headers.addAll({
    "Authorization": "Bearer $token",
    "Accept": "application/json"
  });
  request.fields['user_id'] = userId.toString(); // Send the user_id with the request
  request.fields['store_name'] = _vendorNameController.text;
  request.fields['category_id'] = _selectedCategory.toString();
  request.fields['plateform_id'] = _selectedplateform.toString();
  request.fields['menu_id'] = _selectedMenu.toString();
  request.fields['city'] = _cityController.text;
  request.fields['price'] = _priceController.text;

  if (_image != null) {
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
  }

  final response = await request.send();

  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vendor added successfully')));
  } else {
    response.stream.bytesToString().then((responseBody) {
      print('Failed to add vendor: $responseBody');
    });
  }
}

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Vendor')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: TextEditingController(text: widget.userName),
                decoration: InputDecoration(labelText: 'User ID', border: OutlineInputBorder()),
                readOnly: true,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _vendorNameController,
                decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedCategory,
                hint: Text('Select Category'),
                items: _categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category['id'],
                    child: Text(category['name']),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedplateform,
                hint: Text('Select plateform'),
                items: _plateforms.map((plateform) {
                  return DropdownMenuItem<int>(
                    value: plateform['id'],
                    child: Text(plateform['name']),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedplateform = newValue;
                  });
                },
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedMenu,
                hint: Text('Select Menu'),
                items: _menus.map((menu) {
                  return DropdownMenuItem<int>(
                    value: menu['id'],
                    child: Text(menu['name']),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedMenu = newValue;
                  });
                },
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
             SizedBox(height: 16),
if (_image != null)
  Container(
    width: 150,
    height: 150,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Image.file(
      _image!,
      fit: BoxFit.cover,
    ),
  ),
SizedBox(height: 16),
ElevatedButton.icon(
  onPressed: _pickImage,
  icon: Icon(Icons.camera_alt),
  label: Text('Pick Image'),
),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Add Vendor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
