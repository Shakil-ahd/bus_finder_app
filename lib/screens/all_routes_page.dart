// lib/screens/all_routes_page.dart
import 'package:figma/screens/bus_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/bus_data.dart';
import '../models/bus_model.dart';
import '../services/favorite_service.dart';

// import '../widgets/custom_scaffold.dart'; // ❗️ main.dart থেকে হ্যান্ডেল হবে

class AllRoutesPage extends StatefulWidget {
  final bool isBangla;
  final FavoriteService favoriteService;

  const AllRoutesPage({
    super.key,
    required this.isBangla,
    required this.favoriteService,
  });

  @override
  State<AllRoutesPage> createState() =>
      _AllRoutesPageState();
}

class _AllRoutesPageState extends State<AllRoutesPage> {
  late List<BusModel> _displayBuses;

  @override
  void initState() {
    super.initState();
    _displayBuses = List.from(
      busList,
    ); // সব বাস প্রথমে দেখাবে
  }

  // ❗️ ভাষা পরিবর্তন হলে লিস্ট আবার রিফ্রেশ করার জন্য
  @override
  void didUpdateWidget(covariant AllRoutesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isBangla != widget.isBangla) {
      _displayBuses = List.from(busList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          height:
              kToolbarHeight +
              MediaQuery.of(context).padding.top,
        ), // AppBar এর নিচে গ্যাপ

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(
              16.0,
            ), // পুরো লিস্টে প্যাডিং
            itemCount: _displayBuses.length,
            itemBuilder: (context, index) {
              final bus = _displayBuses[index];
              final name = widget.isBangla
                  ? bus.nameBn
                  : bus.nameEn;
              final from = widget.isBangla
                  ? bus.fromBn
                  : bus.fromEn;
              final to = widget.isBangla
                  ? bus.toBn
                  : bus.toEn;
              final isFav = widget.favoriteService
                  .isFavorite(bus.nameEn);
              final fare = widget.isBangla
                  ? '${bus.fare} টাকা'
                  : '${bus.fare} Tk';

              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ), // কার্ডের নিচে গ্যাপ
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                  leading: CircleAvatar(
                    backgroundColor: theme.primaryColor
                        .withOpacity(0.1),
                    child: Icon(
                      CupertinoIcons.bus,
                      color: theme.primaryColor,
                      size:
                          22, // ❗️ এই লাইনটি অসম্পূর্ণ ছিল
                    ),
                  ),

                  // --- ❗️❗️ নিচের অংশটুকু অসম্পূর্ণ ছিল ---
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    '$from ➜ $to\n$fare', // ভাড়াও সাবটাইটেলে
                    style: TextStyle(
                      color:
                          theme.textTheme.bodySmall?.color,
                      height: 1.4,
                      fontSize: 13,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isFav
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      color: isFav
                          ? Colors.red
                          : Colors.grey,
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.favoriteService
                            .toggleFavorite(bus.nameEn);
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BusDetailPage(
                          bus: bus,
                          isEnglish: !widget.isBangla,
                          favoriteService:
                              widget.favoriteService,
                        ),
                      ),
                    );
                  },
                  // --- ❗️❗️ এই পর্যন্ত ---
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
