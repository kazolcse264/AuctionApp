import 'package:auction_app/pages/create_auction_page.dart';
import 'package:auction_app/pages/launcher_page.dart';
import 'package:auction_app/pages/login_page.dart';
import 'package:auction_app/pages/posted_item_list_page.dart';
import 'package:auction_app/pages/product_details_page.dart';
import 'package:auction_app/pages/signup_screen.dart';
import 'package:auction_app/pages/user_profile_page.dart';
import 'package:auction_app/pages/veiw_product_page.dart';
import 'package:auction_app/providers/product_provider.dart';
import 'package:auction_app/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auction App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName: (context) => const LauncherPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        SignUpPage.routeName: (context) => const SignUpPage(),
        ViewProductPage.routeName: (context) => const ViewProductPage(),
        ProductDetailsPage.routeName: (context) => const ProductDetailsPage(),
        CreateAuctionPage.routeName: (context) => const CreateAuctionPage(),
        UserProfilePage.routeName: (context) => const UserProfilePage(),
        PostedItemListPage.routeName: (context) => const PostedItemListPage(),

      },
    );
  }
}


