
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

  // ── Profile State ─────────────────────────────────────────
  final Rx<StudentProfileModel?> profile = Rx(null);
  final Rx<ProfileState> profileState    = ProfileState.idle.obs;
  final RxString profileError            = ''.obs;
  final RxBool isUpdating                = false.obs;

  // ── Dropdowns ─────────────────────────────────────────────
  final RxList<StateModel>   states   = <StateModel>[].obs;
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
    // ✅ Re-fetch when internet comes back
    Get.find<NetworkService>().register(_onReconnect);
  }

  @override
  void onClose() {
    Get.find<NetworkService>().unregister(_onReconnect);
    super.onClose();
  }

  // ── reconnect callback ────────────────────────────────────
  Future<void> _onReconnect() async {
    await fetchProfile();
    await _fetchDropdowns();
  }

  // ── Fetch Profile ─────────────────────────────────────────
  Future<void> fetchProfile() async {
    final studentId = _storedStudentId;

    if (studentId.isEmpty) {
      profileState.value = ProfileState.error;
      profileError.value = 'No registration found. Please submit an enquiry first.';
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
        // ✅ Network error — stay idle, NetworkAwareWrapper shows offline page
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

  // ── Fetch Dropdowns ───────────────────────────────────────
  Future<void> _fetchDropdowns() async {
    dropdownsLoading.value = true;

    try {
      final results = await Future.wait([
        _dio.get('/get-states'),
        _dio.get('/get-programs'),
      ]);

      final statesRes = StatesResponse.fromJson(
        results[0].data as Map<String, dynamic>,
      );

      final programsRes = ProgramsResponse.fromJson(
        results[1].data as Map<String, dynamic>,
      );

      if (statesRes.isSuccess) states.assignAll(statesRes.data);
      if (programsRes.isSuccess) programs.assignAll(programsRes.data);

    } on DioException catch (e) {
      if (!ApiErrorHandler.isNetworkError(e)) {
        // ✅ Only show snackbar for non-network errors
        AppSnackbar.error(ApiErrorHandler.handleDioError(e));
      }
    } catch (e) {
      AppSnackbar.error('Failed to load dropdown data.');
    } finally {
      dropdownsLoading.value = false;
    }
  }

  // ── Update Profile ────────────────────────────────────────
  Future<bool> updateProfile({
    required String id,
    required String firstName,
    required String lastName,
    required String gender,
    required String email,
    required String phoneNo,
    required String stateId,
    required String programId,
    required String netScore,
  }) async {
    isUpdating.value = true;

    try {
      final res = await _dio.put(
        '/student-update',
        data: {
          'id':         id,
          'first_name': firstName,
          'last_name':  lastName,
          'gender':     gender,
          'email':      email,
          'phone_no':   phoneNo,
          'state_id':   stateId,
          'program_id': programId,
          'net_score':  netScore,
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