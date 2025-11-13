// lib/widgets/bus_list_shimmer.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BusListShimmer extends StatelessWidget {
  const BusListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Shimmer.fromColors ব্যবহার করে আমরা একটি অ্যানিমেশন তৈরি করি
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, // লোডিং এর বেস কালার
      highlightColor:
          Colors.grey[100]!, // অ্যানিমেশনের হাইলাইট কালার
      child: ListView.builder(
        itemCount: 8, // আমরা ৮টি ডামি লোডিং কার্ড দেখাবো
        itemBuilder: (context, index) {
          // এটি আপনার Bus Card-এর একটি 'ভূত' বা 'প্লেস-হোল্ডার' ডিজাইন
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 24,
              ),
              title: Container(
                height: 16.0,
                width: double.infinity,
                color: Colors.white,
              ),
              subtitle: Container(
                height: 12.0,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8.0),
                color: Colors.white,
              ),
              trailing: Container(
                height: 16.0,
                width: 40.0,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
