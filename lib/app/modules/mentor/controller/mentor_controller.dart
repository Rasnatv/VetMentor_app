
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veterinaryapp/app/core/network/api_constants.dart';
import '../../../data/errors/ApiErrotHandler.dart';
import '../../../no internetconnection/network_service.dart';
import '../../../widgets/appsnackbar.dart';

class MentorVideo {
  final String id;
  final String youtubeUrl;

  MentorVideo({required this.id, required this.youtubeUrl});

  factory MentorVideo.fromJson(Map<String, dynamic> json) {
    return MentorVideo(
      id: json['id'] as String,
      youtubeUrl: json['youtube_url'] as String,
    );
  }

  String? get videoId {
    final uri = Uri.tryParse(youtubeUrl);
    if (uri == null) return null;
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }
    return uri.queryParameters['v'];
  }

  String? get thumbnailUrl {
    final vid = videoId;
    if (vid == null) return null;
    return 'https://img.youtube.com/vi/$vid/hqdefault.jpg';
  }
}

class MentorController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isVideosLoading = false.obs;
  final RxBool videosError = false.obs; // ✅ Added to track non-network errors
  final RxString enquiryName = ''.obs;
  final RxString enquiryPhone = ''.obs;
  final RxString enquiryMessage = ''.obs;
  final RxList<MentorVideo> videos = <MentorVideo>[].obs;

  final _dio = Dio();

  static const String _videosApiUrl = '${ApiConstants.baseUrl}/get-videos';
  static const String youtubeChannelUrl =
      'https://youtube.com/@vetadmissionmentor?si=Phnp_C-Z8dr32Gh0';
  static const String mentorPhone = '+9195447 33000';
  static const String mentorWhatsApp = '+9195447 33000';

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
    // ✅ Re-fetch when internet comes back
    Get.find<NetworkService>().register(_onReconnect);
  }

  @override
  void onClose() {
    Get.find<NetworkService>().unregister(_onReconnect);
    super.onClose();
  }

  // ── reconnect callback ────────────────────────────────────
  Future<void> _onReconnect() => fetchVideos();

  Future<void> fetchVideos() async {
    isVideosLoading.value = true;
    videosError.value = false;

    try {
      final res = await _dio.get(
        _videosApiUrl,
        options: Options(
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      final body = res.data as Map<String, dynamic>;

      if (body['status_code'] == '200') {
        final list = (body['data'] as List)
            .map((e) => MentorVideo.fromJson(e as Map<String, dynamic>))
            .toList();
        videos.assignAll(list);
      } else {
        // API returned failure — show snackbar
        AppSnackbar.error(
          body['message']?.toString() ?? 'Failed to load videos.',
        );
      }
    } on DioException catch (e) {
      if (ApiErrorHandler.isNetworkError(e)) {
        // ✅ Network error — stay silent, NetworkAwareWrapper handles it
        videosError.value = false;
      } else {
        // ✅ Real API error — show snackbar
        AppSnackbar.error(ApiErrorHandler.handleDioError(e));
      }
    } catch (_) {
      // Silently fail — UI falls back to the static channel card
    } finally {
      isVideosLoading.value = false;
    }
  }

  Future<void> openVideo(MentorVideo video) async {
    final uri = Uri.parse(video.youtubeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppSnackbar.error('Could not open video.');
    }
  }

  Future<void> openYouTubeChannel() async {
    final uri = Uri.parse(youtubeChannelUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppSnackbar.error('Could not open YouTube.');
    }
  }

  Future<void> callMentor() async {
    final uri = Uri.parse('tel:$mentorPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppSnackbar.error('Could not make call.');
    }
  }

  Future<void> openWhatsApp() async {
    final number = mentorWhatsApp.replaceAll('+', '').replaceAll(' ', '');
    final uri = Uri.parse(
        'https://wa.me/$number?text=Hi, I found your contact on VetColleges app. I need guidance for BVSc admission.');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppSnackbar.error('Could not open WhatsApp.');
    }
  }
 }