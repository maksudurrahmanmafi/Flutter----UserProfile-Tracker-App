import 'package:flutter/material.dart';
import 'package:user_profile_registration/Db_helper.dart';
import 'Login.dart';

class Adduser extends StatefulWidget {
  final Map<String, dynamic>? user;

  const Adduser({super.key, this.user});

  @override
  State<StatefulWidget> createState() => AdduserState();
}

class AdduserState extends State<Adduser> {
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();

  DbHelper dbRef = DbHelper.getInstance;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      isEdit = true;
      userNameController.text = widget.user![DbHelper.COLUMN_USER_NAME] ?? '';
      emailController.text = widget.user![DbHelper.COLUMN_EMAIL] ?? '';
      addressController.text = widget.user![DbHelper.COLUMN_ADDRESS] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.value == ThemeMode.dark;
    const themeColor = Color(0xFF6A1B29);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isEdit ? 'Update User' : 'Add New User'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : const Color(0xFF1A1A2E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // User Name Input Field
            TextField(
              controller: userNameController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: _buildInputDecoration(
                labelText: 'User Name',
                icon: Icons.person_outline,
                isDark: isDark,
                themeColor: themeColor,
              ),
            ),
            const SizedBox(height: 20),

            // Email Input Field
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: _buildInputDecoration(
                labelText: 'Email Address',
                icon: Icons.email_outlined,
                isDark: isDark,
                themeColor: themeColor,
              ),
            ),
            const SizedBox(height: 20),

            // Address Input Field
            TextField(
              controller: addressController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: _buildInputDecoration(
                labelText: 'Address',
                icon: Icons.location_on_outlined,
                isDark: isDark,
                themeColor: themeColor,
              ),
            ),
            const SizedBox(height: 32),

            // Save/Update Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  var name = userNameController.text.trim();
                  var email = emailController.text.trim();
                  var address = addressController.text.trim();

                  if (name.isNotEmpty && email.isNotEmpty) {
                    bool success = false;
                    if (isEdit) {
                      int id = widget.user![DbHelper.COLUMN_ID];
                      success = await dbRef.updateData(
                          mName: name, mEmail: email, mAddress: address, id: id);
                    } else {
                      success = await dbRef.addNote(
                        mName: name,
                        mEmail: email,
                        mAddress: address,
                      );
                    }

                    if (success && mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text(
                  isEdit ? 'Update User' : 'Save User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required IconData icon,
    required bool isDark,
    required Color themeColor,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
      prefixIcon: Icon(icon, color: themeColor),
      filled: true,
      fillColor: isDark ? Colors.grey[900] : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: themeColor, width: 1.5),
      ),
    );
  }
}