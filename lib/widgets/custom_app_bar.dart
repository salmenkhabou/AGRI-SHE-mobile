import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_theme.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
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
          child: Row(
            children: [
              // Logo
              Row(
                children: [
                  Icon(
                    Icons.eco,
                    color: AppTheme.primaryGreen,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Agri-SHE',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Navigation Items
              if (!authProvider.isLoggedIn) ...[
                _buildNavItem(context, 'Features', () {}),
                const SizedBox(width: 16),
                _buildNavItem(context, 'Marketplace', () {
                  Navigator.pushNamed(context, '/marketplace');
                }),
                const SizedBox(width: 16),
                _buildNavItem(context, 'Jobs', () {
                  Navigator.pushNamed(context, '/opportunities');
                }),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: AppTheme.primaryGreen),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Get Started'),
                ),
              ] else ...[
                // Logged in navigation
                _buildNavItem(context, 'Dashboard', () {
                  Navigator.pushNamed(context, '/dashboard');
                }),
                const SizedBox(width: 16),
                _buildNavItem(context, 'Marketplace', () {
                  Navigator.pushNamed(context, '/marketplace');
                }),
                const SizedBox(width: 16),
                _buildNavItem(context, 'Opportunities', () {
                  Navigator.pushNamed(context, '/opportunities');
                }),
                const SizedBox(width: 16),
                PopupMenuButton<String>(
                  icon: CircleAvatar(
                    backgroundColor: AppTheme.primaryGreen,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  onSelected: (value) {
                    if (value == 'profile') {
                      Navigator.pushNamed(context, '/profile');
                    } else if (value == 'logout') {
                      authProvider.logout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/',
                        (route) => false,
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 8),
                          Text('Profile'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppTheme.textDark,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
