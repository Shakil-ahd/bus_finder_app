// lib/services/favorite_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  // ❗️ 'static' নয়, এগুলো এখন ইন্সট্যান্স ভেরিয়েবল
  late final SharedPreferences _prefs;
  List<String> _favorites = [];
  List<String> _searchHistory = [];
  static const String _historyKey =
      'searchHistory'; // এটি static থাকতে পারে

  // --- ❗️ সমাধান: কনস্ট্রাক্টরটি SharedPreferences গ্রহণ করবে ---
  FavoriteService(this._prefs);

  List<String> get favorites => _favorites;

  // --- ❗️ সমাধান: 'init' এখন শুধু ডেটা লোড করবে ---
  Future<void> init() async {
    // ❗️ SharedPreferences.getInstance() কল করার দরকার নেই, কারণ এটি কনস্ট্রাক্টরেই আছে
    _favorites =
        _prefs.getStringList('favoriteBuses') ?? [];
    _searchHistory =
        _prefs.getStringList(_historyKey) ?? [];
  }

  // --- ❗️ 'static' ছাড়া ফাংশন ---
  bool isFavorite(String busNameEn) {
    return _favorites.contains(busNameEn);
  }

  // --- ❗️ 'static' ছাড়া ফাংশন ---
  Future<void> toggleFavorite(String busNameEn) async {
    if (isFavorite(busNameEn)) {
      _favorites.remove(busNameEn);
    } else {
      _favorites.add(busNameEn);
    }
    await _prefs.setStringList('favoriteBuses', _favorites);
  }

  // --- ❗️ 'static' ছাড়া ফাংশন ---
  List<String> getSearchHistory() {
    return _searchHistory;
  }

  // --- ❗️ 'static' ছাড়া ফাংশন ---
  Future<void> addSearchToHistory(String query) async {
    _searchHistory.remove(query);
    _searchHistory.insert(0, query);

    if (_searchHistory.length > 5) {
      _searchHistory = _searchHistory.sublist(0, 5);
    }
    await _prefs.setStringList(_historyKey, _searchHistory);
  }
}
