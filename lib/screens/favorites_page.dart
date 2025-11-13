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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favoriteBuses = busList
          .where(
            (bus) => widget.favoriteService.isFavorite(
              bus.nameEn,
            ),
          )
          .toList();
    });
  }

  void _toggleFavorite(String busNameEn) {
    setState(() {
      widget.favoriteService.toggleFavorite(busNameEn);
      _loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_favoriteBuses.isEmpty) {
      // ... (অপরিবর্তিত) ...
    }

    return Padding(
      padding: EdgeInsets.only(
        top:
            kToolbarHeight +
            (MediaQuery.of(context).padding.top / 2),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16.0),
        itemCount: _favoriteBuses.length,
        itemBuilder: (context, index) {
          final bus = _favoriteBuses[index];
          final name = widget.isBangla
              ? bus.nameBn
              : bus.nameEn;
          final from = widget.isBangla
              ? bus.fromBn
              : bus.fromEn;
          final to = widget.isBangla ? bus.toBn : bus.toEn;
          final fare = widget.isBangla
              ? '${bus.fare} টাকা'
              : '${bus.fare} Tk';

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 4.0,
              ),
              leading: CircleAvatar(
                backgroundColor: theme.primaryColor
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
                ),
              ),
              subtitle: Text(
                '$from ➜ $to\n$fare',
                style: TextStyle(
                  color: theme.textTheme.bodySmall?.color,
                  height: 1.4,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  CupertinoIcons.heart_fill,
                  color: Colors.red,
                ),
                onPressed: () {
                  _toggleFavorite(bus.nameEn);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BusDetailPage(
                      bus: bus,
                      isEnglish: !widget.isBangla,
                      // ❗️ FavoriteService পাস করুন
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
    );
  }
}
