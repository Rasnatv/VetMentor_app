// College Model
class College {
  final String id;
  final String name;
  final String location;
  final String state;
  final String established;
  final List<String> tags;
  final String type;
  final String affiliatedTo;
  final int yearsEstablished;
  final int facultyCount;
  final int courseCount;
  final int studentCount;
  final String about;
  final String imageUrl;
  final String logoUrl;
  final bool isSaved;
  final List<Course> popularCourses;
  final List<Course> allCourses;

  College({
    required this.id,
    required this.name,
    required this.location,
    required this.state,
    required this.established,
    required this.tags,
    required this.type,
    this.affiliatedTo = '',
    this.yearsEstablished = 0,
    this.facultyCount = 0,
    this.courseCount = 0,
    this.studentCount = 0,
    this.about = '',
    this.imageUrl = '',
    this.logoUrl = '',
    this.isSaved = false,
    this.popularCourses = const [],
    this.allCourses = const [],
  });

  College copyWith({bool? isSaved}) {
    return College(
      id: id,
      name: name,
      location: location,
      state: state,
      established: established,
      tags: tags,
      type: type,
      affiliatedTo: affiliatedTo,
      yearsEstablished: yearsEstablished,
      facultyCount: facultyCount,
      courseCount: courseCount,
      studentCount: studentCount,
      about: about,
      imageUrl: imageUrl,
      logoUrl: logoUrl,
      isSaved: isSaved ?? this.isSaved,
      popularCourses: popularCourses,
      allCourses: allCourses,
    );
  }
}

// Course Model
class Course {
  final String id;
  final String name;
  final String fullName;
  final String duration;
  final int intake;
  final String level; // UG, PG, Diploma, PhD
  final String description;
  final String icon;

  Course({
    required this.id,
    required this.name,
    required this.fullName,
    required this.duration,
    required this.intake,
    required this.level,
    this.description = '',
    this.icon = '',
  });
}

// User Profile Model
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String state;
  final String qualification;
  final String avatarUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.state,
    required this.qualification,
    this.avatarUrl = '',
  });
}

// Application Model
class Application {
  final String id;
  final String applicationId;
  final College college;
  final Course course;
  final String submittedDate;
  final ApplicationStatus status;

  Application({
    required this.id,
    required this.applicationId,
    required this.college,
    required this.course,
    required this.submittedDate,
    required this.status,
  });
}

enum ApplicationStatus {
  submitted,
  underReview,
  shortlisted,
  counselling,
  admission,
}

// Mock Data
class MockData {
  static List<Course> get ivriCourses => [
    Course(
      id: 'c1',
      name: 'BVSc & AH',
      fullName: 'Bachelor of Veterinary Science & Animal Husbandry',
      duration: '5.5 Years',
      intake: 60,
      level: 'UG',
    ),
    Course(
      id: 'c2',
      name: 'MVSc (Animal Nutrition)',
      fullName: 'Master of Veterinary Science in Animal Nutrition',
      duration: '2 Years',
      intake: 15,
      level: 'PG',
    ),
    Course(
      id: 'c3',
      name: 'MVSc (Veterinary Surgery & Radiology)',
      fullName: 'Master of Veterinary Science in Veterinary Surgery & Radiology',
      duration: '2 Years',
      intake: 12,
      level: 'PG',
    ),
    Course(
      id: 'c4',
      name: 'MVSc (Animal Reproduction, Gynaecology & Obstetrics)',
      fullName: 'Master of Veterinary Science in Animal Reproduction, Gynaecology & Obstetrics',
      duration: '2 Years',
      intake: 12,
      level: 'PG',
    ),
    Course(
      id: 'c5',
      name: 'Ph.D. (Veterinary Sciences)',
      fullName: 'Doctor of Philosophy in Veterinary Sciences',
      duration: '3-5 Years',
      intake: 0,
      level: 'PhD',
    ),
    Course(
      id: 'c6',
      name: 'Diploma in Animal Husbandry',
      fullName: 'Diploma in Animal Husbandry',
      duration: '2 Years',
      intake: 50,
      level: 'Diploma',
    ),
  ];

  static List<College> get colleges => [
    College(
      id: '1',
      name: 'Indian Veterinary Research Institute (IVRI)',
      location: 'Bareilly, Uttar Pradesh',
      state: 'Uttar Pradesh',
      established: 'Est. 1889',
      tags: ['ICAR', 'Public'],
      type: 'Public',
      affiliatedTo: 'ICAR',
      yearsEstablished: 135,
      facultyCount: 120,
      courseCount: 25,
      studentCount: 1200,
      about:
      'IVRI is a premier veterinary institute in India, engaged in education, research and extension in the field of animal health.',
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/IVRI_Bareilly.jpg/1280px-IVRI_Bareilly.jpg',
      logoUrl: 'https://www.ivri.nic.in/images/ivri-logo.png',
      popularCourses: [
        Course(
          id: 'c1',
          name: 'BVSc & AH',
          fullName: 'Bachelor of Veterinary Science & Animal Husbandry',
          duration: '5.5 Years',
          intake: 60,
          level: 'UG',
        ),
      ],
      allCourses: ivriCourses,
    ),
    College(
      id: '2',
      name: 'Madras Veterinary College',
      location: 'Chennai, Tamil Nadu',
      state: 'Tamil Nadu',
      established: 'Est. 1903',
      tags: ['TANUVAS', 'Public'],
      type: 'Public',
      affiliatedTo: 'TANUVAS',
      yearsEstablished: 121,
      facultyCount: 95,
      courseCount: 18,
      studentCount: 980,
      about:
      'Madras Veterinary College is one of the oldest veterinary colleges in India, affiliated to TANUVAS.',
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Madras_Veterinary_College.jpg/1280px-Madras_Veterinary_College.jpg',
      logoUrl: '',
      popularCourses: [
        Course(
          id: 'c1',
          name: 'BVSc & AH',
          fullName: 'Bachelor of Veterinary Science & Animal Husbandry',
          duration: '5.5 Years',
          intake: 80,
          level: 'UG',
        ),
      ],
      allCourses: ivriCourses,
    ),
    College(
      id: '3',
      name: 'Guru Angad Dev Veterinary and Animal Sciences University',
      location: 'Ludhiana, Punjab',
      state: 'Punjab',
      established: 'Est. 2005',
      tags: ['State', 'Public'],
      type: 'Public',
      affiliatedTo: 'State University',
      yearsEstablished: 19,
      facultyCount: 68,
      courseCount: 15,
      studentCount: 720,
      about: 'GADVASU is a premier veterinary university in Punjab dedicated to veterinary education and research.',
      imageUrl: 'https://gadvasu.in/images/campus.jpg',
      logoUrl: '',
      popularCourses: [
        Course(
          id: 'c1',
          name: 'BVSc & AH',
          fullName: 'Bachelor of Veterinary Science & Animal Husbandry',
          duration: '5.5 Years',
          intake: 70,
          level: 'UG',
        ),
      ],
      allCourses: ivriCourses,
    ),
    College(
      id: '4',
      name: 'Bombay Veterinary College',
      location: 'Mumbai, Maharashtra',
      state: 'Maharashtra',
      established: 'Est. 1942',
      tags: ['Maharashtra Animal & Fishery Sciences University', 'Public'],
      type: 'Public',
      affiliatedTo: 'MAFSU',
      yearsEstablished: 82,
      facultyCount: 78,
      courseCount: 20,
      studentCount: 860,
      about:
      'Bombay Veterinary College is a prestigious institution in Mumbai offering veterinary education since 1942.',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/Bombay_vet.jpg',
      logoUrl: '',
      popularCourses: [
        Course(
          id: 'c1',
          name: 'BVSc & AH',
          fullName: 'Bachelor of Veterinary Science & Animal Husbandry',
          duration: '5.5 Years',
          intake: 75,
          level: 'UG',
        ),
      ],
      allCourses: ivriCourses,
    ),
    College(
      id: '5',
      name: 'College of Veterinary Science, Karnal',
      location: 'Karnal, Haryana',
      state: 'Haryana',
      established: 'Est. 2010',
      tags: ['LUVAS', 'Public'],
      type: 'Public',
      affiliatedTo: 'LUVAS',
      yearsEstablished: 14,
      facultyCount: 45,
      courseCount: 12,
      studentCount: 540,
      about: 'CVS Karnal is affiliated to LUVAS and offers quality veterinary education in Haryana.',
      imageUrl: '',
      logoUrl: '',
      popularCourses: [
        Course(
          id: 'c1',
          name: 'BVSc & AH',
          fullName: 'Bachelor of Veterinary Science & Animal Husbandry',
          duration: '5.5 Years',
          intake: 60,
          level: 'UG',
        ),
      ],
      allCourses: ivriCourses,
    ),
    College(
      id: '6',
      name: 'Kerala Veterinary and Animal Sciences University',
      location: 'Thrissur, Kerala',
      state: 'Kerala',
      established: 'Est. 2010',
      tags: ['State', 'Public'],
      type: 'Public',
      affiliatedTo: 'State University',
      yearsEstablished: 14,
      facultyCount: 55,
      courseCount: 14,
      studentCount: 620,
      about: 'KVASU is dedicated to veterinary education in Kerala offering world-class facilities.',
      imageUrl: '',
      logoUrl: '',
      popularCourses: [
        Course(
          id: 'c1',
          name: 'BVSc & AH',
          fullName: 'Bachelor of Veterinary Science & Animal Husbandry',
          duration: '5.5 Years',
          intake: 65,
          level: 'UG',
        ),
      ],
      allCourses: ivriCourses,
    ),
  ];

  static List<String> get indianStates => [
    'All States',
    'Andhra Pradesh',
    'Bihar',
    'Delhi',
    'Gujarat',
    'Haryana',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Punjab',
    'Rajasthan',
    'Tamil Nadu',
    'Telangana',
    'Uttar Pradesh',
    'West Bengal',
  ];

  static UserProfile get userProfile => UserProfile(
    id: 'u1',
    name: 'Rahul Sharma',
    email: 'rahul.sharma@email.com',
    phone: '+91 98765 43210',
    state: 'Uttar Pradesh',
    qualification: '12th Science (PCB)',
    avatarUrl: '',
  );
}