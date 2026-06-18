
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:io';
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

  // ── College detail ────────────────────────────────────────────────────────
  final Rx<CollegeDetailModel?> collegeDetail = Rx(null);
  final RxBool detailLoading = false.obs;
  final RxString detailError = ''.obs;

  // ── Enquiry form — programs dropdown only ─────────────────────────────────
  // State / district are now free-text fields; no state dropdown needed.
  final RxList<ProgramModel> programs = <ProgramModel>[].obs;
  final RxBool dropdownsLoading = false.obs;

  // ── Form submit state ─────────────────────────────────────────────────────
  final Rx<EnquiryFormState> formState = EnquiryFormState.idle.obs;
  final RxString formError = ''.obs;

  final RxBool _registered = false.obs;

  bool get isAlreadyRegistered => _registered.value;
  bool get isFormLoading => formState.value == EnquiryFormState.loading;
  bool get isFormSuccess => formState.value == EnquiryFormState.success;

  // ── Stored student id ─────────────────────────────────────────────────────
  String get _storedStudentId =>
      Storage.getValue<String>(_kRegisteredStudentId) ?? '';

  int get studentId => int.tryParse(_storedStudentId) ?? 0;

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _syncRegistrationState();
    Get.find<NetworkService>().register(_onReconnect);
  }

  @override
  void onClose() {
    Get.find<NetworkService>().unregister(_onReconnect);
    super.onClose();
  }

  // ── Reconnect callback ────────────────────────────────────────────────────
  Future<void> _onReconnect() async {
    if (!_registered.value) await _fetchPrograms();
  }

  Future<void> _syncRegistrationState() async {
    final storedId = _storedStudentId;
    if (storedId.isEmpty) {
      _registered.value = false;
      _fetchPrograms();
    } else {
      _registered.value = true;
    }
  }

  // ── Enquiry form visibility logic ─────────────────────────────────────────
  ///
  /// Rules:
  ///   • Already registered (any platform, any type) → false (skip form)
  ///   • Android, type=0 → true  (show form)
  ///   • Android, type=1 → true  (show form)
  ///   • iOS,     type=0 → true  (show form)
  ///   • iOS,     type=1 → false (skip form, go directly to college detail)
  bool shouldShowEnquiryForm(String collegeType) {
    if (_registered.value) return false;
    if (Platform.isAndroid) return true;
    return collegeType == '0';
  }

  // ── Fetch College Detail ──────────────────────────────────────────────────
  Future<void> fetchCollegeDetail(String collegeId) async {
    detailLoading.value = true;
    detailError.value = '';
    collegeDetail.value = null;

    try {
      final res = await _dio.post(
        '/college-details',
        data: {'id': collegeId},
      );
      final response =
      CollegeDetailResponse.fromJson(res.data as Map<String, dynamic>);

      if (response.isSuccess && response.data != null) {
        collegeDetail.value = response.data;
      } else {
        detailError.value = response.message;
      }
    } on DioException catch (e) {
      if (ApiErrorHandler.isNetworkError(e)) {
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

  // ── Submit Enquiry ────────────────────────────────────────────────────────
  Future<void> submitEnquiry(StudentRegisterRequest request) async {
    formState.value = EnquiryFormState.loading;
    formError.value = '';

    try {
      final res = await _dio.post(
        '/student-register',
        data: request.toJson(),
      );
      final response =
      StudentRegisterResponse.fromJson(res.data as Map<String, dynamic>);

      if (response.isSuccess) {
        await Storage.saveValueForce(
            _kRegisteredStudentId, response.studentId);
        _registered.value = true;
        formState.value = EnquiryFormState.success;
      } else {
        formError.value = response.message;
        formState.value = EnquiryFormState.error;
      }
    } on DioException catch (e) {
      if (ApiErrorHandler.isNetworkError(e)) {
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
    _fetchPrograms();
  }

  // ── Private — fetch programs only (state is now free text) ───────────────
  Future<void> _fetchPrograms() async {
    dropdownsLoading.value = true;
    try {
      final res = await _dio.get('/get-programs');
      final programsRes =
      ProgramsResponse.fromJson(res.data as Map<String, dynamic>);
      if (programsRes.isSuccess) programs.assignAll(programsRes.data);
    } on DioException catch (e) {
      if (!ApiErrorHandler.isNetworkError(e)) {
        debugPrint(
            'Programs fetch failed: ${ApiErrorHandler.handleDioError(e)}');
      }
    } catch (e) {
      debugPrint('Programs fetch failed: $e');
    } finally {
      dropdownsLoading.value = false;
    }
  }
}