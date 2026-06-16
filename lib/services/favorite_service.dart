
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  late final SharedPreferences _prefs;
  List<String> _favorites = [];
  List<String> _searchHistory = [];
  static const String _historyKey =
      'searchHistory'; /

  FavoriteService(this._prefs);

  List<String> get favorites => _favorites;

  Future<void> init() async {
    _favorites =
        _prefs.getStringList('favoriteBuses') ?? [];
    _searchHistory =
        _prefs.getStringList(_historyKey) ?? [];
  }


  bool isFavorite(String busNameEn) {
    return _favorites.contains(busNameEn);
  }

  Future<void> toggleFavorite(String busNameEn) async {
    if (isFavorite(busNameEn)) {
      _favorites.remove(busNameEn);
    } else {
      _favorites.add(busNameEn);
    }
    await _prefs.setStringList('favoriteBuses', _favorites);
  }

  List<String> getSearchHistory() {
    return _searchHistory;
  }

  Future<void> addSearchToHistory(String query) async {
    _searchHistory.remove(query);
    _searchHistory.insert(0, query);

    if (_searchHistory.length > 5) {
      _searchHistory = _searchHistory.sublist(0, 5);
    }
    await _prefs.setStringList(_historyKey, _searchHistory);
  }
}
