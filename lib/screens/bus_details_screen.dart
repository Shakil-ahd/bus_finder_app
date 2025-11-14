// lib/screens/bus_detail_page.dart
import 'package:figma/services/custom_scaffold.dart';
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
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() {
    setState(() {
      isFavorite = widget.favoriteService.isFavorite(
        widget.bus.nameEn,
      );
    });
  }

  void _toggleFavorite() {
    setState(() {
      widget.favoriteService.toggleFavorite(
        widget.bus.nameEn,
      );
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBangla = !widget.isEnglish;

    final name = isBangla
        ? widget.bus.nameBn
        : widget.bus.nameEn;
    final from = isBangla
        ? widget.bus.fromBn
        : widget.bus.fromEn;
    final to = isBangla ? widget.bus.toBn : widget.bus.toEn;
    final fare = isBangla
        ? '${widget.bus.fare} টাকা'
        : '${widget.bus.fare} Tk';
    final stoppages = isBangla
        ? widget.bus.stoppagesBn
        : widget.bus.stoppagesEn;

    return CustomScaffold(
      // ❗️ CustomScaffold ব্যবহার
      isBangla: isBangla,
      onLanguageChanged: (value) {
        // ভাষা পরিবর্তন করলে ফিরে আসার জন্য
        Navigator.pop(
          context,
        ); // বর্তমান পেজ থেকে বের হয়ে যাবে
        // যদি মেইন পেজের ভাষা পরিবর্তন করতে চান, তাহলে main.dart এ লজিক রাখুন
      },
      title: name, // বাসের নাম টাইটেলে দেখাবে
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          20.0,
        ), // পুরো পেজে প্যাডিং
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height:
                  kToolbarHeight +
                  MediaQuery.of(context).padding.top +
                  10,
            ), // AppBar এর নিচে গ্যাপ

            Center(
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        CupertinoIcons.bag_fill,
                        color: theme.primaryColor,
                        size: 60,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        name,
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$from ➜ $to',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.grey[700],
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isBangla
                            ? 'ভাড়া: $fare'
                            : 'Fare: $fare',
                        style: theme.textTheme.titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme
                                  .colorScheme
                                  .secondary,
                            ),
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(
                            isFavorite
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            color: isFavorite
                                ? Colors.redAccent
                                : Colors.grey[400],
                            size: 30,
                          ),
                          onPressed: _toggleFavorite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ), // সেকশনের মধ্যে গ্যাপ

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBangla
                          ? 'স্টপেজ সমূহ:'
                          : 'Stoppages:',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                    ),
                    const SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: stoppages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Icon(
                                CupertinoIcons
                                    .burst_fill, // ট্রাভেল আইকন
                                color: theme
                                    .colorScheme
                                    .secondary,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  stoppages[index],
                                  style: theme
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontSize: 16,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
