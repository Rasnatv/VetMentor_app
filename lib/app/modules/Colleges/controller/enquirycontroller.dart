
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/storage/storage.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../data/models/college_detailmodel.dart';
import '../../../data/models/studentregistermodel.dart';

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

  /// True when this device has a valid registered student id stored locally.
  bool get isAlreadyRegistered => _registered.value;

  bool get isFormLoading => formState.value == EnquiryFormState.loading;
  bool get isFormSuccess => formState.value == EnquiryFormState.success;

  // ── Stored student id ─────────────────────────────────────
  String get _storedStudentId =>
      Storage.getValue<String>(_kRegisteredStudentId) ?? '';

  /// Public getter for other controllers to access the student id
  int get studentId => int.tryParse(_storedStudentId) ?? 0;

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _syncRegistrationState();
  }

  Future<void> _syncRegistrationState() async {
    final storedId = _storedStudentId;

    if (storedId.isEmpty) {
      _registered.value = false;
      _fetchDropdowns();
      return;
    }

    final stillExists = await _verifyStudentExists(storedId);

    if (stillExists) {
      _registered.value = true;
    } else {
      await Storage.removeValue(_kRegisteredStudentId);
      _registered.value = false;
      _fetchDropdowns();
      debugPrint('EnquiryController: stored student id $storedId not found '
          'on server — registration reset.');
    }
  }

  Future<bool> _verifyStudentExists(String studentId) async {
    try {
      final res = await _dio.post(
        '/get-student-details',
        data: {'id': studentId},
      );
      final json = res.data as Map<String, dynamic>;
      final status = json['status']?.toString() ?? '';
      final code   = json['status_code']?.toString() ?? '';
      return status == '1' && code == '200';
    } catch (_) {
      return true;
    }
  }

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
      detailError.value = ApiErrorHandler.handleDioError(e);
    } catch (e) {
      detailError.value = e.toString();
    } finally {
      detailLoading.value = false;
    }
  }

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
      formError.value = ApiErrorHandler.handleDioError(e);
      formState.value = EnquiryFormState.error;
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
      debugPrint('Dropdown fetch failed: ${ApiErrorHandler.handleDioError(e)}');
    } catch (e) {
      debugPrint('Dropdown fetch failed: $e');
    } finally {
      dropdownsLoading.value = false;
    }
  }
}