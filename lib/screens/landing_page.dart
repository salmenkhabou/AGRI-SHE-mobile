import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../widgets/custom_app_bar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Custom App Bar
            const CustomAppBar(),
            
            // Hero Section
            _buildHeroSection(),
            
            // Success Stories Section
            _buildSuccessStoriesSection(),
            
            // Features Section
            _buildFeaturesSection(),
            
            // Call to Action Section
            _buildCallToActionSection(),
            
            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // Logo and Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.eco,
                color: AppTheme.primaryGreen,
                size: 32,
              ),
              const SizedBox(width: 8),
              Text(
                'Agri-SHE',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Empowering Women in Agriculture',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.accentGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Main Heading
          Text(
            'From Soil to Market,',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Empowering ',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                TextSpan(
                  text: 'Women Farmers',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Subtitle
          Text(
            'Join Agri-SHE, the comprehensive platform designed specifically for women in agriculture.\nAccess IoT irrigation, connect with buyers, find opportunities, and grow your farming business.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textLight,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text('Join as Farmer'),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/marketplace'),
                child: const Text('Browse Marketplace'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStoriesSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Text(
            'Success Stories from Women Farmers',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Real impact from women transforming\nagriculture across Tunisia and beyond.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _testimonials.length,
              itemBuilder: (context, index) {
                return _buildTestimonialCard(_testimonials[index]);
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_testimonials.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index 
                      ? AppTheme.primaryGreen 
                      : AppTheme.borderColor,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(Map<String, String> testimonial) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Star Rating
            Row(
              children: List.generate(5, (index) => Icon(
                Icons.star,
                color: Colors.amber,
                size: 16,
              )),
            ),
            const SizedBox(height: 12),
            
            // Testimonial Text
            Expanded(
              child: Text(
                testimonial['text']!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Author Info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primaryGreen,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial['name']!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      testimonial['title']!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Everything You Need to Succeed',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'From smart farming tools to market connections, Agri-\nSHE provides comprehensive support for women farmers.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Features Grid
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: _features.map((feature) => _buildFeatureCard(feature)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                feature['icon'],
                color: AppTheme.primaryGreen,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              feature['title'],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                feature['description'],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textLight,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallToActionSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Text(
            'Ready to Transform Your Farming Journey?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Join thousands of women farmers already using Agri-\nSHE to grow smarter, connect deeper, and harvest success.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text('Start Your Journey'),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/marketplace'),
                child: const Text('Explore Marketplace'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppTheme.accentGreen,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.eco,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Agri-SHE',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Empowering women farmers through technology,\ncommunity, and sustainable agricultural practices.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFooterColumn('Platform', [
                'Farmer Dashboard',
                'Marketplace',
                'Job Board',
                'IoT Monitoring',
              ]),
              _buildFooterColumn('Support', [
                'Help Center',
                'Training Modules',
                'Contact Support',
              ]),
              _buildFooterColumn('Partners', [
                'Ministry of Agriculture',
                'UN Women Tunisia',
                'Agricultural Development Bank',
              ]),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white30),
          const SizedBox(height: 16),
          Text(
            '© 2025 Agri-SHE. From Soil to Market, Empowering Women Farmers.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            item,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
        )),
      ],
    );
  }

  final List<Map<String, String>> _testimonials = [
    {
      'text': 'Agri-SHE\'s IoT system helped me reduce water usage by 40% while increasing my tomato yield. The marketplace connected me directly with buyers in Tunis.',
      'name': 'Amina Ben Salem',
      'title': 'Tomato Farmer, Sfax',
    },
    {
      'text': 'The job board helped me find seasonal workers during harvest time. The training modules taught me modern farming techniques that doubled my income.',
      'name': 'Fatma Khelifi',
      'title': 'Olive Farmer, Kairouan',
    },
    {
      'text': 'The chatbot assistant sends me weather alerts and irrigation reminders. It\'s like having an agricultural expert available 24/7 on my phone.',
      'name': 'Leila Mansouri',
      'title': 'Vegetable Farmer, Bizerte',
    },
  ];

  final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.sensors,
      'title': 'IoT Irrigation',
      'description': 'Monitor soil moisture, weather conditions, and automate irrigation with smart IoT sensors and real-time data visualization.',
    },
    {
      'icon': Icons.shopping_cart,
      'title': 'Direct Marketplace',
      'description': 'Connect directly with buyers, showcase your products, and access fair pricing in our integrated marketplace platform.',
    },
    {
      'icon': Icons.chat,
      'title': 'AI Chatbot Assistant',
      'description': 'Get instant farming advice, weather alerts, and personalized recommendations from our intelligent chatbot assistant.',
    },
    {
      'icon': Icons.work,
      'title': 'Job Opportunities',
      'description': 'Discover seasonal work, training programs, and partnership opportunities through our job board and matching system.',
    },
    {
      'icon': Icons.phone_android,
      'title': 'Mobile-First Design',
      'description': 'Access all features from your smartphone with our lightweight, rural-friendly mobile interface designed for accessibility.',
    },
    {
      'icon': Icons.school,
      'title': 'Micro-Learning',
      'description': 'Access short training videos, articles, and best practices to continuously improve your farming techniques and business skills.',
    },
  ];
}
