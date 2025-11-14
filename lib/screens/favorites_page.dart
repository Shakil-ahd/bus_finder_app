// lib/screens/favorites_page.dart
import 'package:figma/screens/bus_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/bus_data.dart';
import '../models/bus_model.dart';
import '../services/favorite_service.dart';

class FavoritesPage extends StatefulWidget {
  final bool isBangla;
  final FavoriteService favoriteService;

  const FavoritesPage({
    super.key,
    required this.isBangla,
    required this.favoriteService,
  });

  @override
  State<FavoritesPage> createState() =>
      _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<BusModel> _favoriteBuses = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // ❗️ ভাষা পরিবর্তন হলে বা পেজে ফিরে আসলে লিস্ট রিফ্রেশ করার জন্য
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavorites();
  }

  void _loadFavorites() {
    // ❗️ সার্ভিস থেকে ফেভারিট বাসের নামগুলো নিন
    final favNames = widget.favoriteService.favorites;

    // ❗️ পুরো বাস লিস্ট থেকে শুধু ফেভারিট বাসগুলো ফিল্টার করুন
    setState(() {
      _favoriteBuses = busList
          .where((bus) => favNames.contains(bus.nameEn))
          .toList();
    });
  }

  void _toggleFavorite(String busNameEn) {
    setState(() {
      widget.favoriteService.toggleFavorite(busNameEn);
      _loadFavorites(); // লিস্ট রিলোড করুন
    });
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
        ),

        Expanded(
          child: _favoriteBuses.isEmpty
              ? Center(
                  child: Text(
                    widget.isBangla
                        ? 'আপনার কোন প্রিয় বাস নেই 😢'
                        : 'You have no favorite buses 😢',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(
                          color: Colors.white70,
                        ), // সাদা রঙ
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _favoriteBuses.length,
                  itemBuilder: (context, index) {
                    final bus = _favoriteBuses[index];
                    final name = widget.isBangla
                        ? bus.nameBn
                        : bus.nameEn;
                    final from = widget.isBangla
                        ? bus.fromBn
                        : bus.fromEn;
                    final to = widget.isBangla
                        ? bus.toBn
                        : bus.toEn;
                    final fare = widget.isBangla
                        ? '${bus.fare} টাকা'
                        : '${bus.fare} Tk';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          16.0,
                        ),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                        leading: CircleAvatar(
                          backgroundColor: theme
                              .primaryColor
                              .withOpacity(0.1),
                          child: Icon(
                            CupertinoIcons.bus,
                            color: theme.primaryColor,
                            size: 22,
                          ),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '$from ➜ $to\n$fare',
                          style: TextStyle(
                            color: theme
                                .textTheme
                                .bodySmall
                                ?.color,
                            height: 1.4,
                            fontSize: 13,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            // ❗️ ফেভারিট পেজে সবসময় ভরা হার্ট
                            CupertinoIcons.heart_fill,
                            color: Colors.red,
                            size: 24,
                          ),
                          onPressed: () {
                            _toggleFavorite(
                              bus.nameEn,
                            ); // ফেভারিট থেকে বাদ দিন
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
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
