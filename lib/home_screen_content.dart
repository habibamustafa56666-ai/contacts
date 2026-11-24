import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'core/app_assets.dart';
import 'core/app_theme.dart';

class HomeScreenContent extends StatelessWidget {
  final List<Map<String, String>> contacts;
  final void Function(int) onDelete;

  const HomeScreenContent({
    super.key,
    required this.contacts,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.emptyContacts,
              width: 220,
            ),
            const SizedBox(height: 16),
            const Text(
              'There is No Contacts Added Here',
              style: AppTheme.titleLarge,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.68,
      ),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        final imagePath = contact['image'] ?? '';

        return Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // Contact Image and Name
              Expanded(
                flex: 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [

                    imagePath.isNotEmpty &&
                        File(imagePath).existsSync()
                        ? Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    )
                        : Container(
                      color: AppTheme.lightBlue,
                      child: const Icon(
                        Icons.person,
                        size: 80,
                        color: AppTheme.primaryDarkBlue,
                      ),
                    ),

                    // Name Box
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          contact['name'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Contact Information
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          const Icon(
                            Icons.email,
                            size: 19,
                            color: AppTheme.primaryDarkBlue,
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              contact['email'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.bodyMedium.copyWith(
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 19,
                            color: AppTheme.primaryDarkBlue,
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              contact['phone'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.bodyMedium.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.redDelete,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => onDelete(index),
                          icon: const Icon(
                            Icons.delete,
                            size: 16,
                            color: AppTheme.white,
                          ),
                          label: const Text(
                            'Delete',
                            style: TextStyle(
                              color: AppTheme.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}