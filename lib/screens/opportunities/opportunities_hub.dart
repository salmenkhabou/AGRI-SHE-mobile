import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_app_bar.dart';

class OpportunitiesHub extends StatefulWidget {
  const OpportunitiesHub({super.key});

  @override
  State<OpportunitiesHub> createState() => _OpportunitiesHubState();
}

class _OpportunitiesHubState extends State<OpportunitiesHub> {
  String _selectedFilter = 'All';
  String _selectedLocation = 'All Regions';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _filters = [
    'All',
    'Seasonal Work',
    'Training Programs',
    'Partnerships',
    'Financial Support',
  ];

  final List<String> _locations = [
    'All Regions',
    'Tunis',
    'Sfax',
    'Sousse',
    'Kairouan',
    'Bizerte',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                _buildSearchAndFilters(),
                Expanded(
                  child: _buildOpportunitiesList(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPostOpportunityDialog(),
        backgroundColor: AppTheme.primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Post Opportunity', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Text(
            'Opportunities Hub',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover jobs, training programs, and partnership opportunities\nin the agricultural sector.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search opportunities...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Filters
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  'Type',
                  _selectedFilter,
                  _filters,
                  (value) => setState(() => _selectedFilter = value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  'Location',
                  _selectedLocation,
                  _locations,
                  (value) => setState(() => _selectedLocation = value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> options, Function(String) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (newValue) => onChanged(newValue!),
    );
  }

  Widget _buildOpportunitiesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mockOpportunities.length,
      itemBuilder: (context, index) {
        return _buildOpportunityCard(_mockOpportunities[index]);
      },
    );
  }

  Widget _buildOpportunityCard(Map<String, dynamic> opportunity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with type badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTypeColor(opportunity['type']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    opportunity['type'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getTypeColor(opportunity['type']),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  opportunity['posted'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Title
            Text(
              opportunity['title'],
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Description
            Text(
              opportunity['description'],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Details Row
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppTheme.textLight,
                ),
                const SizedBox(width: 4),
                Text(
                  opportunity['location'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textLight,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: AppTheme.textLight,
                ),
                const SizedBox(width: 4),
                Text(
                  opportunity['duration'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textLight,
                  ),
                ),
                const Spacer(),
                if (opportunity['payment'] != 'Free')
                  Text(
                    opportunity['payment'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Posted by
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.lightGreen,
                  child: Icon(
                    _getOrgIcon(opportunity['orgType']),
                    size: 16,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Posted by ${opportunity['postedBy']}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showOpportunityDetails(opportunity),
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Learn More'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _applyToOpportunity(opportunity),
                    icon: const Icon(Icons.send),
                    label: Text(opportunity['type'] == 'Training Programs' ? 'Enroll' : 'Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Seasonal Work':
        return Colors.blue;
      case 'Training Programs':
        return Colors.green;
      case 'Partnerships':
        return Colors.purple;
      case 'Financial Support':
        return Colors.orange;
      default:
        return AppTheme.primaryGreen;
    }
  }

  IconData _getOrgIcon(String orgType) {
    switch (orgType) {
      case 'farm':
        return Icons.eco;
      case 'ngo':
        return Icons.favorite;
      case 'government':
        return Icons.account_balance;
      case 'cooperative':
        return Icons.group;
      default:
        return Icons.business;
    }
  }

  void _showOpportunityDetails(Map<String, dynamic> opportunity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(opportunity['title']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(opportunity['description']),
              const SizedBox(height: 16),
              Text(
                'Requirements:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('• Basic farming knowledge\n• Physical fitness for outdoor work\n• Ability to work in teams'),
              const SizedBox(height: 12),
              Text(
                'Benefits:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('• Competitive daily wage\n• Transportation provided\n• Free meals during work hours'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyToOpportunity(opportunity);
            },
            child: const Text('Apply Now'),
          ),
        ],
      ),
    );
  }

  void _applyToOpportunity(Map<String, dynamic> opportunity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Application Sent'),
        content: Text(
          'Your application for "${opportunity['title']}" has been sent successfully. The employer will contact you if your profile matches their requirements.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPostOpportunityDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedType = 'Seasonal Work';
    String selectedLocation = 'Tunis';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Post New Opportunity'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter opportunity title',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe the opportunity',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: _filters.where((f) => f != 'All').map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => selectedType = value!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedLocation,
                decoration: const InputDecoration(labelText: 'Location'),
                items: _locations.where((l) => l != 'All Regions').map((location) {
                  return DropdownMenuItem(value: location, child: Text(location));
                }).toList(),
                onChanged: (value) => selectedLocation = value!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opportunity posted successfully!'),
                    backgroundColor: AppTheme.primaryGreen,
                  ),
                );
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> _mockOpportunities = [
    {
      'title': 'Seasonal Tomato Picking',
      'description': 'We are looking for experienced workers to help with our tomato harvest season. Work includes picking, sorting, and packing fresh tomatoes.',
      'type': 'Seasonal Work',
      'location': 'Sfax',
      'duration': '2 weeks',
      'payment': '25 TND/day',
      'postedBy': 'Ahmed Farm Cooperative',
      'orgType': 'cooperative',
      'posted': '2 days ago',
    },
    {
      'title': 'Olive Harvest Help Needed',
      'description': 'Join our team for the olive harvest season. We provide all equipment and training for new workers. Great opportunity to learn traditional harvesting methods.',
      'type': 'Seasonal Work',
      'location': 'Kairouan',
      'duration': '3 weeks',
      'payment': '30 TND/day',
      'postedBy': 'Fatma Olive Enterprises',
      'orgType': 'farm',
      'posted': '1 week ago',
    },
    {
      'title': 'Modern Farming Techniques Workshop',
      'description': 'Free training program on sustainable farming practices, water management, and organic pest control. Includes hands-on sessions and certification.',
      'type': 'Training Programs',
      'location': 'Tunis',
      'duration': '5 days',
      'payment': 'Free',
      'postedBy': 'Women in Agriculture NGO',
      'orgType': 'ngo',
      'posted': '3 days ago',
    },
    {
      'title': 'Agricultural Microcredit Program',
      'description': 'Low-interest loans available for women farmers looking to expand their operations, purchase equipment, or invest in new crops.',
      'type': 'Financial Support',
      'location': 'All Regions',
      'duration': 'Ongoing',
      'payment': '2.5% interest',
      'postedBy': 'Agricultural Development Bank',
      'orgType': 'government',
      'posted': '5 days ago',
    },
    {
      'title': 'Cooperative Partnership Opportunity',
      'description': 'Join our agricultural cooperative to benefit from shared resources, bulk purchasing power, and collective marketing of products.',
      'type': 'Partnerships',
      'location': 'Bizerte',
      'duration': 'Long-term',
      'payment': 'Profit sharing',
      'postedBy': 'North Tunisia Farmers Cooperative',
      'orgType': 'cooperative',
      'posted': '1 week ago',
    },
    {
      'title': 'Digital Marketing for Farmers',
      'description': 'Learn how to market your agricultural products online, use social media for business, and connect directly with customers.',
      'type': 'Training Programs',
      'location': 'Sousse',
      'duration': '3 days',
      'payment': 'Free',
      'postedBy': 'Rural Digital Initiative',
      'orgType': 'ngo',
      'posted': '4 days ago',
    },
  ];
}
