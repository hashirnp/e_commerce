import 'package:e_commerce/Providers/auth_provider.dart';
import 'package:e_commerce/Providers/product_provider.dart';
import 'package:e_commerce/Screens/Auth/signin_screen.dart';
import 'package:e_commerce/Screens/profile_screen.dart';
import 'package:e_commerce/Widgets/connectivity_wrapper.dart';
import 'package:e_commerce/Widgets/item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).getProducts();
    });
    return RefreshIndicator(
      color: Colors.red,
      onRefresh: () => refresh(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Hero(
            tag: 'logo',
            child: Text(
              'E-Commerce',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {
                  'Profile',
                  'Logout',
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Consumer<ProductProvider>(builder: (context, val, _) {
          return SafeArea(
              child: ListView.builder(
                itemCount: val.products.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10),
                itemBuilder: (ctx, index) {
                  final product = val.products[index];
              
                  return ItemWidget(product: product);
                },
              ));
        }),
      ),
    );
  }

  void handleClick(String value) async {
    switch (value) {
      case 'Logout':
        final status =
            await Provider.of<MyAuthProvider>(context, listen: false).signOut();
        if (status.startsWith("success")) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const SignInScreen()));
        }
        break;

      case 'Profile':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => const ConnectivityWrapper(child: ProfileScreen())));
        break;
    }
  }

  Future<void> refresh() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).getProducts();
    });
  }
}
