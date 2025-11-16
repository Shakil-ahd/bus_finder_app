import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class BusListShimmer extends StatelessWidget {
  const BusListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: context.isDarkMode
            ? Colors.grey[800]!
            : Colors.grey[300]!,
        highlightColor: context.isDarkMode
            ? Colors.grey[700]!
            : Colors.grey[100]!,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 12),
          itemCount: 8,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: context.isDarkMode
                          ? Colors.grey[600]
                          : Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 20.0,
                          color: context.isDarkMode
                              ? Colors.grey[600]
                              : Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: MediaQuery.of(context)
                                  .size
                                  .width *
                              0.6,
                          height: 16.0,
                          color: context.isDarkMode
                              ? Colors.grey[600]
                              : Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
