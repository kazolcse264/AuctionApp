import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_service.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../utils/widget_functions.dart';
import 'launcher_page.dart';

class UserProfilePage extends StatefulWidget {
  static const String routeName = '/add_user';

  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.logout().then((value) =>
                  Navigator.pushReplacementNamed(
                      context, LauncherPage.routeName));
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: userProvider.userModel == null
          ? const Center(child: Text('Failed to load user Data!'))
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: const Color(0xFF2B2B2B).withOpacity(0.5),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 60,
                            child: (userProvider.userModel == null)
                                ? Image.asset('assets/images/profile.png')
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(userProvider
                                            .userModel!.imageUrl ??
                                        'https://avatars.githubusercontent.com/u/74205867?v=4'),
                                    radius: 60,
                                  ),
                          ),
                          Positioned(
                            left: 100,
                            right: 0,
                            top: 80,
                            child: CircleAvatar(
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add_a_photo,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.person),
                              label: const Text(
                                'PROFILE',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white,
                    child: (userProvider.userModel == null)
                        ? null
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('Full Name'),
                                subtitle: Text(
                                    userProvider.userModel!.displayName ??
                                        'Not Set Yet'),
                                trailing: IconButton(
                                  onPressed: () {
                                    showSingleTextFieldInputDialog(
                                      context: context,
                                      title: 'Full Name',
                                      onSubmit: (value) {
                                        userProvider.updateUserProfileField(
                                            userFieldDisplayName, value);
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                              ListTile(
                                title: const Text('Phone'),
                                subtitle: Text(userProvider.userModel!.phone ??
                                    'Not Set Yet'),
                                trailing: IconButton(
                                  onPressed: () {
                                    showSingleTextFieldInputDialog(
                                      context: context,
                                      title: 'Phone',
                                      onSubmit: (value) {
                                        userProvider.updateUserProfileField(
                                            userFieldPhone, value);
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                              ListTile(
                                title: const Text('Email Address'),
                                subtitle: Text(userProvider.userModel!.email),
                              ),
                              ListTile(
                                title: const Text('Age'),
                                subtitle: (userProvider.userModel!.age == null)
                                    ? const Text('Not Set Yet')
                                    : Text(
                                        userProvider.userModel!.age.toString(),
                                      ),
                                trailing: IconButton(
                                  onPressed: () {
                                    showSingleTextFieldInputDialog(
                                      context: context,
                                      title: 'Age',
                                      onSubmit: (value) {
                                        userProvider.updateUserProfileField(
                                            userFieldAge, value);
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                              ListTile(
                                title: const Text('Gender'),
                                subtitle: Text(userProvider.userModel!.gender ??
                                    'Not Set Yet'),
                                trailing: IconButton(
                                  onPressed: () {
                                    showSingleTextFieldInputDialog(
                                      context: context,
                                      title: 'Gender',
                                      onSubmit: (value) {
                                        userProvider.updateUserProfileField(
                                            userFieldGender, value);
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                //_headerSection(context, userProvider),
                /*  ListTile(
                  leading: const Icon(Icons.call),
                  title: Text(userProvider.userModel!.phone ?? 'Not Set Yet'),
                  trailing: IconButton(
                    onPressed: () {
                      showSingleTextFieldInputDialog(
                        context: context,
                        title: 'Mobile Number',
                        onSubmit: (value) {
                          Navigator.pushNamed(
                              context, OtpVerificationPage.routeName,
                              arguments: value);
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),*/
                /*ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: Text(userProvider.userModel!.age ?? 'Not Set Yet'),
                  subtitle: const Text('Date of Birth'),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(userProvider.userModel!.gender ?? 'Not Set Yet'),
                  subtitle: const Text('Gender'),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                  ),
                ),*/
                /*  ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(
                      userProvider.userModel!.addressModel?.addressLine1 ??
                          'Not Set Yet'),
                  subtitle: const Text('Address Line 1'),
                  trailing: IconButton(
                    onPressed: () {
                      showSingleTextFieldInputDialog(
                        context: context,
                        title: 'Address Line 1',
                        onSubmit: (value) {
                          userProvider.updateUserProfileField(
                              '$userFieldAddressModel.$addressFieldAddressLine1',
                              value);
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(
                      userProvider.userModel!.addressModel?.addressLine2 ??
                          'Not Set Yet'),
                  subtitle: const Text('Address Line 2'),
                  trailing: IconButton(
                    onPressed: () {
                      showSingleTextFieldInputDialog(
                        context: context,
                        title: 'Address Line 2',
                        onSubmit: (value) {
                          userProvider.updateUserProfileField(
                              '$userFieldAddressModel.$addressFieldAddressLine2',
                              value);
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(userProvider.userModel!.addressModel?.city ??
                      'Not Set Yet'),
                  subtitle: const Text('City'),
                  trailing: IconButton(
                    onPressed: () {
                      showSingleTextFieldInputDialog(
                        context: context,
                        title: 'City',
                        onSubmit: (value) {
                          userProvider.updateUserProfileField(
                              '$userFieldAddressModel.$addressFieldCity',
                              value);
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(userProvider.userModel!.addressModel?.zipcode ??
                      'Not Set Yet'),
                  subtitle: const Text('Zip Code'),
                  trailing: IconButton(
                    onPressed: () {
                      showSingleTextFieldInputDialog(
                        context: context,
                        title: 'Zip Code',
                        onSubmit: (value) {
                          userProvider.updateUserProfileField(
                              '$userFieldAddressModel.$addressFieldZipcode',
                              value);
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),*/
              ],
            ),
    );
  }
}
