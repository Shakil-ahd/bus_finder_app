// lib/widgets/bus_list_shimmer.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BusListShimmer extends StatelessWidget {
  const BusListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    // --- ❗️ সমাধান: হালকা লাল শিমার ---
    final baseColor = isDark
        ? Colors.red[900]!
        : Colors.red[100]!;
    final highlightColor = isDark
        ? Colors.red[800]!
        : Colors.red[50]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 22,
              ),
              title: Container(
                height: 16.0,
                width: double.infinity,
                color: Colors.white,
              ),
              subtitle: Container(
                height: 14.0,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8.0),
                color: Colors.white,
              ),
              trailing: const Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
