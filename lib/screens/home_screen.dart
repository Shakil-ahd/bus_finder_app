import 'package:figma/screens/bus_details_screen.dart';
import 'package:flutter/material.dart';
import '../data/bus_data.dart';
import '../models/bus_model.dart';

import '../services/favorite_service.dart';

class HomePage extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  final FavoriteService favoriteService;

  const HomePage({
    super.key,
    required this.themeNotifier,
    required this.favoriteService,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';
  String? selectedFrom;
  String? selectedTo;
  bool isEnglish = true;

  // Bus name search only
  List<BusModel> getSearchBuses() {
    if (searchQuery.isEmpty) return [];
    return busList.where((bus) {
      final name = isEnglish
          ? bus.nameEn.toLowerCase()
          : bus.nameBn.toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();
  }

  // Location filter
  List<BusModel> getFilteredBuses() {
    List<BusModel> filtered = busList;

    if (selectedFrom != null) {
      filtered = filtered.where((bus) {
        final from = isEnglish ? bus.fromEn : bus.fromBn;
        return from == selectedFrom;
      }).toList();
    }

    if (selectedTo != null) {
      filtered = filtered.where((bus) {
        final to = isEnglish ? bus.toEn : bus.toBn;
        return to == selectedTo;
      }).toList();
    }

    return filtered;
  }

  List<String> getFromLocations() {
    final locs = busList
        .map((b) => isEnglish ? b.fromEn : b.fromBn)
        .toSet()
        .toList();
    locs.sort();
    return locs;
  }

  List<String> getToLocations() {
    if (selectedFrom == null) return [];
    final locs = busList
        .where(
          (b) =>
              (isEnglish ? b.fromEn : b.fromBn) ==
              selectedFrom,
        )
        .map((b) => isEnglish ? b.toEn : b.toBn)
        .toSet()
        .toList();
    locs.sort();
    return locs;
  }

  @override
  Widget build(BuildContext context) {
    final searchBuses = getSearchBuses();
    final filteredBuses = (searchQuery.isEmpty)
        ? getFilteredBuses()
        : searchBuses;
    final fromLocations = getFromLocations();
    final toLocations = getToLocations();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEnglish ? 'Bus App' : 'বাস অ্যাপ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              widget.themeNotifier.value =
                  widget.themeNotifier.value ==
                      ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              setState(() {
                isEnglish = !isEnglish;
                selectedFrom = null;
                selectedTo = null;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bus Name Only
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: isEnglish
                    ? 'Search Bus'
                    : 'বাস খুঁজুন',
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                  // Ignore location filters when searching
                  selectedFrom = null;
                  selectedTo = null;
                });
              },
            ),
          ),
          // From dropdown
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: isEnglish ? 'From' : 'কোথা থেকে',
                border: const OutlineInputBorder(),
              ),
              value: selectedFrom,
              items: fromLocations
                  .map(
                    (loc) => DropdownMenuItem(
                      value: loc,
                      child: Text(loc),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedFrom = val;
                  selectedTo = null;
                  searchQuery =
                      ''; // Clear search when selecting location
                });
              },
            ),
          ),
          // To dropdown
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: isEnglish ? 'To' : 'গন্তব্য',
                border: const OutlineInputBorder(),
              ),
              value: selectedTo,
              items: toLocations
                  .map(
                    (loc) => DropdownMenuItem(
                      value: loc,
                      child: Text(loc),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedTo = val;
                  searchQuery =
                      ''; // Clear search when selecting location
                });
              },
            ),
          ),
          // Bus list
          Expanded(
            child: filteredBuses.isEmpty
                ? Center(
                    child: Text(
                      isEnglish
                          ? 'No bus found 😢'
                          : 'কোন বাস পাওয়া যায়নি 😢',
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredBuses.length,
                    itemBuilder: (context, index) {
                      final bus = filteredBuses[index];
                      final name = isEnglish
                          ? bus.nameEn
                          : bus.nameBn;
                      final from = isEnglish
                          ? bus.fromEn
                          : bus.fromBn;
                      final to = isEnglish
                          ? bus.toEn
                          : bus.toBn;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text('$from ➜ $to'),
                          trailing: Text(
                            '${bus.fare}৳',
                            style: const TextStyle(
                              color: Colors.green,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BusDetailPage(
                                      bus: bus,
                                      isEnglish: isEnglish,
                                      favoriteService: widget
                                          .favoriteService,
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
      ),
    );
  }
}
