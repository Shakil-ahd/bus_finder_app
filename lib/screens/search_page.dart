// lib/screens/search_page.dart
import 'package:figma/screens/bus_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../data/bus_data.dart';
import '../models/bus_model.dart';
import '../services/favorite_service.dart';

import '../widgets/bus_list_shimmer.dart';
// import '../widgets/custom_scaffold.dart'; // ❗️ main.dart থেকে হ্যান্ডেল হবে

class SearchPage extends StatefulWidget {
  final bool isBangla;
  final FavoriteService favoriteService;

  const SearchPage({
    super.key,
    required this.isBangla,
    required this.favoriteService,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedFrom;
  String? selectedTo;
  String searchQuery = '';

  List<String> _searchSuggestions = [];
  List<String> _allLocations = [];
  final TextEditingController _searchController =
      TextEditingController();

  bool _isSearching = false;
  List<BusModel> _filteredBuses = [];

  @override
  void initState() {
    super.initState();
    _buildLists();
  }

  @override
  void didUpdateWidget(SearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isBangla != widget.isBangla) {
      _buildLists();
      _clearBusSearch();
      _clearLocationSearch();
    }
  }

  void _buildLists() {
    final suggestions = <String>{};
    final locations = <String>{};

    for (final bus in busList) {
      suggestions.add(bus.nameEn);
      suggestions.add(bus.nameBn);

      if (widget.isBangla) {
        locations.add(bus.fromBn);
        locations.add(bus.toBn);
        for (var stop in bus.stoppagesBn) {
          // স্টপেজগুলোও যোগ করা হয়েছে
          locations.add(stop);
        }
      } else {
        locations.add(bus.fromEn);
        locations.add(bus.toEn);
        for (var stop in bus.stoppagesEn) {
          // স্টপেজগুলোও যোগ করা হয়েছে
          locations.add(stop);
        }
      }
    }
    _searchSuggestions = suggestions.toList()..sort();
    _allLocations =
        locations
            .toList()
            .where((loc) => loc.isNotEmpty)
            .toSet()
            .toList()
          ..sort(); // ডুপ্লিকেট বাদ দিয়ে সর্ট
  }

  void _clearBusSearch() {
    _searchController.clear();
    searchQuery = '';
  }

  void _clearLocationSearch() {
    setState(() {
      selectedFrom = null;
      selectedTo = null;
    });
  }

  Future<void> _searchBuses() async {
    // যদি বাসের নাম লিখে সার্চ করা হয়
    if (searchQuery.isNotEmpty) {
      _clearLocationSearch(); // লোকেশন ফিল্ড ক্লিয়ার করে দাও
      await widget.favoriteService.addSearchToHistory(
        searchQuery,
      );
    }
    // যদি 'From' বা 'To' দিয়ে সার্চ করা হয়
    else if (selectedFrom != null || selectedTo != null) {
      _clearBusSearch(); // বাসের নাম ফিল্ড ক্লিয়ার করে দাও
    } else if (searchQuery.isEmpty &&
        selectedFrom == null &&
        selectedTo == null) {
      setState(() {
        _filteredBuses = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });
    await Future.delayed(const Duration(milliseconds: 750));
    final results = _buildFilteredList();
    if (mounted) {
      setState(() {
        _filteredBuses = results;
        _isSearching = false;
      });
    }
  }

  List<BusModel> _buildFilteredList() {
    List<BusModel> filtered = busList;
    final query = searchQuery.toLowerCase();

    // 1. বাসের নাম দিয়ে ফিল্টার
    if (query.isNotEmpty) {
      filtered = filtered.where((bus) {
        final nameEn = bus.nameEn.toLowerCase();
        final nameBn = bus.nameBn.toLowerCase();
        return nameEn.contains(query) ||
            nameBn.contains(query);
      }).toList();
    }
    // 2. 'From' এবং 'To' দিয়ে ফিল্টার (যদি বাসের নাম দিয়ে ফিল্টার না করা হয়)
    else {
      if (selectedFrom != null) {
        filtered = filtered.where((bus) {
          final from = widget.isBangla
              ? bus.fromBn.toLowerCase()
              : bus.fromEn.toLowerCase();
          final hasFromStoppage = widget.isBangla
              ? bus.stoppagesBn
                    .map((e) => e.toLowerCase())
                    .contains(selectedFrom!.toLowerCase())
              : bus.stoppagesEn
                    .map((e) => e.toLowerCase())
                    .contains(selectedFrom!.toLowerCase());
          return from == selectedFrom!.toLowerCase() ||
              hasFromStoppage;
        }).toList();
      }
      if (selectedTo != null) {
        filtered = filtered.where((bus) {
          final to = widget.isBangla
              ? bus.toBn.toLowerCase()
              : bus.toEn.toLowerCase();
          final hasToStoppage = widget.isBangla
              ? bus.stoppagesBn
                    .map((e) => e.toLowerCase())
                    .contains(selectedTo!.toLowerCase())
              : bus.stoppagesEn
                    .map((e) => e.toLowerCase())
                    .contains(selectedTo!.toLowerCase());
          return to == selectedTo!.toLowerCase() ||
              hasToStoppage;
        }).toList();
      }
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      // স্ক্রল করার জন্য SingleChildScrollView
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ), // পুরো পেজে প্যাডিং
        child: Column(
          children: [
            SizedBox(
              height:
                  kToolbarHeight +
                  MediaQuery.of(context).padding.top +
                  20,
            ), // AppBar এর নিচে গ্যাপ
            // --- 'From' ড্রপডাউন ---
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: widget.isBangla
                    ? 'কোথা থেকে'
                    : 'From',
                prefixIcon: Icon(
                  CupertinoIcons.location_solid,
                  size: 20,
                  color: theme.primaryColor,
                ),
              ),
              value: selectedFrom,
              items: _allLocations
                  .map(
                    (loc) => DropdownMenuItem(
                      value: loc,
                      child: Text(loc),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedFrom = value;
                  selectedTo = null; // 'To' রিসেট করুন
                  _clearBusSearch(); // বাসের সার্চ রিসেট করুন
                });
              },
            ),
            const SizedBox(
              height: 16,
            ), // ফিল্ডের নিচে গ্যাপ
            // --- 'To' ড্রপডাউন ---
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: widget.isBangla
                    ? 'গন্তব্য'
                    : 'To',
                prefixIcon: Icon(
                  CupertinoIcons.location_solid,
                  size: 20,
                  color: theme.primaryColor,
                ),
              ),
              value: selectedTo,
              items: _allLocations
                  .map(
                    (loc) => DropdownMenuItem(
                      value: loc,
                      child: Text(loc),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedTo = value;
                  _clearBusSearch(); // বাসের সার্চ রিসেট করুন
                });
              },
            ),
            const SizedBox(
              height: 16,
            ), // ফিল্ডের নিচে গ্যাপ
            // --- Autocomplete সার্চ বার (বাসের নামের জন্য) ---
            Autocomplete<String>(
              optionsBuilder:
                  (TextEditingValue textEditingValue) {
                    final query = textEditingValue.text
                        .toLowerCase();
                    if (query.isEmpty) {
                      return widget.favoriteService
                          .getSearchHistory();
                    }
                    return _searchSuggestions.where((
                      String option,
                    ) {
                      return option.toLowerCase().contains(
                        query,
                      );
                    });
                  },
              fieldViewBuilder:
                  (
                    BuildContext context,
                    TextEditingController fieldController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) {
                          if (_searchController.text !=
                              fieldController.text) {
                            fieldController.text =
                                _searchController.text;
                          }
                        });

                    return TextFormField(
                      controller: fieldController,
                      focusNode: fieldFocusNode,
                      decoration: InputDecoration(
                        labelText: widget.isBangla
                            ? 'বাসের নাম খুঁজুন (ঐচ্ছিক)'
                            : 'Search Bus Name (Optional)',
                        prefixIcon: Icon(
                          fieldController.text.isEmpty
                              ? CupertinoIcons.time
                              : CupertinoIcons.bus,
                          size: 20,
                        ),
                        suffixIcon:
                            fieldController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  CupertinoIcons
                                      .clear_thick_circled,
                                  size: 20,
                                ),
                                onPressed: () {
                                  fieldController.clear();
                                  setState(() {
                                    searchQuery = '';
                                    _searchController
                                        .clear();
                                  });
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                          _searchController.text = value;
                          if (value.isNotEmpty) {
                            _clearLocationSearch(); // টাইপ করলে লোকেশন ক্লিয়ার
                          }
                        });
                      },
                      onFieldSubmitted: (value) {
                        _searchBuses();
                      },
                    );
                  },
              onSelected: (String selection) {
                setState(() {
                  searchQuery = selection;
                  _searchController.text = selection;
                  _clearLocationSearch(); // সিলেক্ট করলে লোকেশন ক্লিয়ার
                });
                _searchBuses();
                FocusScope.of(context).unfocus();
              },
            ),
            const SizedBox(
              height: 20,
            ), // বাটন এর উপরে গ্যাপ
            // --- সার্চ বাটন ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(CupertinoIcons.search),
                label: Text(
                  widget.isBangla
                      ? 'অনুসন্ধান করুন'
                      : 'Search',
                ),
                onPressed: _searchBuses,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ), // বাটন এর নিচে গ্যাপ
            // --- Shimmer বা লিস্ট ---
            _isSearching
                ? const BusListShimmer()
                : _filteredBuses.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      (selectedFrom == null &&
                              selectedTo == null &&
                              searchQuery.isEmpty)
                          ? (widget.isBangla
                                ? 'আপনার রুট সার্চ করুন'
                                : 'Search your route')
                          : (widget.isBangla
                                ? 'কোন বাস পাওয়া যায়নি 😢'
                                : 'No bus found 😢'),
                      style: theme.textTheme.titleMedium
                          ?.copyWith(
                            color: Colors.white70,
                          ), // সাদা রঙে টেক্সট
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // ScrollView এর সাথে কাজ করার জন্য
                    shrinkWrap:
                        true, // ScrollView এর সাথে কাজ করার জন্য
                    padding: const EdgeInsets.only(top: 0),
                    itemCount: _filteredBuses.length,
                    itemBuilder: (context, index) {
                      final bus = _filteredBuses[index];
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
                          horizontal: 0,
                          vertical: 8,
                        ), // কার্ডের নিচে গ্যাপ
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16.0),
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
                            icon: Icon(
                              isFav
                                  ? CupertinoIcons
                                        .heart_fill
                                  : CupertinoIcons.heart,
                              color: isFav
                                  ? Colors.red
                                  : Colors.grey,
                              size: 24,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.favoriteService
                                    .toggleFavorite(
                                      bus.nameEn,
                                    );
                              });
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BusDetailPage(
                                      bus: bus,
                                      isEnglish:
                                          !widget.isBangla,
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
          ],
        ),
      ),
    );
  }
}
