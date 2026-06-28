import 'package:flutter/material.dart';

import 'package:poliklinik/widgets/auth/login_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_hospital,
                  size: 60,
                ),
                SizedBox(height: 10),
                Text(
                  "POLIKLINIK",
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginPage(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
