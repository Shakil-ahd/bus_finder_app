// lib/screens/all_routes_page.dart
import 'package:flutter/material.dart';

class AllRoutesPage extends StatelessWidget {
  final bool isBangla;
  const AllRoutesPage({super.key, required this.isBangla});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        isBangla
            ? 'সব রুটের তালিকা এখানে আসবে'
            : 'All Routes List will go here',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
