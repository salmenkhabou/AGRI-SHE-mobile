import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _bioController;
  late TextEditingController _phoneController;
  late TextEditingController _regionController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    
    // Initialize mock user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.initializeMockData();
      
      if (userProvider.currentUser == null) {
        // Set a default user
        userProvider.setCurrentUser(userProvider.allUsers.first);
      }
    });
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _bioController = TextEditingController();
    _phoneController = TextEditingController();
    _regionController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(),
          Expanded(
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                final user = userProvider.currentUser;
                
                if (user == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Update controllers when user data changes
                _updateControllers(user);

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProfileHeader(user),
                      _buildProfileContent(user, userProvider),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateControllers(User user) {
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _bioController.text = user.bio ?? '';
    _phoneController.text = user.phone;
    _regionController.text = user.region;
  }

  Widget _buildProfileHeader(User user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryGreen,
            AppTheme.primaryGreen.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: AppTheme.lightGreen,
                  child: user.profileImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(56),
                          child: Image.network(
                            user.profileImage!,
                            width: 112,
                            height: 112,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 60,
                          color: AppTheme.primaryGreen,
                        ),
                ),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: _changeProfilePicture,
                      icon: Icon(
                        Icons.camera_alt,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Name and Role
          Text(
            user.fullName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              user.role.toUpperCase(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Rating', user.rating.toString(), Icons.star),
              _buildStatItem('Reviews', user.reviewCount.toString(), Icons.rate_review),
              _buildStatItem('Skills', user.skills.length.toString(), Icons.emoji_objects),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileContent(User user, UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Edit Button
          Row(
            children: [
              Text(
                'Profile Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (_isEditing)
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                        });
                        _updateControllers(user);
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _saveProfile(userProvider),
                      child: const Text('Save'),
                    ),
                  ],
                )
              else
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Profile Form
          Form(
            key: _formKey,
            child: Column(
              children: [
                // Personal Information Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildFormField(
                                'First Name',
                                _firstNameController,
                                Icons.person_outline,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildFormField(
                                'Last Name',
                                _lastNameController,
                                Icons.person_outline,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          'Phone Number',
                          _phoneController,
                          Icons.phone_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          'Region',
                          _regionController,
                          Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          'Bio',
                          _bioController,
                          Icons.description_outlined,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Skills Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Skills & Expertise',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            if (_isEditing)
                              TextButton.icon(
                                onPressed: _addSkill,
                                icon: const Icon(Icons.add),
                                label: const Text('Add Skill'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: user.skills.map((skill) {
                            return Chip(
                              label: Text(skill),
                              backgroundColor: AppTheme.lightGreen,
                              deleteIcon: _isEditing ? const Icon(Icons.close, size: 18) : null,
                              onDeleted: _isEditing ? () => _removeSkill(skill, userProvider) : null,
                            );
                          }).toList(),
                        ),
                        if (user.skills.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.emoji_objects_outlined,
                                  color: AppTheme.textLight,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'No skills added yet. Add your expertise to help others find you.',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Contact Information Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Information',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: Icon(Icons.email_outlined, color: AppTheme.primaryGreen),
                          title: const Text('Email'),
                          subtitle: Text(user.email),
                          contentPadding: EdgeInsets.zero,
                        ),
                        ListTile(
                          leading: Icon(Icons.phone_outlined, color: AppTheme.primaryGreen),
                          title: const Text('Phone'),
                          subtitle: Text(user.phone),
                          contentPadding: EdgeInsets.zero,
                        ),
                        ListTile(
                          leading: Icon(Icons.location_on_outlined, color: AppTheme.primaryGreen),
                          title: const Text('Region'),
                          subtitle: Text(user.region),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      enabled: _isEditing,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: _isEditing ? null : InputBorder.none,
        filled: !_isEditing,
        fillColor: !_isEditing ? Colors.transparent : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  void _saveProfile(UserProvider userProvider) {
    if (_formKey.currentState!.validate()) {
      userProvider.updateCurrentUser({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'bio': _bioController.text,
        'phone': _phoneController.text,
        'region': _regionController.text,
      });

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );
    }
  }

  void _changeProfilePicture() {
    // In a real app, this would open image picker
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Profile Picture'),
        content: const Text('Image picker functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addSkill() {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Skill'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter skill name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                final currentSkills = List<String>.from(userProvider.currentUser?.skills ?? []);
                if (!currentSkills.contains(controller.text)) {
                  currentSkills.add(controller.text);
                  userProvider.updateCurrentUser({'skills': currentSkills});
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removeSkill(String skill, UserProvider userProvider) {
    final currentSkills = List<String>.from(userProvider.currentUser?.skills ?? []);
    currentSkills.remove(skill);
    userProvider.updateCurrentUser({'skills': currentSkills});
  }
}
