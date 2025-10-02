class DemoData {
  static const List<Map<String, dynamic>> farmers = [
    {
      'id': '1',
      'name': 'Amina Ben Salem',
      'location': 'Sfax',
      'bio': 'Experienced tomato farmer with 10 years in sustainable agriculture.',
      'rating': 4.8,
      'reviewCount': 42,
      'crops': ['Tomatoes', 'Peppers', 'Herbs'],
      'avatar': null,
    },
    {
      'id': '2', 
      'name': 'Fatma Khelifi',
      'location': 'Kairouan',
      'bio': 'Olive oil producer specializing in premium quality products.',
      'rating': 4.9,
      'reviewCount': 38,
      'crops': ['Olives', 'Almonds', 'Figs'],
      'avatar': null,
    },
    {
      'id': '3',
      'name': 'Leila Mansouri', 
      'location': 'Bizerte',
      'bio': 'Organic vegetable farmer focused on local market supply.',
      'rating': 4.7,
      'reviewCount': 29,
      'crops': ['Lettuce', 'Carrots', 'Spinach'],
      'avatar': null,
    },
  ];

  static const List<Map<String, dynamic>> products = [
    {
      'id': '1',
      'name': 'Fresh Tomatoes',
      'farmer': 'Amina Ben Salem',
      'location': 'Sfax',
      'price': 2.5,
      'unit': 'kg',
      'category': 'vegetables',
      'inStock': true,
      'description': 'Fresh, organic tomatoes grown using sustainable methods.',
    },
    {
      'id': '2',
      'name': 'Premium Olive Oil',
      'farmer': 'Fatma Khelifi',
      'location': 'Kairouan', 
      'price': 12.0,
      'unit': 'liter',
      'category': 'oils',
      'inStock': true,
      'description': 'Extra virgin olive oil from century-old olive trees.',
    },
    {
      'id': '3',
      'name': 'Organic Lettuce',
      'farmer': 'Leila Mansouri',
      'location': 'Bizerte',
      'price': 1.8,
      'unit': 'kg',
      'category': 'vegetables', 
      'inStock': true,
      'description': 'Fresh organic lettuce, perfect for salads.',
    },
  ];

  static const List<Map<String, dynamic>> opportunities = [
    {
      'id': '1',
      'title': 'Seasonal Tomato Harvest',
      'description': 'Looking for workers to help with tomato harvest season.',
      'type': 'Seasonal Work',
      'location': 'Sfax',
      'payment': '25 TND/day',
      'duration': '2 weeks',
      'postedBy': 'Ahmed Farm',
      'posted': '2 days ago',
    },
    {
      'id': '2',
      'title': 'Sustainable Farming Workshop',
      'description': 'Free training on modern sustainable farming techniques.',
      'type': 'Training',
      'location': 'Tunis',
      'payment': 'Free',
      'duration': '3 days',
      'postedBy': 'Women in Agriculture NGO',
      'posted': '1 week ago',
    },
  ];

  static const List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'title': 'Weather Alert',
      'message': 'Heavy rain expected tomorrow. Protect your crops.',
      'type': 'weather',
      'timestamp': '2 hours ago',
      'read': false,
    },
    {
      'id': '2',
      'title': 'Job Match',
      'message': 'New opportunity matches your profile in Sfax.',
      'type': 'job',
      'timestamp': '1 day ago', 
      'read': false,
    },
    {
      'id': '3',
      'title': 'Price Update',
      'message': 'Tomato prices increased by 15% in your region.',
      'type': 'market',
      'timestamp': '3 days ago',
      'read': true,
    },
  ];

  static const Map<String, dynamic> iotData = {
    'soilMoisture': 68,
    'temperature': 24,
    'humidity': 72,
    'lightLevel': 85,
    'phLevel': 6.8,
    'waterUsage': 120,
    'lastUpdated': '5 minutes ago',
  };
}
