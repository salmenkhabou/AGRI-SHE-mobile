import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_app_bar.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String _selectedCategory = 'All';
  String _selectedLocation = 'All Regions';
  String _priceRange = 'All Prices';
  String _searchQuery = '';
  
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Vegetables',
    'Fruits',
    'Grains',
    'Herbs',
    'Tools',
    'Seeds',
  ];

  final List<String> _locations = [
    'All Regions',
    'Tunis',
    'Sfax',
    'Sousse',
    'Kairouan',
    'Bizerte',
  ];

  final List<String> _priceRanges = [
    'All Prices',
    'Under 5 TND',
    '5-20 TND',
    '20-50 TND',
    'Over 50 TND',
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
                // Search and Filters
                _buildSearchAndFilters(),
                
                // Product Grid
                Expanded(
                  child: _buildProductGrid(),
                ),
              ],
            ),
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
              hintText: 'Search products...',
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
          
          // Filters Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  'Category',
                  _selectedCategory,
                  _categories,
                  (value) => setState(() => _selectedCategory = value),
                ),
                const SizedBox(width: 12),
                _buildFilterChip(
                  'Location',
                  _selectedLocation,
                  _locations,
                  (value) => setState(() => _selectedLocation = value),
                ),
                const SizedBox(width: 12),
                _buildFilterChip(
                  'Price',
                  _priceRange,
                  _priceRanges,
                  (value) => setState(() => _priceRange = value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, List<String> options, Function(String) onChanged) {
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.borderColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: $value',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      ),
      itemBuilder: (context) => options.map((option) {
        return PopupMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onSelected: onChanged,
    );
  }

  Widget _buildProductGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: _mockProducts.length,
        itemBuilder: (context, index) {
          return _buildProductCard(_mockProducts[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.lightGreen,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Icon(
                _getCategoryIcon(product['category']),
                size: 48,
                color: AppTheme.primaryGreen,
              ),
            ),
          ),
          
          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 14,
                        color: AppTheme.textLight,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          product['farmer'],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppTheme.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product['location'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${product['price']} TND/kg',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            product['rating'].toString(),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'vegetables':
        return Icons.eco;
      case 'fruits':
        return Icons.apple;
      case 'grains':
        return Icons.grain;
      case 'herbs':
        return Icons.local_florist;
      case 'tools':
        return Icons.build;
      case 'seeds':
        return Icons.scatter_plot;
      default:
        return Icons.shopping_basket;
    }
  }

  final List<Map<String, dynamic>> _mockProducts = [
    {
      'name': 'Fresh Tomatoes',
      'farmer': 'Amina Ben Salem',
      'location': 'Sfax',
      'price': 2.5,
      'rating': 4.8,
      'category': 'vegetables',
    },
    {
      'name': 'Organic Olives',
      'farmer': 'Fatma Khelifi',
      'location': 'Kairouan',
      'price': 12.0,
      'rating': 4.9,
      'category': 'fruits',
    },
    {
      'name': 'Fresh Lettuce',
      'farmer': 'Leila Mansouri',
      'location': 'Bizerte',
      'price': 1.8,
      'rating': 4.7,
      'category': 'vegetables',
    },
    {
      'name': 'Wheat Grain',
      'farmer': 'Salma Touati',
      'location': 'Sousse',
      'price': 0.9,
      'rating': 4.6,
      'category': 'grains',
    },
    {
      'name': 'Premium Dates',
      'farmer': 'Nadia Hamdi',
      'location': 'Tozeur',
      'price': 25.0,
      'rating': 4.9,
      'category': 'fruits',
    },
    {
      'name': 'Mint Leaves',
      'farmer': 'Rim Bouaziz',
      'location': 'Tunis',
      'price': 3.5,
      'rating': 4.5,
      'category': 'herbs',
    },
    {
      'name': 'Organic Carrots',
      'farmer': 'Imen Gharbi',
      'location': 'Nabeul',
      'price': 2.2,
      'rating': 4.7,
      'category': 'vegetables',
    },
    {
      'name': 'Irrigation Tools',
      'farmer': 'Maryam Ben Ali',
      'location': 'Sfax',
      'price': 45.0,
      'rating': 4.4,
      'category': 'tools',
    },
  ];
}
