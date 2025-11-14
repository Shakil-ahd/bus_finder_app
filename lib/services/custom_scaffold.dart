// lib/widgets/custom_scaffold.dart
import 'package:flutter/material.dart';
import '../main.dart'; // ❗️ main.dart থেকে themeNotifier ইম্পোর্ট করুন

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final bool isBangla;
  final ValueChanged<bool> onLanguageChanged;
  final Widget? bottomNavigationBar;
  final String? title;

  const CustomScaffold({
    super.key,
    required this.body,
    required this.isBangla,
    required this.onLanguageChanged,
    this.bottomNavigationBar,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    // ❗️ থিমটি ডার্ক কি না তা চেক করুন
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: title != null
            ? Text(
                title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            : null,
        actions: [
          // --- ❗️ থিম চেঞ্জ বাটন ---
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              // ❗️ Notifier-এর ভ্যালু পরিবর্তন করুন
              themeNotifier.value = isDark
                  ? ThemeMode.light
                  : ThemeMode.dark;
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.language,
              color: Colors.white,
            ),
            onPressed: () => onLanguageChanged(!isBangla),
          ),
        ],
      ),
      body: Container(
        // --- ❗️ ডার্ক এবং লাইট মোডের জন্য আলাদা গ্রেডিয়েন্ট ---
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    // ডার্ক মোড: ব্লু ও পার্পল
                    Color(0xFF020024), // খুবই ডার্ক ব্লু
                    Color(0xFF090979), // নেভি ব্লু
                    Color(0xFF4a004a), // ডার্ক পার্পল
                  ]
                : [
                    // লাইট মোড: ব্লু ও পিঙ্ক
                    Color(0xFF87CEEB), // Light Sky Blue
                    Color(0xFFDA70D6), // Orchid Pink
                  ],
          ),
        ),
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
