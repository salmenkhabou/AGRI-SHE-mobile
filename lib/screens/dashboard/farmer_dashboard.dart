import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../models/task.dart';
// import '../../screens/tasks/add_task_dialog.dart';
import '../../utils/app_theme.dart';
import '../../widgets/chatbot_widget.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.dashboard, 'label': 'Overview', 'page': 'overview'},
    {'icon': Icons.sensors, 'label': 'IoT Data', 'page': 'iot'},
    {'icon': Icons.task, 'label': 'Tasks', 'page': 'tasks'},
    {'icon': Icons.school, 'label': 'Learning', 'page': 'learning'},
    {'icon': Icons.notifications, 'label': 'Notifications', 'page': 'notifications'},
    {'icon': Icons.work, 'label': 'Opportunities', 'page': 'opportunities'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          _buildSidebar(),
          
          // Main Content
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    children: [
                      _buildOverviewPage(),
                      _buildIoTDataPage(),
                      _buildTasksPage(),
                      _buildLearningPage(),
                      _buildNotificationsPage(),
                      _buildOpportunitiesPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // Floating Chatbot Button
      floatingActionButton: const ChatbotWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 240,
      color: Colors.white,
      child: Column(
        children: [
          // Logo Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
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
          ),
          
          const Divider(),
          
          // Menu Items
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = _selectedIndex == index;
                
                return ListTile(
                  leading: Icon(
                    item['icon'],
                    color: isSelected ? AppTheme.primaryGreen : AppTheme.textLight,
                  ),
                  title: Text(
                    item['label'],
                    style: TextStyle(
                      color: isSelected ? AppTheme.primaryGreen : AppTheme.textDark,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: AppTheme.lightGreen,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
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
      child: Row(
        children: [
          Text(
            _menuItems[_selectedIndex]['label'],
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const Spacer(),
          
          // User Profile
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return PopupMenuButton<String>(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppTheme.primaryGreen,
                      child: Text(
                        authProvider.userId?.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      authProvider.userId ?? 'User',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
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
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Message
          Text(
            'Welcome back! Here\'s your farm overview.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textLight,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Stats Cards
          Row(
            children: [
              Expanded(child: _buildStatCard('Active Crops', '5', Icons.eco, Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Water Saved', '40%', Icons.water_drop, Colors.blue)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Revenue', '2,450 TND', Icons.attach_money, Colors.orange)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Tasks', '3 Pending', Icons.task, Colors.purple)),
            ],
          ),
          
          const SizedBox(height: 32),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recent Activity
              Expanded(
                flex: 2,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Activity',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildActivityItem('Tomato field watered automatically', '2 hours ago', Icons.water_drop),
                        _buildActivityItem('Pest control task completed', '1 day ago', Icons.bug_report),
                        _buildActivityItem('Weather alert: Rain expected tomorrow', '2 days ago', Icons.cloud),
                        _buildActivityItem('New buyer inquiry received', '3 days ago', Icons.message),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Quick Actions
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Actions',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildQuickActionButton('View IoT Data', Icons.sensors, () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                          _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                        }),
                        _buildQuickActionButton('Add Task', Icons.add_task, () {}),
                        _buildQuickActionButton('Check Weather', Icons.wb_sunny, () {}),
                        _buildQuickActionButton('Browse Market', Icons.shopping_cart, () {
                          Navigator.pushNamed(context, '/marketplace');
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryGreen),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildIoTDataPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Real-time data from your farm sensors',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textLight,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Sensor Cards
          GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildSensorCard('Soil Moisture', '68%', Icons.water_drop, Colors.blue, 'Optimal'),
              _buildSensorCard('Temperature', '24°C', Icons.thermostat, Colors.orange, 'Good'),
              _buildSensorCard('Humidity', '72%', Icons.opacity, Colors.teal, 'High'),
              _buildSensorCard('Light Level', '85%', Icons.wb_sunny, Colors.yellow, 'Excellent'),
              _buildSensorCard('pH Level', '6.8', Icons.science, Colors.purple, 'Ideal'),
              _buildSensorCard('Water Usage', '120L', Icons.water, Colors.cyan, 'Efficient'),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Chart Placeholder
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Trends',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.lightGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('Chart visualization will be implemented here'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorCard(String title, String value, IconData icon, Color color, String status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTasksPage() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Manage your farming tasks and schedule',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textLight,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _showAddTaskDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Task'),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Task Statistics
              _buildTaskStatistics(taskProvider),
              
              const SizedBox(height: 24),
              
              // Task List
              if (taskProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (taskProvider.tasks.isEmpty)
                _buildEmptyTaskState()
              else
                ..._buildTaskList(taskProvider.tasks),
            ],
          ),
        );
      },
    );
  }  // Show Add Task Dialog
  void _showAddTaskDialog([Task? editTask]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(editTask != null ? 'Edit Task' : 'Add New Task'),
        content: const Text('Task management dialog will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Build Task Statistics Row
  Widget _buildTaskStatistics(TaskProvider taskProvider) {
    return Row(
      children: [
        Expanded(
          child: _buildTaskStatCard(
            'Pending',
            taskProvider.pendingTasks.length.toString(),
            Icons.pending_actions,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTaskStatCard(
            'In Progress',
            taskProvider.inProgressTasks.length.toString(),
            Icons.play_arrow,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTaskStatCard(
            'Completed',
            taskProvider.completedTasks.length.toString(),
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTaskStatCard(
            'Overdue',
            taskProvider.overdueTasks.length.toString(),
            Icons.warning,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskStatCard(String title, String count, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              count,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Build Empty Task State
  Widget _buildEmptyTaskState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first farming task to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddTaskDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Task'),
          ),
        ],
      ),
    );
  }

  // Build Task List
  List<Widget> _buildTaskList(List<Task> tasks) {
    return tasks.map((task) => _buildNewTaskCard(task)).toList();
  }

  Widget _buildNewTaskCard(Task task) {
    final color = _getTaskColor(task);
    final isOverdue = task.isOverdue;
    final isDueToday = task.isDueToday;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(_getCategoryIcon(task.category), color: color),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.status == TaskStatus.completed 
                ? TextDecoration.lineThrough 
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty)
              Text(
                task.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            Text(_formatDueDate(task.dueDate)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOverdue)
              const Chip(
                label: Text('Overdue'),
                backgroundColor: Colors.red,
                labelStyle: TextStyle(color: Colors.white, fontSize: 10),
              )
            else if (isDueToday)
              const Chip(
                label: Text('Due Today'),
                backgroundColor: Colors.orange,
                labelStyle: TextStyle(color: Colors.white, fontSize: 10),
              )
            else
              Chip(
                label: Text(task.priority.displayName),
                backgroundColor: color.withOpacity(0.1),
                labelStyle: TextStyle(color: color, fontSize: 10),
              ),
            PopupMenuButton<String>(
              onSelected: (value) => _handleTaskAction(task, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                if (task.status != TaskStatus.completed)
                  PopupMenuItem(
                    value: task.status == TaskStatus.pending ? 'start' : 'complete',
                    child: Row(
                      children: [
                        Icon(
                          task.status == TaskStatus.pending 
                              ? Icons.play_arrow 
                              : Icons.check,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(task.status == TaskStatus.pending ? 'Start' : 'Complete'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _showAddTaskDialog(task),
      ),
    );
  }

  Color _getTaskColor(Task task) {
    switch (task.priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.blue;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.urgent:
        return Colors.red;
    }
  }

  IconData _getCategoryIcon(TaskCategory category) {
    switch (category) {
      case TaskCategory.watering:
        return Icons.water_drop;
      case TaskCategory.fertilizing:
        return Icons.eco;
      case TaskCategory.planting:
        return Icons.local_florist;
      case TaskCategory.harvesting:
        return Icons.agriculture;
      case TaskCategory.pestControl:
        return Icons.bug_report;
      case TaskCategory.maintenance:
        return Icons.build;
      case TaskCategory.planning:
        return Icons.event_note;
      case TaskCategory.other:
        return Icons.task;
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    
    if (difference.isNegative) {
      final daysPast = now.difference(dueDate).inDays;
      if (daysPast == 0) return 'Overdue today';
      return 'Overdue by $daysPast day${daysPast > 1 ? 's' : ''}';
    }
    
    final days = difference.inDays;
    if (days == 0) {
      final hours = difference.inHours;
      if (hours <= 0) return 'Due now';
      return 'Due in $hours hour${hours > 1 ? 's' : ''}';
    } else if (days == 1) {
      return 'Due tomorrow';
    } else {
      return 'Due in $days days';
    }
  }

  void _handleTaskAction(Task task, String action) async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    switch (action) {
      case 'edit':
        _showAddTaskDialog(task);
        break;
      case 'start':
        await taskProvider.markInProgress(task.id);
        break;
      case 'complete':
        await taskProvider.completeTask(task.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Task completed successfully!'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
        }
        break;
      case 'delete':
        _showDeleteConfirmation(task);
        break;
    }
  }

  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final taskProvider = Provider.of<TaskProvider>(context, listen: false);
              await taskProvider.deleteTask(task.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Task deleted successfully!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(String title, String dueDate, bool isUrgent, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(Icons.task, color: color),
        ),
        title: Text(title),
        subtitle: Text(dueDate),
        trailing: isUrgent 
            ? Chip(
                label: const Text('Urgent'),
                backgroundColor: Colors.red.withOpacity(0.1),
                labelStyle: const TextStyle(color: Colors.red, fontSize: 12),
              )
            : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }

  Widget _buildLearningPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enhance your farming knowledge with our micro-learning modules',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textLight,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Learning Cards
          _buildLearningCard(
            'Water Management Techniques',
            'Learn efficient irrigation methods',
            '15 min',
            Colors.blue,
            Icons.water_drop,
          ),
          _buildLearningCard(
            'Organic Pest Control',
            'Natural ways to protect your crops',
            '12 min',
            Colors.green,
            Icons.bug_report,
          ),
          _buildLearningCard(
            'Soil Health Optimization',
            'Improve soil quality for better yields',
            '20 min',
            Colors.brown,
            Icons.eco,
          ),
          _buildLearningCard(
            'Market Price Analysis',
            'Understanding market trends and pricing',
            '10 min',
            Colors.orange,
            Icons.trending_up,
          ),
        ],
      ),
    );
  }

  Widget _buildLearningCard(String title, String description, String duration, Color color, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              duration,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textLight,
              ),
            ),
            const Icon(Icons.play_arrow, color: AppTheme.primaryGreen),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildNotificationsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stay updated with important alerts and notifications',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textLight,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Notifications
          _buildNotificationCard(
            'Weather Alert',
            'Heavy rain expected tomorrow. Consider covering sensitive crops.',
            '2 hours ago',
            Icons.cloud,
            Colors.blue,
            isUnread: true,
          ),
          _buildNotificationCard(
            'Job Match Found',
            'You are a good match for Olive Harvest in Sfax. Tap to apply.',
            '1 day ago',
            Icons.work,
            Colors.green,
            isUnread: true,
          ),
          _buildNotificationCard(
            'System Update',
            'Your IoT sensors have been updated with the latest firmware.',
            '2 days ago',
            Icons.update,
            Colors.orange,
            isUnread: false,
          ),
          _buildNotificationCard(
            'Market Price Update',
            'Tomato prices have increased by 15% in your region.',
            '3 days ago',
            Icons.trending_up,
            Colors.purple,
            isUnread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(String title, String message, String time, IconData icon, Color color, {bool isUnread = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Row(
          children: [
            Expanded(child: Text(title)),
            if (isUnread)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 4),
            Text(
              time,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textLight,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {},
      ),
    );
  }

  Widget _buildOpportunitiesPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover job opportunities and partnerships',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textLight,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Opportunity Cards
          _buildOpportunityCard(
            'Seasonal Tomato Picking',
            'Farm in Sfax needs temporary workers for harvest season',
            'Sfax',
            '25 TND/day',
            'Posted by Ahmed Farm',
          ),
          _buildOpportunityCard(
            'Olive Harvest Help',
            'Looking for experienced workers for olive harvest',
            'Kairouan',
            '30 TND/day',
            'Posted by Fatma Olive Co.',
          ),
          _buildOpportunityCard(
            'NGO Training Program',
            'Free training on modern farming techniques',
            'Tunis',
            'Free',
            'Posted by Women in Agriculture NGO',
          ),
        ],
      ),
    );
  }

  Widget _buildOpportunityCard(String title, String description, String location, String payment, String postedBy) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: AppTheme.textLight),
                const SizedBox(width: 4),
                Text(location, style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
                Text(
                  payment,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              postedBy,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Learn More'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
