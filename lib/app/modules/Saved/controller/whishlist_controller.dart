import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/whishlistmodel.dart';


class WishlistController extends GetxController {
  static const String _baseUrl =
      'https://rasma.astradevelops.in/vetniaryapp/public/api';

  // ── Observables ──────────────────────────────────────────────────────────────
  final RxList<WishlistCollege> wishlist   = <WishlistCollege>[].obs;
  final RxSet<int> wishlistedIds           = <int>{}.obs; // O(1) lookup
  final RxSet<int> loadingIds              = <int>{}.obs; // per-card spinner
  final RxBool isFetching                  = false.obs;   // full-page loader

  // ── Helpers ──────────────────────────────────────────────────────────────────
  bool isWishlisted(int collegeId) => wishlistedIds.contains(collegeId);
  bool isLoading(int collegeId)    => loadingIds.contains(collegeId);

  // ── Fetch ─────────────────────────────────────────────────────────────────────
  Future<void> fetchWishlist(int studentId) async {
    isFetching.value = true;
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/get-wishlist'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'student_id': studentId}),
      );
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body['status'] == '1' && body['data'] is List) {
        final items = (body['data'] as List)
            .map((e) => WishlistCollege.fromJson(e as Map<String, dynamic>))
            .toList();
        wishlist.assignAll(items);
        wishlistedIds.assignAll(items.map((e) => e.collegeId).toSet());
      }
    } catch (e) {
      debugPrint('fetchWishlist error: $e');
    } finally {
      isFetching.value = false;
    }
  }

  // ── Add ───────────────────────────────────────────────────────────────────────
  Future<bool> addToWishlist(int studentId, int collegeId) async {
    if (loadingIds.contains(collegeId)) return false;
    loadingIds.add(collegeId);
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/add-wishlist'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'student_id': studentId, 'college_id': collegeId}),
      );
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body['status'] == '1') {
        wishlistedIds.add(collegeId);
        await fetchWishlist(studentId);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('addToWishlist error: $e');
      return false;
    } finally {
      loadingIds.remove(collegeId);
    }
  }

  // ── Remove ────────────────────────────────────────────────────────────────────
  Future<bool> removeFromWishlist(int studentId, int collegeId) async {
    if (loadingIds.contains(collegeId)) return false;
    loadingIds.add(collegeId);
    try {
      final res = await http.put(
        Uri.parse('$_baseUrl/remove-wishlist'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'student_id': studentId, 'college_id': collegeId}),
      );
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body['status'] == '1') {
        wishlistedIds.remove(collegeId);
        wishlist.removeWhere((e) => e.collegeId == collegeId);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('removeFromWishlist error: $e');
      return false;
    } finally {
      loadingIds.remove(collegeId);
    }
  }

  // ── Toggle ────────────────────────────────────────────────────────────────────
  Future<void> toggleWishlist(int studentId, int collegeId) async {
    if (isWishlisted(collegeId)) {
      await removeFromWishlist(studentId, collegeId);
    } else {
      await addToWishlist(studentId, collegeId);
    }
  }
}
