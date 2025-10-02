import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String region;
  final String role;
  final String? bio;
  final String? profileImage;
  final List<String> skills;
  final double rating;
  final int reviewCount;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.region,
    required this.role,
    this.bio,
    this.profileImage,
    this.skills = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  String get fullName => '$firstName $lastName';
}

class UserProvider with ChangeNotifier {
  User? _currentUser;
  List<User> _allUsers = [];

  User? get currentUser => _currentUser;
  List<User> get allUsers => _allUsers;

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void updateCurrentUser(Map<String, dynamic> updates) {
    if (_currentUser != null) {
      _currentUser = User(
        id: _currentUser!.id,
        firstName: updates['firstName'] ?? _currentUser!.firstName,
        lastName: updates['lastName'] ?? _currentUser!.lastName,
        email: updates['email'] ?? _currentUser!.email,
        phone: updates['phone'] ?? _currentUser!.phone,
        region: updates['region'] ?? _currentUser!.region,
        role: updates['role'] ?? _currentUser!.role,
        bio: updates['bio'] ?? _currentUser!.bio,
        profileImage: updates['profileImage'] ?? _currentUser!.profileImage,
        skills: updates['skills'] ?? _currentUser!.skills,
        rating: updates['rating'] ?? _currentUser!.rating,
        reviewCount: updates['reviewCount'] ?? _currentUser!.reviewCount,
      );
      notifyListeners();
    }
  }

  // Mock user data
  void initializeMockData() {
    _allUsers = [
      User(
        id: '1',
        firstName: 'Amina',
        lastName: 'Ben Salem',
        email: 'amina.bensalem@email.com',
        phone: '+216 12 345 678',
        region: 'Sfax',
        role: 'farmer',
        bio: 'Tomato farmer with 10 years of experience. Passionate about sustainable farming practices.',
        skills: ['Tomato Cultivation', 'Organic Farming', 'Water Management'],
        rating: 4.8,
        reviewCount: 42,
      ),
      User(
        id: '2',
        firstName: 'Fatma',
        lastName: 'Khelifi',
        email: 'fatma.khelifi@email.com',
        phone: '+216 98 765 432',
        region: 'Kairouan',
        role: 'farmer',
        bio: 'Olive farmer specializing in premium olive oil production.',
        skills: ['Olive Cultivation', 'Oil Production', 'Quality Control'],
        rating: 4.9,
        reviewCount: 38,
      ),
      User(
        id: '3',
        firstName: 'Leila',
        lastName: 'Mansouri',
        email: 'leila.mansouri@email.com',
        phone: '+216 55 123 456',
        region: 'Bizerte',
        role: 'farmer',
        bio: 'Vegetable farmer focusing on seasonal crops and direct market sales.',
        skills: ['Vegetable Farming', 'Market Sales', 'Crop Planning'],
        rating: 4.7,
        reviewCount: 29,
      ),
    ];
  }

  List<User> getFarmersByRegion(String region) {
    return _allUsers.where((user) => 
        user.role == 'farmer' && 
        user.region.toLowerCase().contains(region.toLowerCase())
    ).toList();
  }

  List<User> searchUsers(String query) {
    return _allUsers.where((user) =>
        user.fullName.toLowerCase().contains(query.toLowerCase()) ||
        user.region.toLowerCase().contains(query.toLowerCase()) ||
        user.skills.any((skill) => skill.toLowerCase().contains(query.toLowerCase()))
    ).toList();
  }
}
