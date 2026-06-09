import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MentorController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString enquiryName = ''.obs;
  final RxString enquiryPhone = ''.obs;
  final RxString enquiryMessage = ''.obs;

  static const String youtubeChannelUrl =
      'https://youtube.com/@vetadmissionmentor?si=Phnp_C-Z8dr32Gh0';
  static const String mentorPhone = '+9195447 33000';
  static const String mentorWhatsApp = '+9195447 33000';

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