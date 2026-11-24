import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:material_ui/material_ui.dart' as flutter;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:country_picker/country_picker.dart';

import 'core/app_theme.dart';

class AddContactBottomSheet extends StatefulWidget {
  final Function(
      String name,
      String email,
      String phone,
      String image,
      ) onAddContact;

  const AddContactBottomSheet({
    super.key,
    required this.onAddContact,
  });

  @override
  State<AddContactBottomSheet> createState() =>
      _AddContactBottomSheetState();
}

class _AddContactBottomSheetState
    extends State<AddContactBottomSheet> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Country selectedCountry = Country.parse('EG');

  String? selectedImage;

  // Choose Image
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      final directory =
      await getApplicationDocumentsDirectory();

      final fileName =
          '${DateTime.now().microsecondsSinceEpoch}.jpg';

      final savedImage = await File(pickedFile.path).copy(
        '${directory.path}/$fileName',
      );

      if (!mounted) return;

      setState(() {
        selectedImage = savedImage.path;
      });

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not select image'),
        ),
      );
    }
  }

  // Image Options
  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.primaryDarkBlue,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppTheme.goldAccent,
                ),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: AppTheme.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: AppTheme.goldAccent,
                ),
                title: const Text(
                  'Open Camera',
                  style: TextStyle(color: AppTheme.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Select Country
  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        backgroundColor: AppTheme.primaryDarkBlue,
        textStyle: const flutter.TextStyle(
          color: AppTheme.white,
        ),
        searchTextStyle: const flutter.TextStyle(
          color: AppTheme.white,
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country;
        });
      },
    );
  }
  // Add Contact
  void _addContact() {
    String phone = _phoneController.text.trim();

    String nationalNumber =
    phone.replaceAll(RegExp(r'[^0-9]'), '');

    if (nationalNumber.startsWith('0')) {
      nationalNumber = nationalNumber.substring(1);
    }

    if (_nameController.text.trim().isEmpty ||
        nationalNumber.isEmpty) {
      _showMessage('Please enter name and phone number');
      return;
    }

    String fullPhone =
        '+${selectedCountry.phoneCode}$nationalNumber';

    if (fullPhone.length < 8 || fullPhone.length > 16) {
      _showMessage('Please enter a valid phone number');
      return;
    }

    widget.onAddContact(
      _nameController.text.trim(),
      _emailController.text.trim(),
      fullPhone,
      selectedImage ?? '',
    );

    Navigator.pop(context);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Text(
              'Add New Contact',
              style: TextStyle(
                color: AppTheme.goldAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Contact Image
            GestureDetector(
              onTap: _showImageOptions,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.goldAccent,
                    width: 2,
                  ),
                ),
                child: selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(
                    File(selectedImage!),
                    fit: BoxFit.cover,
                  ),
                )
                    : const Icon(
                  Icons.person,
                  size: 65,
                  color: AppTheme.primaryDarkBlue,
                ),
              ),
            ),

            TextButton.icon(
              onPressed: _showImageOptions,
              icon: const Icon(
                Icons.add_a_photo,
                color: AppTheme.goldAccent,
              ),
              label: const Text(
                'Add Photo (Optional)',
                style: TextStyle(
                  color: AppTheme.goldAccent,
                ),
              ),
            ),

            const SizedBox(height: 12),

            _buildTextField(
              _nameController,
              'Enter User Name',
            ),

            const SizedBox(height: 12),

            _buildTextField(
              _emailController,
              'Enter User Email',
            ),

            const SizedBox(height: 12),

            // Country Selector
            GestureDetector(
              onTap: _selectCountry,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.goldAccent,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(
                      selectedCountry.flagEmoji,
                      style: const TextStyle(fontSize: 22),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        selectedCountry.name,
                        style: const TextStyle(
                          color: AppTheme.goldAccent,
                        ),
                      ),
                    ),

                    Text(
                      '+${selectedCountry.phoneCode}',
                      style: const TextStyle(
                        color: AppTheme.goldAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Icon(
                      Icons.arrow_drop_down,
                      color: AppTheme.goldAccent,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            _buildTextField(
              _phoneController,
              'Enter Phone Number',
              isPhone: true,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.goldAccent,
                minimumSize: const Size(
                  double.infinity,
                  50,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _addContact,
              child: const Text(
                'Add Contact',
                style: AppTheme.bodyMedium,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hint, {
        bool isPhone = false,
      }) {
    return TextField(
      controller: controller,
      keyboardType: isPhone
          ? TextInputType.phone
          : TextInputType.text,
      style: const TextStyle(
        color: AppTheme.goldAccent,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTheme.hintStyle,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppTheme.goldAccent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppTheme.goldAccent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
