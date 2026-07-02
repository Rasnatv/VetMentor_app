import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/widgets/appsnackbar.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/storage/storage.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../data/models/studentprofilemodel.dart';
import '../../../data/models/studentregistermodel.dart';
import '../../../no internetconnection/network_service.dart';
import '../../Colleges/controller/enquirycontroller.dart';

const _kRegisteredStudentId = 'registered_student_id';

enum ProfileState { idle, loading, success, error }

class ProfileController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );


  final Rx<StudentProfileModel?> profile = Rx(null);
  final Rx<ProfileState> profileState    = ProfileState.idle.obs;
  final RxString profileError            = ''.obs;
  final RxBool isUpdating                = false.obs;

  final RxList<ProgramModel> programs = <ProgramModel>[].obs;
  final RxBool dropdownsLoading = false.obs;

  bool get isLoading     => profileState.value == ProfileState.loading;
  bool get isSuccess     => profileState.value == ProfileState.success;
  bool get hasError      => profileState.value == ProfileState.error;
  bool get getIsUpdating => isUpdating.value;

  // ── Student ID — memory first, storage fallback ───────────
  String get _storedStudentId {
    try {
      final enquiry = Get.find<EnquiryController>();
      final id = enquiry.studentId.toString();
      if (id.isNotEmpty && id != '0') return id;
    } catch (_) {}
    return Storage.getValue<String>(_kRegisteredStudentId) ?? '';
  }

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    _fetchDropdowns();
    Get.find<NetworkService>().register(_onReconnect);
  }

  @override
  void onClose() {
    Get.find<NetworkService>().unregister(_onReconnect);
    super.onClose();
  }

  // ── Reconnect callback ────────────────────────────────────
  Future<void> _onReconnect() async {
    await fetchProfile();
    await _fetchDropdowns();
  }

  // ── Fetch Profile ─────────────────────────────────────────
  Future<void> fetchProfile() async {
    final studentId = _storedStudentId;

    if (studentId.isEmpty) {
      profileState.value = ProfileState.error;
      profileError.value =
      'No registration found. Please submit an enquiry first.';
      return;
    }

    profileState.value = ProfileState.loading;
    profileError.value = '';
    profile.value      = null;

    try {
      final res = await _dio.post(
        '/student-by-id',
        data: {'id': studentId},
      );

      final response = StudentProfileResponse.fromJson(
          res.data as Map<String, dynamic>);

      if (response.isSuccess && response.data != null) {
        profile.value      = response.data;
        profileState.value = ProfileState.success;
      } else {
        profileError.value = response.message.isNotEmpty
            ? response.message
            : 'Failed to load profile.';
        profileState.value = ProfileState.error;
        AppSnackbar.error(profileError.value);
      }
    } on DioException catch (e) {
      if (ApiErrorHandler.isNetworkError(e)) {
        profileState.value = ProfileState.idle;
        profileError.value = '';
      } else {
        profileError.value = ApiErrorHandler.handleDioError(e);
        profileState.value = ProfileState.error;
        AppSnackbar.error(profileError.value);
      }
    } catch (e) {
      profileError.value = 'Unexpected error occurred.';
      profileState.value = ProfileState.error;
      AppSnackbar.error(profileError.value);
    }
  }

  // ── Fetch Dropdowns (programs only — state is free text) ──
  Future<void> _fetchDropdowns() async {
    dropdownsLoading.value = true;

    try {
      final res = await _dio.get('/get-programs');
      final programsRes = ProgramsResponse.fromJson(
          res.data as Map<String, dynamic>);
      if (programsRes.isSuccess) programs.assignAll(programsRes.data);
    } on DioException catch (e) {
      if (!ApiErrorHandler.isNetworkError(e)) {
        AppSnackbar.error(ApiErrorHandler.handleDioError(e));
      }
    } catch (e) {
      AppSnackbar.error('Failed to load programs.');
    } finally {
      dropdownsLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    required String id,
    required String firstName,
    required String lastName,
    required String gender,
    required String email,
    required String countryCode,
    required String phoneNo,
    required String state,
    required String district,
    required String country,
    required String address,
    required String pincode,
    required String programId,
    required String netScore,
  }) async {
    isUpdating.value = true;

    try {
      final res = await _dio.put(
        '/student-update',
        data: {
          'id':          id,
          'first_name':  firstName,
          'last_name':   lastName,
          'gender':      gender,
          'email':       email,
          'country_code': countryCode,
          'phone_no':    phoneNo,
          'state':       state,
          'district':    district,
          'country':     country,
          'address':     address,
          'pincode':     pincode,
          'program_id':  programId,
          'net_score':   netScore,
        },
      );

      final response = StudentProfileResponse.fromJson(
          res.data as Map<String, dynamic>);

      if (response.isSuccess && response.data != null) {
        profile.value = response.data;
        AppSnackbar.success('Profile updated successfully.');
        return true;
      } else {
        final msg = response.message.isNotEmpty
            ? response.message
            : 'Update failed.';
        AppSnackbar.error(msg);
        return false;
      }
    } on DioException catch (e) {
      if (!ApiErrorHandler.isNetworkError(e)) {
        AppSnackbar.error(ApiErrorHandler.handleDioError(e));
      }
      return false;
    } finally {
      isUpdating.value = false;
    }
  }
}