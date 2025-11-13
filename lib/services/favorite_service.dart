// lib/services/favorite_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static SharedPreferences? _prefs;
  static List<String> _favorites = [];

  // --- ❗️ নতুন কোড: সার্চ হিস্ট্রি ---
  static List<String> _searchHistory = [];
  static const String _historyKey = 'searchHistory';
  // ---

  List<String> get favorites => _favorites;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    _favorites =
        _prefs!.getStringList('favoriteBuses') ?? [];

    // --- ❗️ নতুন কোড: হিস্ট্রি লোড করা ---
    _searchHistory =
        _prefs!.getStringList(_historyKey) ?? [];
    // ---
  }

  // --- ফেভারিট লজিক (অপরিবর্তিত) ---
  bool isFavorite(String busNameEn) {
    return _favorites.contains(busNameEn);
  }

  Future<void> toggleFavorite(String busNameEn) async {
    if (isFavorite(busNameEn)) {
      _favorites.remove(busNameEn);
    } else {
      _favorites.add(busNameEn);
    }
    await _prefs!.setStringList(
      'favoriteBuses',
      _favorites,
    );
  }

  // --- ❗️ নতুন ফাংশন: সার্চ হিস্ট্রি ---

  // সার্চ হিস্ট্রি লিস্ট রিটার্ন করে
  List<String> getSearchHistory() {
    return _searchHistory;
  }

  // সার্চ হিস্ট্রি সেভ করে
  Future<void> addSearchToHistory(String query) async {
    // যদি এই সার্চটি আগে থেকেই থাকে, তবে এটিকে লিস্ট থেকে মুছে ফেলুন
    _searchHistory.remove(query);
    // নতুন সার্চটি লিস্টের প্রথমে যোগ করুন
    _searchHistory.insert(0, query);

    // আমরা শুধু শেষ ৫টি সার্চ হিস্ট্রি রাখবো
    if (_searchHistory.length > 5) {
      _searchHistory = _searchHistory.sublist(0, 5);
    }

    // SharedPreferences-এ সেভ করুন
    await _prefs!.setStringList(
      _historyKey,
      _searchHistory,
    );
  }
}
