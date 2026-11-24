import 'package:contact/bottom_nav_bar.dart';
import 'package:material_ui/material_ui.dart';
import 'core/app_assets.dart';
import 'core/app_theme.dart';
import 'home_screen_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<Map<String, String>> _contacts = [];

  // Add Contact
  void _addContact(
      String name,
      String email,
      String phone,
      String image,
      ) {
    setState(() {
      _contacts.add({
        'name': name,
        'email': email,
        'phone': phone,
        'image': image,
      });
    });
  }

  // Delete Contact
  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  // Show Add Contact Bottom Sheet
  void _showAddBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.primaryDarkBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) => AddContactBottomSheet(
        onAddContact: _addContact,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Image.asset(
          AppAssets.logo,
          height: 36,
        ),
      ),

      body: HomeScreenContent(
        contacts: _contacts,
        onDelete: _deleteContact,
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          if (_contacts.isNotEmpty)
            FloatingActionButton(
              heroTag: 'delete_all',
              backgroundColor: AppTheme.redDelete,
              onPressed: () {
                setState(() {
                  _contacts.clear();
                });
              },
              child: const Icon(
                Icons.delete,
                color: AppTheme.white,
              ),
            ),

          const SizedBox(height: 12),

          if (_contacts.length < 6)
            FloatingActionButton(
              heroTag: 'add_contact',
              backgroundColor: AppTheme.goldAccent,
              onPressed: _showAddBottomSheet,
              child: const Icon(
                Icons.add,
                color: AppTheme.primaryDarkBlue,
              ),
            ),
        ],
      ),
    );
  }
}