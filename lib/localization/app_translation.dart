import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'app_title': 'Dhaka Bus Finder',
          'loading': 'Loading...',
          'error': 'Error',
          'success': 'Success',
          'database_setup': 'Database Setup',
          'seeding_data':
              'Database is empty. Adding {count} bus routes...',
          'seeding_success': 'Database setup successful.',
          'seeding_error':
              'Could not upload data to Supabase.',
          'load_error':
              'Could not load data from Supabase.',
          'no_bus_found': 'No bus found.',
          'search_hint':
              'Search by bus, route, or stoppage...',
          'stoppages_bangla': 'Major Stoppages (Bangla)',
          'stoppages_english': 'Major Stoppages (English)',
          'no_bus_selected': 'No bus selected.',
          'fare_calculator': 'Fare Calculator',
          'calculate_fare_button': 'Calculate Fare',
          'select_starting_stop': 'Select Starting Stop',
          'select_destination_stop':
              'Select Destination Stop',
          'calculated_fare': 'Calculated Fare',
          'estimated_fare': 'Estimated Fare: ৳{fare}',
          'min_fare_warning': 'Minimum fare is ৳{fare}.',
          'select_different_stops':
              'Please select two different stops.',
          'tab_home': 'Home',
          'tab_search': 'Find Route',
          'tab_favorites': 'Favorites',
          'tab_settings': 'Settings',
          'favorites_title': 'Favorite Buses',
          'no_favorites':
              'You have not favorited any bus yet.',
          'settings_title': 'Settings',
          'language': 'Language',
          'theme': 'Theme',
          'light_mode': 'Light Mode',
          'dark_mode': 'Dark Mode',
          'bangla': 'বাংলা',
          'english': 'English',
          'search_route_title': 'Find Route',
          'from_location': 'From',
          'to_location': 'To',
          'find_route_button': 'Find Route',
          'search_result': 'Search Result',
          'no_route_found':
              'No direct or single-transfer route found.',
          'direct_route': 'Direct Route Found',
          'transfer_route': 'Transfer Route Found',
          'take_bus': 'Take Bus:',
          'get_down_at': 'Get down at:',
          'then_take_bus': 'Then take Bus:',
          'from': 'From',
          'to': 'To',
        },
        'bn_BD': {
          'app_title': 'ঢাকা বাস ফাইন্ডার',
          'loading': 'লোড হচ্ছে...',
          'error': 'ত্রুটি',
          'success': 'সফল',
          'database_setup': 'ডেটাবেস সেটআপ',
          'seeding_data':
              'ডেটাবেস খালি। {count} টি বাস রুট যোগ করা হচ্ছে...',
          'seeding_success':
              'ডেটাবেস সফলভাবে সেটআপ করা হয়েছে।',
          'seeding_error':
              'Supabase-এ ডেটা আপলোড করা যায়নি।',
          'load_error': 'Supabase থেকে ডেটা লোড করা যায়নি।',
          'no_bus_found': 'কোনো বাস খুঁজে পাওয়া যায়নি।',
          'search_hint': 'বাস, রুট বা স্টপেজ খুঁজুন...',
          'stoppages_bangla': 'প্রধান স্টপেজসমূহ (বাংলা)',
          'stoppages_english': 'প্রধান স্টপেজসমূহ (ইংরেজি)',
          'no_bus_selected': 'কোনো বাস সিলেক্ট করা হয়নি।',
          'fare_calculator': 'ভাড়া ক্যালকুলেটর',
          'calculate_fare_button': 'ভাড়া দেখুন',
          'select_starting_stop':
              'শুরুর স্টপেজ সিলেক্ট করুন',
          'select_destination_stop':
              'গন্তব্যের স্টপেজ সিলেক্ট করুন',
          'calculated_fare': 'গণনাকৃত ভাড়া',
          'estimated_fare': 'আনুমানিক ভাড়া: ৳{fare}',
          'min_fare_warning': 'সর্বনিম্ন ভাড়া ৳{fare}।',
          'select_different_stops':
              'অনুগ্রহ করে দুটি ভিন্ন স্টপেজ সিলেক্ট করুন।',
          'tab_home': 'হোম',
          'tab_search': 'রুট খুঁজুন',
          'tab_favorites': 'পছন্দ',
          'tab_settings': 'সেটিংস',
          'favorites_title': 'পছন্দের বাস',
          'no_favorites': 'আপনি কোনো বাস পছন্দ করেননি।',
          'settings_title': 'সেটিংস',
          'language': 'ভাষা',
          'theme': 'থিম',
          'light_mode': 'লাইট মোড',
          'dark_mode': 'ডার্ক মোড',
          'bangla': 'বাংলা',
          'english': 'English',
          'search_route_title': 'রুট খুঁজুন',
          'from_location': 'কোথা থেকে',
          'to_location': 'কোথায় যাবেন',
          'find_route_button': 'রুট খুঁজুন',
          'search_result': 'সার্চ রেজাল্ট',
          'no_route_found':
              'সরাসরি বা এক-বদলি রুট পাওয়া যায়নি।',
          'direct_route': 'সরাসরি রুট পাওয়া গেছে',
          'transfer_route': 'বাস বদলের রুট পাওয়া গেছে',
          'take_bus': 'বাস নিন:',
          'get_down_at': 'নেমে পড়ুন:',
          'then_take_bus': 'তারপর বাস নিন:',
          'from': 'থেকে',
          'to': 'পর্যন্ত',
        }
      };
}
