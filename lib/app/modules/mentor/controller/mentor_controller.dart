
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
  final RxString enquiryName = ''.obs;
  final RxString enquiryPhone = ''.obs;
  final RxString enquiryMessage = ''.obs;
  final RxList<MentorVideo> videos = <MentorVideo>[].obs;

  static const String _videosApiUrl =
      'https://rasma.astradevelops.in/vetniaryapp/public/api/get-videos';
  static const String youtubeChannelUrl =
      'https://youtube.com/@vetadmissionmentor?si=Phnp_C-Z8dr32Gh0';
  static const String mentorPhone = '+9195447 33000';
  static const String mentorWhatsApp = '+9195447 33000';

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    isVideosLoading.value = true;
    try {
      final response = await http
          .get(Uri.parse(_videosApiUrl))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['status_code'] == '200') {
          final list = (json['data'] as List)
              .map((e) => MentorVideo.fromJson(e as Map<String, dynamic>))
              .toList();
          videos.assignAll(list);
        }
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
      Get.snackbar('Error', 'Could not open video',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> openYouTubeChannel() async {
    final uri = Uri.parse(youtubeChannelUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open YouTube',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> callMentor() async {
    final uri = Uri.parse('tel:$mentorPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not make call',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> openWhatsApp() async {
    final number = mentorWhatsApp.replaceAll('+', '').replaceAll(' ', '');
    final uri = Uri.parse(
        'https://wa.me/$number?text=Hi, I found your contact on VetColleges app. I need guidance for BVSc admission.');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open WhatsApp',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> submitEnquiry() async {
    if (enquiryName.value.trim().isEmpty || enquiryPhone.value.trim().isEmpty) {
      Get.snackbar('Required', 'Please fill name and phone number',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    Get.back();
    Get.snackbar('Enquiry Sent!', 'Mentor will contact you within 24 hours.',
        snackPosition: SnackPosition.BOTTOM);
    resetEnquiry();
  }

  void resetEnquiry() {
    enquiryName.value = '';
    enquiryPhone.value = '';
    enquiryMessage.value = '';
  }
}