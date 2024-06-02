import 'package:e_commerce/Services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Consumer<ConnectivityService>(
          builder: (context, connectivity, _) {
            if (!connectivity.hasInternet) {
              return Container(
                color: Colors.black54,
                child: Center(
                  child: AlertDialog(
                    title: const Text('No Internet Connection'),
                    content: const Text('Please check your internet settings.'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          // Optionally provide an action to open settings
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
