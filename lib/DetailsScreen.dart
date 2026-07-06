import 'package:flutter/material.dart';

import 'Db_helper.dart';
import 'Login.dart';

class DetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? user;

  const DetailsScreen({super.key, required this.user});

  @override
  State<DetailsScreen> createState() => DetailsScreenState();
}

class DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.user == null) {
      return const Scaffold(
        body: Center(child: Text('No User Data Found!')),
      );
    }
    final isDark = themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('User Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : const Color(0xFF1A1A2E),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    CircleAvatar(
                      radius:40 ,
                      backgroundColor: Color(0xFF5A1B24),
                      child: Icon(Icons.person , size: 40,color: Colors.white,),
                    ),
                    SizedBox(height: 16),

                    Text(
                      widget.user![DbHelper.COLUMN_USER_NAME] ?? 'Unknown User',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Color(0xFF1A1A2E),),
                    ),

                    Divider(height: 32, thickness: 1),


                    _buildInfoTile(
                      icon: Icons.email_outlined,
                      label: 'Email Address',
                      value: widget.user![DbHelper.COLUMN_EMAIL] ?? 'N/A',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16), // দুটি টাইলের মাঝে গ্যাপের জন্য
                    _buildInfoTile(
                      icon: Icons.location_on_outlined,
                      label: 'Address',
                      value: widget.user![DbHelper.COLUMN_ADDRESS] ??
                          'No Address Provided',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFF5A1B24), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            ),
          ),

        ]

    );
  }
}