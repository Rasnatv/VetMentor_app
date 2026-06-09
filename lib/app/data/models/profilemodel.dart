// data/models/modelclass.dart
import 'package:flutter/material.dart';

class User {
  final String id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String? profileImageUrl;
  DateTime? dateOfBirth;
  String? address;
  String? city;
  String? state;
  String? pincode;
  String? education;
  String? neetScore;
  String? interestedCourse;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    this.dateOfBirth,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.education,
    this.neetScore,
    this.interestedCourse,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
    'profileImageUrl': profileImageUrl,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'address': address,
    'city': city,
    'state': state,
    'pincode': pincode,
    'education': education,
    'neetScore': neetScore,
    'interestedCourse': interestedCourse,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    email: json['email'],
    phone: json['phone'],
    profileImageUrl: json['profileImageUrl'],
    dateOfBirth: json['dateOfBirth'] != null
        ? DateTime.parse(json['dateOfBirth'])
        : null,
    address: json['address'],
    city: json['city'],
    state: json['state'],
    pincode: json['pincode'],
    education: json['education'],
    neetScore: json['neetScore'],
    interestedCourse: json['interestedCourse'],
  );

  String get fullName => '$firstName $lastName';
}

class College {
  final String id;
  final String name;
  final String location;
  final String rating;
  final int fees;
  final String? imageUrl;
  final String? description;

  College({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.fees,
    this.imageUrl,
    this.description,
  });
}

class MockData {
  static List<College> colleges = [
    College(
      id: '1',
      name: 'Indian Veterinary Research Institute',
      location: 'Bareilly, Uttar Pradesh',
      rating: '4.8',
      fees: 85000,
      description: 'Premier veterinary research institute in India',
    ),
    College(
      id: '2',
      name: 'Madras Veterinary College',
      location: 'Chennai, Tamil Nadu',
      rating: '4.7',
      fees: 75000,
      description: 'One of the oldest veterinary colleges in India',
    ),
    College(
      id: '3',
      name: 'Mumbai Veterinary College',
      location: 'Mumbai, Maharashtra',
      rating: '4.6',
      fees: 80000,
      description: 'Leading veterinary education provider',
    ),
    College(
      id: '4',
      name: 'Bangalore Veterinary College',
      location: 'Bangalore, Karnataka',
      rating: '4.5',
      fees: 78000,
      description: 'Excellent placement records',
    ),
  ];

  static User userProfile = User(
    id: 'user_001',
    firstName: 'Vet',
    lastName: 'Aspirant',
    email: 'vet.aspirant@example.com',
    phone: '9876543210',
    profileImageUrl: null,
    dateOfBirth: DateTime(2002, 5, 15),
    address: '123 Main Street',
    city: 'New Delhi',
    state: 'Delhi',
    pincode: '110001',
    education: '12th (PCB)',
    neetScore: '620',
    interestedCourse: 'B.V.Sc & A.H',
  );
}