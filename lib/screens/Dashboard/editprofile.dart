// editprofile.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../class/api_service.dart';
import '../../class/auth_service.dart';
import '../../class/jwt_helper.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic>? user;
  final Function(Map<String, dynamic>)? onProfileUpdate;

  const EditProfilePage({
    super.key,
    this.user,
    this.onProfileUpdate,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _websiteController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Pre-fill controllers with the logged-in user's current details
    // If a field is missing from user data, it defaults to an empty string
    _firstNameController = TextEditingController(text: widget.user?['first_name'] ?? '');
    _lastNameController = TextEditingController(text: widget.user?['last_name'] ?? '');
    _usernameController = TextEditingController(text: widget.user?['username'] ?? '');
    _bioController = TextEditingController(text: widget.user?['bio'] ?? '');  // Add 'bio' to your user data if needed
    _websiteController = TextEditingController(text: widget.user?['website'] ?? '');  // Add 'website' to your user data if needed
  }



  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    super.dispose();
  }



  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);



    // Simulate API call or update logic here
    // For now, we'll just update local state and save to SharedPreferences
    final updatedUser = {
      ...?widget.user,
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'username': _usernameController.text,
      'bio': _bioController.text,
      'website': _websiteController.text,
      // Note: Profile picture update would require uploading to server
      // For demo, we'll just keep the local file reference
    };

    dynamic response = await ApiService().updateUser(updatedUser);
    print(response.data);

    // Save to SharedPreferences (you might want to update JWT or call API)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('first_name', _firstNameController.text);
    await prefs.setString('last_name', _lastNameController.text);
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('bio', _bioController.text);
    await prefs.setString('website', _websiteController.text);

    // Call onProfileUpdate if provided
    widget.onProfileUpdate?.call(updatedUser);

    setState(() => _isLoading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Done',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (widget.user?['profile_pic'] != null
                          ? NetworkImage('https://pub-bcb5a51a1259483e892a2c2993882380.r2.dev/images/avatar.png')
                          : const AssetImage('assets/images/personal.png')) as ImageProvider,
                ),
                GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // First Name
            _buildTextField(
              controller: _firstNameController,
              label: 'First Name',
              hint: 'Enter your first name',
            ),
            const SizedBox(height: 16),

            // Last Name
            _buildTextField(
              controller: _lastNameController,
              label: 'Last Name',
              hint: 'Enter your last name',
            ),
            const SizedBox(height: 16),

            // Username
            _buildTextField(
              controller: _usernameController,
              label: 'Username',
              hint: 'Enter your username',
            ),
            const SizedBox(height: 16),

            // Bio
            _buildTextField(
              controller: _bioController,
              label: 'Bio',
              hint: 'Tell us about yourself',
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Website
            _buildTextField(
              controller: _websiteController,
              label: 'Website',
              hint: 'https://example.com',
            ),
            const SizedBox(height: 30),

            // Note about changes
            const Text(
              'Changes will be reflected across your account.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}
