// lib/screens/search_page.dart
import 'package:figma/screens/bus_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../data/bus_data.dart';
import '../models/bus_model.dart';
import '../services/favorite_service.dart';

import '../widgets/bus_list_shimmer.dart';

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
      _searchController.clear();
      searchQuery = '';
      _filteredBuses.clear();
    }
  }

  void _buildLists() {
    final suggestions = <String>{};
    final locations = <String>{};
    for (final bus in busList) {
      if (widget.isBangla) {
        suggestions.add(bus.nameBn);
        suggestions.add(bus.fromBn);
        suggestions.add(bus.toBn);
        locations.add(bus.fromBn);
        locations.add(bus.toBn);
      } else {
        suggestions.add(bus.nameEn);
        suggestions.add(bus.fromEn);
        suggestions.add(bus.toEn);
        locations.add(bus.fromEn);
        locations.add(bus.toEn);
      }
    }
    _searchSuggestions = suggestions.toList()..sort();
    _allLocations = locations.toList()..sort();
  }

  // --- ❗️ সার্চ বাটন চাপলে এই ফাংশন কল হবে ---
  Future<void> _searchBuses() async {
    // সার্চ কোয়েরি হিস্ট্রিতে সেভ করুন
    if (searchQuery.isNotEmpty) {
      await widget.favoriteService.addSearchToHistory(
        searchQuery,
      );
    }

    if (searchQuery.isEmpty &&
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
    // ... (এই ফাংশনটি অপরিবর্তিত) ...
    List<BusModel> filtered = busList;
    final query = searchQuery.toLowerCase();

    if (selectedFrom != null) {
      filtered = filtered.where((bus) {
        final from = widget.isBangla
            ? bus.fromBn.toLowerCase()
            : bus.fromEn.toLowerCase();
        return from == selectedFrom!.toLowerCase();
      }).toList();
    }
    if (selectedTo != null) {
      filtered = filtered.where((bus) {
        final to = widget.isBangla
            ? bus.toBn.toLowerCase()
            : bus.toEn.toLowerCase();
        return to == selectedTo!.toLowerCase();
      }).toList();
    }
    if (query.isNotEmpty) {
      filtered = filtered.where((bus) {
        final name = widget.isBangla
            ? bus.nameBn.toLowerCase()
            : bus.nameEn.toLowerCase();
        final from = widget.isBangla
            ? bus.fromBn.toLowerCase()
            : bus.fromEn.toLowerCase();
        final to = widget.isBangla
            ? bus.toBn.toLowerCase()
            : bus.toEn.toLowerCase();
        return name.contains(query) ||
            from.contains(query) ||
            to.contains(query);
      }).toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          height:
              kToolbarHeight +
              (MediaQuery.of(context).padding.top / 2),
        ),

        // --- ড্রপডাউন ১ ('From') ---
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: widget.isBangla
                  ? 'কোথা থেকে'
                  : 'From',
              prefixIcon: Icon(
                CupertinoIcons.location_solid,
                size: 20,
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
                if (value != null && selectedTo != null) {
                  // ❗️ যদি 'To' সিলেক্ট করা থাকে, তবেই অটো-সার্চ করুন
                  _searchBuses();
                }
              });
            },
          ),
        ),

        // --- ড্রপডাউন ২ ('To') ---
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: widget.isBangla ? 'গন্তব্য' : 'To',
              prefixIcon: Icon(
                CupertinoIcons.location_solid,
                size: 20,
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
                if (value != null && selectedFrom != null) {
                  // ❗️ যদি 'From' সিলেক্ট করা থাকে, তবেই অটো-সার্চ করুন
                  _searchBuses();
                }
              });
            },
          ),
        ),

        // --- Autocomplete সার্চ বার (হিস্ট্রি লজিকসহ) ---
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Autocomplete<String>(
            optionsBuilder:
                (TextEditingValue textEditingValue) {
                  final query = textEditingValue.text
                      .toLowerCase();

                  // ❗️ যখন সার্চ বার খালি, তখন হিস্ট্রি দেখান
                  if (query.isEmpty) {
                    return widget.favoriteService
                        .getSearchHistory();
                  }
                  // ❗️ যখন টাইপ করা হচ্ছে, তখন সাজেশন দেখান
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
                          ? 'বাসের নাম খুঁজুন'
                          : 'Search Bus Name',
                      prefixIcon: Icon(
                        // ❗️ যখন খালি, তখন হিস্ট্রি আইকন দেখান
                        fieldController.text.isEmpty
                            ? CupertinoIcons.time
                            : CupertinoIcons.search,
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
                                  _searchController.clear();
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        _searchController.text = value;
                      });
                    },
                    // ❗️ Enter চাপলে সার্চ হবে
                    onFieldSubmitted: (value) {
                      _searchBuses();
                    },
                  );
                },
            onSelected: (String selection) {
              setState(() {
                searchQuery = selection;
                _searchController.text = selection;
              });
              _searchBuses(); // ❗️ সাজেশন সিলেক্ট করলে সার্চ হবে
              FocusScope.of(context).unfocus();
            },
          ),
        ),

        // --- ❗️ নতুন সার্চ বাটন ---
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(CupertinoIcons.search),
              label: Text(
                widget.isBangla
                    ? 'অনুসন্ধান করুন'
                    : 'Search',
              ),
              onPressed:
                  _searchBuses, // ❗️ বাটন চাপলে সার্চ হবে
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
        ),

        // --- Shimmer বা লিস্ট ---
        Expanded(
          child: _isSearching
              ? const BusListShimmer()
              : _filteredBuses.isEmpty
              ? Center(
                  // ... (মেসেজ অপরিবর্তিত) ...
                )
              : ListView.builder(
                  // ... (লিস্টের ডিজাইন অপরিবর্তিত) ...
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
                        horizontal: 16,
                        vertical: 6,
                      ),
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 4.0,
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
        ),
      ],
    );
  }
}
