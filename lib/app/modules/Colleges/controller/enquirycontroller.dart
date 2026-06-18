//
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import '../../../core/network/api_constants.dart';
// import '../../../core/storage/storage.dart';
// import '../../../data/errors/ApiErrotHandler.dart';
// import '../../../data/models/college_detailmodel.dart';
// import '../../../data/models/studentregistermodel.dart';
// import '../../../no internetconnection/network_service.dart';
//
// const _kRegisteredStudentId = 'registered_student_id';
//
// enum EnquiryFormState { idle, loading, success, error }
//
// class EnquiryController extends GetxController {
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: ApiConstants.baseUrl,
//       connectTimeout: const Duration(seconds: 30),
//       receiveTimeout: const Duration(seconds: 30),
//       headers: {'Accept': 'application/json'},
//     ),
//   );
//
//   // ── College detail ────────────────────────────────────────
//   final Rx<CollegeDetailModel?> collegeDetail = Rx(null);
//   final RxBool   detailLoading = false.obs;
//   final RxString detailError   = ''.obs;
//
//   // ── Enquiry form dropdowns ────────────────────────────────
//   final RxList<StateModel>   states   = <StateModel>[].obs;
//   final RxList<ProgramModel> programs = <ProgramModel>[].obs;
//   final RxBool dropdownsLoading = false.obs;
//
//   // ── Form submit state ─────────────────────────────────────
//   final Rx<EnquiryFormState> formState = EnquiryFormState.idle.obs;
//   final RxString formError = ''.obs;
//
//   final RxBool _registered = false.obs;
//
//   bool get isAlreadyRegistered => _registered.value;
//   bool get isFormLoading => formState.value == EnquiryFormState.loading;
//   bool get isFormSuccess => formState.value == EnquiryFormState.success;
//
//   // ── Stored student id ─────────────────────────────────────
//   String get _storedStudentId =>
//       Storage.getValue<String>(_kRegisteredStudentId) ?? '';
//
//   int get studentId => int.tryParse(_storedStudentId) ?? 0;
//
//   // ── Lifecycle ─────────────────────────────────────────────
//   @override
//   void onInit() {
//     super.onInit();
//     _syncRegistrationState();
//     // ✅ Re-fetch dropdowns when internet comes back
//     Get.find<NetworkService>().register(_onReconnect);
//   }
//
//   @override
//   void onClose() {
//     Get.find<NetworkService>().unregister(_onReconnect);
//     super.onClose();
//   }
//
//   // ── reconnect callback ────────────────────────────────────
//   Future<void> _onReconnect() async {
//     // Only re-fetch dropdowns if not yet registered (form is visible)
//     if (!_registered.value) await _fetchDropdowns();
//   }
//
//   Future<void> _syncRegistrationState() async {
//     final storedId = _storedStudentId;
//     if (storedId.isEmpty) {
//       _registered.value = false;
//       _fetchDropdowns();
//     } else {
//       _registered.value = true;
//     }
//   }
//
//   // ── Fetch College Detail ──────────────────────────────────
//   Future<void> fetchCollegeDetail(String collegeId) async {
//     detailLoading.value = true;
//     detailError.value   = '';
//     collegeDetail.value = null;
//
//     try {
//       final res = await _dio.post(
//         '/college-details',
//         data: {'id': collegeId},
//       );
//       final response = CollegeDetailResponse.fromJson(
//           res.data as Map<String, dynamic>);
//
//       if (response.isSuccess && response.data != null) {
//         collegeDetail.value = response.data;
//       } else {
//         detailError.value = response.message;
//       }
//     } on DioException catch (e) {
//       if (ApiErrorHandler.isNetworkError(e)) {
//         // ✅ Network error — stay silent, NetworkAwareWrapper handles it
//         detailError.value = '';
//       } else {
//         detailError.value = ApiErrorHandler.handleDioError(e);
//       }
//     } catch (e) {
//       detailError.value = e.toString();
//     } finally {
//       detailLoading.value = false;
//     }
//   }
//
//   // ── Submit Enquiry ────────────────────────────────────────
//   Future<void> submitEnquiry(StudentRegisterRequest request) async {
//     formState.value = EnquiryFormState.loading;
//     formError.value = '';
//
//     try {
//       final res = await _dio.post(
//         '/student-register',
//         data: request.toJson(),
//       );
//       final response = StudentRegisterResponse.fromJson(
//           res.data as Map<String, dynamic>);
//
//       if (response.isSuccess) {
//         await Storage.saveValueForce(
//             _kRegisteredStudentId, response.studentId);
//         _registered.value = true;
//         formState.value   = EnquiryFormState.success;
//       } else {
//         formError.value = response.message;
//         formState.value = EnquiryFormState.error;
//       }
//     } on DioException catch (e) {
//       if (ApiErrorHandler.isNetworkError(e)) {
//         // ✅ Network error — stay silent, NetworkAwareWrapper handles it
//         formState.value = EnquiryFormState.idle;
//         formError.value = '';
//       } else {
//         formError.value = ApiErrorHandler.handleDioError(e);
//         formState.value = EnquiryFormState.error;
//       }
//     } catch (e) {
//       formError.value = e.toString();
//       formState.value = EnquiryFormState.error;
//     }
//   }
//
//   void resetForm() {
//     formState.value = EnquiryFormState.idle;
//     formError.value = '';
//   }
//
//   Future<void> resetRegistration() async {
//     await Storage.removeValue(_kRegisteredStudentId);
//     _registered.value = false;
//     _fetchDropdowns();
//   }
//
//   // ── Private ───────────────────────────────────────────────
//   Future<void> _fetchDropdowns() async {
//     dropdownsLoading.value = true;
//     try {
//       final results = await Future.wait([
//         _dio.get('/get-states'),
//         _dio.get('/get-programs'),
//       ]);
//
//       final statesRes = StatesResponse.fromJson(
//           results[0].data as Map<String, dynamic>);
//       final programsRes = ProgramsResponse.fromJson(
//           results[1].data as Map<String, dynamic>);
//
//       if (statesRes.isSuccess)   states.assignAll(statesRes.data);
//       if (programsRes.isSuccess) programs.assignAll(programsRes.data);
//     } on DioException catch (e) {
//       // ✅ Silently ignore network errors, log others
//       if (!ApiErrorHandler.isNetworkError(e)) {
//         debugPrint('Dropdown fetch failed: ${ApiErrorHandler.handleDioError(e)}');
//       }
//     } catch (e) {
//       debugPrint('Dropdown fetch failed: $e');
//     } finally {
//       dropdownsLoading.value = false;
//     }
//   }
// }
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/storage/storage.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../data/models/college_detailmodel.dart';
import '../../../data/models/studentregistermodel.dart';
import '../../../no internetconnection/network_service.dart';

const _kRegisteredStudentId = 'registered_student_id';

enum EnquiryFormState { idle, loading, success, error }

class EnquiryController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  // ── College detail ────────────────────────────────────────
  final Rx<CollegeDetailModel?> collegeDetail = Rx(null);
  final RxBool   detailLoading = false.obs;
  final RxString detailError   = ''.obs;

  // ── Enquiry form dropdowns ────────────────────────────────
  final RxList<StateModel>   states   = <StateModel>[].obs;
  final RxList<ProgramModel> programs = <ProgramModel>[].obs;
  final RxBool dropdownsLoading = false.obs;

  // ── Form submit state ─────────────────────────────────────
  final Rx<EnquiryFormState> formState = EnquiryFormState.idle.obs;
  final RxString formError = ''.obs;

  final RxBool _registered = false.obs;

  bool get isAlreadyRegistered => _registered.value;
  bool get isFormLoading => formState.value == EnquiryFormState.loading;
  bool get isFormSuccess => formState.value == EnquiryFormState.success;

  // ── Stored student id ─────────────────────────────────────
  String get _storedStudentId =>
      Storage.getValue<String>(_kRegisteredStudentId) ?? '';

  int get studentId => int.tryParse(_storedStudentId) ?? 0;

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _syncRegistrationState();
    // ✅ Re-fetch dropdowns when internet comes back
    Get.find<NetworkService>().register(_onReconnect);
  }

  @override
  void onClose() {
    Get.find<NetworkService>().unregister(_onReconnect);
    super.onClose();
  }

  // ── Reconnect callback ────────────────────────────────────
  Future<void> _onReconnect() async {
    // Only re-fetch dropdowns if not yet registered (form is visible)
    if (!_registered.value) await _fetchDropdowns();
  }

  Future<void> _syncRegistrationState() async {
    final storedId = _storedStudentId;
    if (storedId.isEmpty) {
      _registered.value = false;
      _fetchDropdowns();
    } else {
      _registered.value = true;
    }
  }

  // ── Enquiry form visibility logic ─────────────────────────
  ///
  /// Rules:
  ///   • Already registered (any platform, any type) → false (skip form)
  ///   • Android, type=0 → true  (show form)
  ///   • Android, type=1 → true  (show form)
  ///   • iOS,     type=0 → true  (show form)
  ///   • iOS,     type=1 → false (skip form, go directly to college detail)
  bool shouldShowEnquiryForm(String collegeType) {
    // Already registered → always skip form
    if (_registered.value) return false;

    // Android → always show form regardless of type
    if (Platform.isAndroid) return true;

    // iOS → show form only for type=0, skip for type=1
    return collegeType == '0';
  }

  // ── Fetch College Detail ──────────────────────────────────
  Future<void> fetchCollegeDetail(String collegeId) async {
    detailLoading.value = true;
    detailError.value   = '';
    collegeDetail.value = null;

    try {
      final res = await _dio.post(
        '/college-details',
        data: {'id': collegeId},
      );
      final response = CollegeDetailResponse.fromJson(
          res.data as Map<String, dynamic>);

      if (response.isSuccess && response.data != null) {
        collegeDetail.value = response.data;
      } else {
        detailError.value = response.message;
      }
    } on DioException catch (e) {
      if (ApiErrorHandler.isNetworkError(e)) {
        // ✅ Network error — stay silent, NetworkAwareWrapper handles it
        detailError.value = '';
      } else {
        detailError.value = ApiErrorHandler.handleDioError(e);
      }
    } catch (e) {
      detailError.value = e.toString();
    } finally {
      detailLoading.value = false;
    }
  }

  // ── Submit Enquiry ────────────────────────────────────────
  Future<void> submitEnquiry(StudentRegisterRequest request) async {
    formState.value = EnquiryFormState.loading;
    formError.value = '';

    try {
      final res = await _dio.post(
        '/student-register',
        data: request.toJson(),
      );
      final response = StudentRegisterResponse.fromJson(
          res.data as Map<String, dynamic>);

      if (response.isSuccess) {
        await Storage.saveValueForce(
            _kRegisteredStudentId, response.studentId);
        _registered.value = true;
        formState.value   = EnquiryFormState.success;
      } else {
        formError.value = response.message;
        formState.value = EnquiryFormState.error;
      }
    } on DioException catch (e) {
      if (ApiErrorHandler.isNetworkError(e)) {
        // ✅ Network error — stay silent, NetworkAwareWrapper handles it
        formState.value = EnquiryFormState.idle;
        formError.value = '';
      } else {
        formError.value = ApiErrorHandler.handleDioError(e);
        formState.value = EnquiryFormState.error;
      }
    } catch (e) {
      formError.value = e.toString();
      formState.value = EnquiryFormState.error;
    }
  }

  void resetForm() {
    formState.value = EnquiryFormState.idle;
    formError.value = '';
  }

  Future<void> resetRegistration() async {
    await Storage.removeValue(_kRegisteredStudentId);
    _registered.value = false;
    _fetchDropdowns();
  }

  // ── Private ───────────────────────────────────────────────
  Future<void> _fetchDropdowns() async {
    dropdownsLoading.value = true;
    try {
      final results = await Future.wait([
        _dio.get('/get-states'),
        _dio.get('/get-programs'),
      ]);

      final statesRes = StatesResponse.fromJson(
          results[0].data as Map<String, dynamic>);
      final programsRes = ProgramsResponse.fromJson(
          results[1].data as Map<String, dynamic>);

      if (statesRes.isSuccess)   states.assignAll(statesRes.data);
      if (programsRes.isSuccess) programs.assignAll(programsRes.data);
    } on DioException catch (e) {
      // ✅ Silently ignore network errors, log others
      if (!ApiErrorHandler.isNetworkError(e)) {
        debugPrint('Dropdown fetch failed: ${ApiErrorHandler.handleDioError(e)}');
      }
    } catch (e) {
      debugPrint('Dropdown fetch failed: $e');
    } finally {
      dropdownsLoading.value = false;
    }
  }
}