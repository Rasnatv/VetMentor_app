// features/Compare/controller/compare_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/comparemodel.dart';

class CompareController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<CompareCollegeModel> colleges = <CompareCollegeModel>[].obs;

  static const String _endpoint =
      'http://vetmentor.co.in/api/compare-colleges';

  @override
  void onInit() {
    super.onInit();
    final ids = Get.arguments as List<String>? ?? [];
    if (ids.isNotEmpty) fetchComparison(ids);
  }

  Future<void> fetchComparison(List<String> ids) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'college_ids': ids}), // ✅ List<String> sent as-is now
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == true) {
          final List data = decoded['data'] ?? [];
          colleges.value =
              data.map((e) => CompareCollegeModel.fromJson(e)).toList();
        } else {
          hasError.value = true;
          errorMessage.value = decoded['message'] ?? 'Something went wrong';
        }
      } else {
        hasError.value = true;
        errorMessage.value = 'Server error (${response.statusCode})';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Unable to fetch comparison. Check connection.';
    } finally {
      isLoading.value = false;
    }
  }

  void removeCollege(String id) {
    colleges.removeWhere((c) => c.id == id);
    if (colleges.length < 2) {
      Get.back();
    }
  }
}