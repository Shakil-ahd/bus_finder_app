// lib/screens/bus_detail_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/bus_model.dart';
import '../services/favorite_service.dart';

class BusDetailPage extends StatefulWidget {
  final BusModel bus;
  final bool isEnglish;
  final FavoriteService favoriteService;

  const BusDetailPage({
    super.key,
    required this.bus,
    required this.isEnglish,
    required this.favoriteService,
  });

  @override
  State<BusDetailPage> createState() =>
      _BusDetailPageState();
}

class _BusDetailPageState extends State<BusDetailPage> {
  late bool isFav;

  @override
  void initState() {
    super.initState();
    isFav = widget.favoriteService.isFavorite(
      widget.bus.nameEn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> stoppages = widget.isEnglish
        ? widget.bus.stoppagesEn
        : widget.bus.stoppagesBn;

    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isFav
                  ? CupertinoIcons.heart_fill
                  : CupertinoIcons.heart,
              color: isFav ? Colors.red : Colors.white,
            ),
            onPressed: () {
              widget.favoriteService.toggleFavorite(
                widget.bus.nameEn,
              );
              setState(() {
                isFav = !isFav;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top:
                  kToolbarHeight +
                  MediaQuery.of(context).padding.top,
              bottom: 24,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple,
                  Colors.deepPurpleAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEnglish
                      ? widget.bus.nameEn
                      : widget.bus.nameBn,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  context,
                  CupertinoIcons.location_solid,
                  widget.isEnglish ? 'From' : 'কোথা থেকে',
                  widget.isEnglish
                      ? widget.bus.fromEn
                      : widget.bus.fromBn,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  context,
                  CupertinoIcons.location_solid,
                  widget.isEnglish ? 'To' : 'গন্তব্য',
                  widget.isEnglish
                      ? widget.bus.toEn
                      : widget.bus.toBn,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  context,
                  CupertinoIcons.money_dollar,
                  widget.isEnglish ? 'Fare' : 'ভাড়া',
                  widget.isEnglish
                      ? '${widget.bus.fare} Tk'
                      : '${widget.bus.fare} টাকা',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Stoppages Title
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              widget.isEnglish ? 'Stoppages' : 'স্টপেজ',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(
            indent: 16,
            endIndent: 16,
            height: 1,
          ),
          // Stoppages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: stoppages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons
                            .smallcircle_fill_circle,
                        size: 12,
                        color: theme.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        stoppages[index],
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
