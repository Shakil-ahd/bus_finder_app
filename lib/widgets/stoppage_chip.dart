import 'package:figma/constants/colors/app_colors.dart';
import 'package:flutter/material.dart';

class StoppageChip extends StatelessWidget {
  final String label;
  final Gradient gradient;

  const StoppageChip({
    super.key,
    required this.label,
    this.gradient = AppColors.primaryGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
