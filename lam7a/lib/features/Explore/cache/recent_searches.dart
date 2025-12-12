// import 'package:hive/hive.dart';
// import 'package:lam7a/core/hive_types.dart';

// class RecentSearchesService {
//   static const String _key = 'items';

//   Future<Box> _box() async {
//     return HiveTypes().openBoxIfNeeded(HiveTypes.recentSearchesBox);
//   }

//   Future<List<String>> getSearches() async {
//     final box = await _box();
//     return List<String>.from(box.get(_key, defaultValue: []));
//   }

//   Future<void> addSearch(String query) async {
//     final box = await _box();
//     final list = List<String>.from(box.get(_key, defaultValue: []));

//     if (list.contains(query)) list.remove(query);
//     list.insert(0, query);

//     await box.put(_key, list.take(20).toList()); // keep 20 max
//   }

//   Future<void> clear() async {
//     final box = await _box();
//     await box.delete(_key);
//   }
// }

// class RecentProfilesService {
//   static const String _key = 'profiles';

//   Future<Box> _box() async {
//     return HiveTypes().openBoxIfNeeded(HiveTypes.recentProfilesBox);
//   }

//   Future<List<String>> getProfiles() async {
//     final box = await _box();
//     return List<String>.from(box.get(_key, defaultValue: []));
//   }

//   Future<void> addProfile(String userId) async {
//     final box = await _box();
//     final list = List<String>.from(box.get(_key, defaultValue: []));

//     if (list.contains(userId)) list.remove(userId);
//     list.insert(0, userId);

//     await box.put(_key, list.take(20).toList());
//   }

//   Future<void> clear() async {
//     final box = await _box();
//     await box.delete(_key);
//   }
// }
