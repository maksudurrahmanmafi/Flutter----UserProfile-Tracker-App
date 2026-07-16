import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_profile_registration/AddUser.dart';
import 'package:user_profile_registration/Db_helper.dart';

import 'DetailsScreen.dart';
import 'Login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String displayName = 'User';
  List<Map<String, dynamic>> userList = [];
  DbHelper dbRef = DbHelper.getInstance;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    loadUser();
  }


  void _loadUsername() async {
    var pref = await SharedPreferences.getInstance();
    setState(() {
      displayName = pref.getString(LoginScreenState.USERNAME_KEY) ?? 'User';
    });
  }

  void _logout() async {
    var pref = await SharedPreferences.getInstance();
    await pref.remove(LoginScreenState.LOGIN_KEY);
    await pref.remove(LoginScreenState.USERNAME_KEY);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void loadUser() async {
    userList = await dbRef.FetchAllNote();
    setState(() {

    });
  }

  void _toggleTheme() async {
    var pref = await SharedPreferences.getInstance();
    if (themeNotifier.value == ThemeMode.light) {
      themeNotifier.value = ThemeMode.dark;
      await pref.setBool(LoginScreenState.THEME_KEY, true);
    }
    else {
      themeNotifier.value = ThemeMode.light;
      await pref.setBool(LoginScreenState.THEME_KEY, false);
    }
  }

  @override
  Widget build(BuildContext context) {

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $displayName! 👋',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                       Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1A1A2E),                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF6A1B29).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF6A1B29)),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF6A1B29).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.logout, color: Color(0xFF6A1B29)),
                          onPressed: _logout,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF6A1B29).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(onPressed: () {
                          setState(() {
                            _toggleTheme();
                          });
                        }, icon: Icon(
                          themeNotifier.value == ThemeMode.dark
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: const Color(0xFF6A1B29),
                        ),),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A1B29), Color(0xFF1A1A2E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6A1B29).withOpacity(0.3),
                      blurRadius: 13,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overview Status',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Employee Details tracker',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text('ALL USERS : ${userList.length} ', style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),),

                  ],


                ),

              ),
              SizedBox(height: 30,),
              userList.isEmpty ? const Center(child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                    'No users found!!', style: TextStyle(color: Colors.grey)),
              )) : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(
                          user: userList[index],
                        ),));


                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                          color: const Color(0xFF5A1B24),
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Colors.greenAccent,
                              child: const Icon(Icons.person,
                                  color: Colors.white)),
                          title: Text(
                            userList[index][DbHelper.COLUMN_USER_NAME] ?? '',
                            style: const TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            userList[index][DbHelper.COLUMN_EMAIL] ?? '',
                            style: const TextStyle(color: Colors.white38),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        Adduser(user: userList[index]))).then((
                                    value) => loadUser());
                              },
                                  icon: const Icon(
                                      Icons.edit, color: Colors.greenAccent)),
                              IconButton(onPressed: () async {
                                int id = userList[index][DbHelper.COLUMN_ID];

                                bool isDelete = await dbRef.deleteData(id: id);

                                if (isDelete) {
                                  loadUser();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text(
                                          'User deleted successfully!')),
                                    );
                                  }
                                }
                              },
                                  icon: const Icon(
                                      Icons.delete, color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                    );
                  })


            ]


          ),

        ),

      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          backgroundColor: Color(0xFF5A1B24),
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Adduser()),).then((
                value) {
              loadUser();
            });
          },
          child: const Icon(Icons.add, color: Colors.white),),
      ),


    );
  }


}