// import 'dart:async';
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../core/network/api_constants.dart';
//
// class FiliteredCollegescontroller extends GetxController {
//   // ── State ──────────────────────────────────────────────────────────────────
//   final RxList<dynamic> colleges = <dynamic>[].obs;
//   final RxList<dynamic> displayedColleges = <dynamic>[].obs;
//   final RxList<String> states = <String>[].obs;
//   final RxString selectedState = 'All States'.obs;
//   final RxBool isLoading = false.obs;
//   final RxBool isSearching = false.obs;
//   final RxString error = ''.obs;
//   final RxString searchQuery = ''.obs;
//
//   Timer? _debounce;
//
//   // static const _base = 'https://rasma.astradevelops.in/vetniaryapp/public/api';
//
//   Future<void> init(String type) async {
//     await Future.wait([
//       fetchColleges(type),
//       fetchStates(),
//     ]);
//   }
//
//   // ── Fetch colleges (temporary / permanent) ─────────────────────────────────
//   Future<void> fetchColleges(String type) async {
//     isLoading.value = true;
//     error.value = '';
//     // try {
//       // final endpoint = type == 'temporary'
//       //     ? '$_base/temporary-colleges'
//       //     : '$_base/permanent-colleges';
//       try {
//         final endpoint = type == 'temporary'
//             ? '${ApiConstants.baseUrl}/temporary-colleges'
//             : '${ApiConstants.baseUrl}/permanent-colleges';
//
//         final res = await http.get(Uri.parse(endpoint));
//       if (res.statusCode == 200) {
//         final json = jsonDecode(res.body);
//         colleges.value = json['data'] ?? [];
//         displayedColleges.value = List.from(colleges);
//       } else {
//         error.value = 'Server error: ${res.statusCode}';
//       }
//     } catch (e) {
//       error.value = 'Failed to load. Check your connection.';
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ── Fetch states ───────────────────────────────────────────────────────────
//   Future<void> fetchStates() async {
//     try {
//       final res = await http.get
//         (Uri.parse('${ApiConstants.baseUrl}/get-college-states'),);
//       if (res.statusCode == 200) {
//         final json = jsonDecode(res.body);
//         final list = List<String>.from(json['data'] ?? []);
//         states.value = ['All States', ...list];
//       }
//     } catch (_) {}
//   }
//
//   // ── Search (POST, debounced) ───────────────────────────────────────────────
//   void onSearchChanged(String query) {
//     searchQuery.value = query;
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (query.trim().isEmpty) {
//         // Reset to full list (respecting any active state filter)
//         if (selectedState.value == 'All States') {
//           displayedColleges.value = List.from(colleges);
//         } else {
//           fetchByState(selectedState.value);
//         }
//       } else {
//         searchColleges(query.trim());
//       }
//     });
//   }
//
//   Future<void> searchColleges(String name) async {
//     isSearching.value = true;
//     try {
//       final res = await http.post(
//         Uri.parse('$_base/search-colleges'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'college_name': name}),
//       );
//       if (res.statusCode == 200) {
//         final json = jsonDecode(res.body);
//         displayedColleges.value = json['data'] ?? [];
//       }
//     } catch (_) {} finally {
//       isSearching.value = false;
//     }
//   }
//
//   // ── Filter by state (POST) ─────────────────────────────────────────────────
//   Future<void> fetchByState(String state) async {
//     if (state == 'All States') {
//       selectedState.value = 'All States';
//       displayedColleges.value = List.from(colleges);
//       return;
//     }
//     selectedState.value = state;
//     isLoading.value = true;
//     try {
//       final res = await http.post(
//         Uri.parse('$_base/colleges-by-state'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'state': state}),
//       );
//       if (res.statusCode == 200) {
//         final json = jsonDecode(res.body);
//         displayedColleges.value = json['data'] ?? [];
//       }
//     } catch (_) {} finally {
//       isLoading.value = false;
//     }
//   }
//
//   void clearStateFilter(String type) {
//     selectedState.value = 'All States';
//     displayedColleges.value = List.from(colleges);
//     // If there's an active search, re-run it
//     if (searchQuery.value.trim().isNotEmpty) {
//       searchColleges(searchQuery.value.trim());
//     }
//   }
//
//   @override
//   void onClose() {
//     _debounce?.cancel();
//     super.onClose();
//   }
// }
//
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/network/api_constants.dart';

class FiliteredCollegescontroller extends GetxController {
  // ── State ──────────────────────────────────────────────────────────────────
  final RxList<dynamic> colleges = <dynamic>[].obs;
  final RxList<dynamic> displayedColleges = <dynamic>[].obs;
  final RxList<String> states = <String>[].obs;
  final RxString selectedState = 'All States'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;

  Timer? _debounce;

  Future<void> init(String type) async {
    await Future.wait([
      fetchColleges(type),
      fetchStates(),
    ]);
  }

  // ── Fetch colleges (temporary / permanent) ─────────────────────────────────
  Future<void> fetchColleges(String type) async {
    isLoading.value = true;
    error.value = '';

    try {
      final endpoint = type == 'temporary'
          ? '${ApiConstants.baseUrl}/temporary-colleges'
          : '${ApiConstants.baseUrl}/permanent-colleges';

      final res = await http.get(Uri.parse(endpoint));

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        colleges.value = json['data'] ?? [];
        displayedColleges.value = List.from(colleges);
      } else {
        error.value = 'Server error: ${res.statusCode}';
      }
    } catch (e) {
      error.value = 'Failed to load. Check your connection.';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Fetch states ───────────────────────────────────────────────────────────
  Future<void> fetchStates() async {
    try {
      final res = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/get-college-states'),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        final list = List<String>.from(json['data'] ?? []);
        states.value = ['All States', ...list];
      }
    } catch (_) {}
  }

  // ── Search (POST, debounced) ───────────────────────────────────────────────
  void onSearchChanged(String query) {
    searchQuery.value = query;

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        if (selectedState.value == 'All States') {
          displayedColleges.value = List.from(colleges);
        } else {
          fetchByState(selectedState.value);
        }
      } else {
        searchColleges(query.trim());
      }
    });
  }

  Future<void> searchColleges(String name) async {
    isSearching.value = true;

    try {
      final res = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/search-colleges'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'college_name': name,
        }),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        displayedColleges.value = json['data'] ?? [];
      }
    } catch (_) {
      //
    } finally {
      isSearching.value = false;
    }
  }

  // ── Filter by state (POST) ─────────────────────────────────────────────────
  Future<void> fetchByState(String state) async {
    if (state == 'All States') {
      selectedState.value = 'All States';
      displayedColleges.value = List.from(colleges);
      return;
    }

    selectedState.value = state;
    isLoading.value = true;

    try {
      final res = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/colleges-by-state'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'state': state,
        }),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        displayedColleges.value = json['data'] ?? [];
      }
    } catch (_) {
      //
    } finally {
      isLoading.value = false;
    }
  }

  void clearStateFilter(String type) {
    selectedState.value = 'All States';
    displayedColleges.value = List.from(colleges);

    if (searchQuery.value.trim().isNotEmpty) {
      searchColleges(searchQuery.value.trim());
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}