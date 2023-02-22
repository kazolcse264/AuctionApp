import 'package:auction_app/custom_widgets/user_profile_image_section.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../pages/launcher_page.dart';
import '../pages/posted_item_list_page.dart';
import '../pages/user_profile_page.dart';
import '../providers/user_provider.dart';

class MainDrawer extends StatelessWidget {
  final UserProvider userProvider;

  const MainDrawer({Key? key, required this.userProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 150,
            color: Theme.of(context).primaryColor,
            child: UserProfileImageSection(userProvider: userProvider),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, UserProfilePage.routeName);
            },
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(
                context,
                PostedItemListPage.routeName,
              );
            },
            leading: const Icon(Icons.shopping_cart),
            title: Text('My Posted Items ${userProvider.productList.length}'),
          ),
          ListTile(
            onTap: () {
              AuthService.logout().then((value) =>
                  Navigator.pushReplacementNamed(
                      context, LauncherPage.routeName));
            },
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
