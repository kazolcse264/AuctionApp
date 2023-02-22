import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../custom_widgets/main_drawer.dart';
import '../custom_widgets/product_grid_item_view.dart';
import '../providers/product_provider.dart';
import '../providers/user_provider.dart';
import 'create_auction_page.dart';
import 'launcher_page.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = '/view_product';

  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  @override
  void didChangeDependencies() {
    Provider.of<ProductProvider>(context, listen: false)
        .getAllAuctionProducts();
    Provider.of<UserProvider>(context, listen: false).getUserInfo();
    Provider.of<UserProvider>(context, listen: false)
        .getAllProductsByUserId(AuthService.currentUser!.uid);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      drawer: MainDrawer(
        userProvider: userProvider,
      ),
      appBar: AppBar(
        title: const Text('All Products'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              right: 8.0,
              bottom: 8.0,
            ),
            child: FloatingActionButton.extended(
              label: const Text(
                'Create Auction',
                style: TextStyle(
                  fontSize: 12,
                ),
              ), // <-- Text
              backgroundColor: Colors.black12,
              icon: const Icon(
                // <-- Icon
                Icons.add,
                size: 16.0,
              ),
              onPressed: () {
                Navigator.pushNamed(context, CreateAuctionPage.routeName);
              },
            ),
          ),
          InkWell(
            onTap: () {
              AuthService.logout().then((value) =>
                  Navigator.pushReplacementNamed(
                      context, LauncherPage.routeName));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 18.0),
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: provider.auctionProductList.length,
                      itemBuilder: (context, index) {
                        final product = provider.auctionProductList[index];
                        return ProductGridItemView(
                          productModel: product,
                        );
                      })),
            ],
          ),
        );
      }),
    );
  }
}
