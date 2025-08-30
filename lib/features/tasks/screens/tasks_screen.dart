import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../services/supabase_service.dart';
import '../../../models/task.dart';
import '../../../models/planting.dart';
import '../../../models/crop.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<TaskWithDetails> _allTasks = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.profile?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Load tasks with plantings and crops
      final tasksResponse = await SupabaseService.client
          .from('tasks')
          .select('''
            *,
            plantings(
              *,
              crops_catalog(*),
              beds(*)
            )
          ''')
          .eq('plantings.beds.plots.farms.owner_id', userId)
          .order('due_date');

      final tasks = (tasksResponse as List).map((taskJson) {
        final task = Task.fromJson(taskJson);
        Planting? planting;
        Crop? crop;
        
        if (taskJson['plantings'] != null) {
          final plantingJson = taskJson['plantings'];
          planting = Planting.fromJson(plantingJson);
          
          if (plantingJson['crops_catalog'] != null) {
            crop = Crop.fromJson(plantingJson['crops_catalog']);
          }
        }
        
        return TaskWithDetails(
          task: task,
          planting: planting,
          crop: crop,
        );
      }).toList();

      setState(() {
        _allTasks = tasks;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleTaskComplete(TaskWithDetails taskWithDetails) async {
    try {
      final task = taskWithDetails.task;
      final newDoneStatus = !task.done;
      
      await SupabaseService.client
          .from('tasks')
          .update({'done': newDoneStatus})
          .eq('id', task.id);

      setState(() {
        final index = _allTasks.indexWhere((t) => t.task.id == task.id);
        if (index != -1) {
          _allTasks[index] = TaskWithDetails(
            task: task.copyWith(done: newDoneStatus),
            planting: taskWithDetails.planting,
            crop: taskWithDetails.crop,
          );
        }
      });

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar tarefa: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _rescheduleTask(TaskWithDetails taskWithDetails) async {
    final localeProvider = context.read<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';
    
    final newDate = await showDatePicker(
      context: context,
      initialDate: taskWithDetails.task.dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: isPortuguese ? 'Reagendar tarefa' : 'Reschedule task',
    );

    if (newDate == null) return;

    try {
      await SupabaseService.client
          .from('tasks')
          .update({'due_date': newDate.toIso8601String().split('T')[0]})
          .eq('id', taskWithDetails.task.id);

      setState(() {
        final index = _allTasks.indexWhere((t) => t.task.id == taskWithDetails.task.id);
        if (index != -1) {
          _allTasks[index] = TaskWithDetails(
            task: taskWithDetails.task.copyWith(dueDate: newDate),
            planting: taskWithDetails.planting,
            crop: taskWithDetails.crop,
          );
        }
      });

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao reagendar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<TaskWithDetails> get _pendingTasks {
    final now = DateTime.now();
    return _allTasks.where((t) => 
      !t.task.done && t.task.dueDate.isAfter(now.subtract(const Duration(days: 1)))
    ).toList();
  }

  List<TaskWithDetails> get _overdueTasks {
    final now = DateTime.now();
    return _allTasks.where((t) => 
      !t.task.done && t.task.dueDate.isBefore(now.subtract(const Duration(days: 1)))
    ).toList();
  }

  List<TaskWithDetails> get _completedTasks {
    return _allTasks.where((t) => t.task.done).toList();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(isPortuguese ? 'Carregando...' : 'Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(isPortuguese ? 'Erro' : 'Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                isPortuguese ? 'Erro ao carregar tarefas' : 'Error loading tasks',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadTasks();
                },
                child: Text(isPortuguese ? 'Tentar novamente' : 'Try again'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isPortuguese ? 'Tarefas' : 'Tasks'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.pending_actions),
              text: isPortuguese ? 'Pendentes (${_pendingTasks.length})' : 'Pending (${_pendingTasks.length})',
            ),
            Tab(
              icon: const Icon(Icons.warning),
              text: isPortuguese ? 'Atrasadas (${_overdueTasks.length})' : 'Overdue (${_overdueTasks.length})',
            ),
            Tab(
              icon: const Icon(Icons.check_circle),
              text: isPortuguese ? 'Concluídas (${_completedTasks.length})' : 'Completed (${_completedTasks.length})',
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadTasks();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTasksList(_pendingTasks, isPortuguese),
          _buildTasksList(_overdueTasks, isPortuguese, isOverdue: true),
          _buildTasksList(_completedTasks, isPortuguese, isCompleted: true),
        ],
      ),
    );
  }

  Widget _buildTasksList(List<TaskWithDetails> tasks, bool isPortuguese, {bool isOverdue = false, bool isCompleted = false}) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.celebration : Icons.task_alt,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isCompleted
                ? (isPortuguese ? 'Nenhuma tarefa concluída' : 'No completed tasks')
                : isOverdue
                  ? (isPortuguese ? 'Nenhuma tarefa atrasada' : 'No overdue tasks')
                  : (isPortuguese ? 'Nenhuma tarefa pendente' : 'No pending tasks'),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTasks,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final taskWithDetails = tasks[index];
          return _buildTaskCard(taskWithDetails, isPortuguese, isOverdue: isOverdue, isCompleted: isCompleted);
        },
      ),
    );
  }

  Widget _buildTaskCard(TaskWithDetails taskWithDetails, bool isPortuguese, {bool isOverdue = false, bool isCompleted = false}) {
    final task = taskWithDetails.task;
    final crop = taskWithDetails.crop;
    
    final now = DateTime.now();
    final daysDifference = task.dueDate.difference(now).inDays;
    
    Color cardColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    
    if (isOverdue) {
      cardColor = Colors.red[50]!;
      borderColor = Colors.red[300]!;
    } else if (!isCompleted && daysDifference <= 1) {
      cardColor = Colors.orange[50]!;
      borderColor = Colors.orange[300]!;
    } else if (isCompleted) {
      cardColor = Colors.green[50]!;
      borderColor = Colors.green[300]!;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getTaskColor(task.type),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getTaskIcon(task.type),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTaskTitle(task.type, isPortuguese),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (crop != null)
                        Text(
                          crop.getName(isPortuguese ? 'pt' : 'en'),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
                if (!isCompleted)
                  Checkbox(
                    value: task.done,
                    onChanged: (_) => _toggleTaskComplete(taskWithDetails),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(task.dueDate, isPortuguese),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                
                if (!isCompleted && daysDifference <= 1) ...[
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: daysDifference == 0
                        ? Colors.red[100]
                        : Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      daysDifference == 0
                        ? (isPortuguese ? 'Hoje' : 'Today')
                        : daysDifference == 1
                          ? (isPortuguese ? 'Amanhã' : 'Tomorrow')
                          : daysDifference < 0
                            ? (isPortuguese ? '${-daysDifference} dias atrás' : '${-daysDifference} days ago')
                            : (isPortuguese ? 'Em $daysDifference dias' : 'In $daysDifference days'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: daysDifference == 0
                          ? Colors.red[700]
                          : Colors.orange[700],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            
            if (!isCompleted) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _rescheduleTask(taskWithDetails),
                    icon: const Icon(Icons.schedule, size: 16),
                    label: Text(
                      isPortuguese ? 'Reagendar' : 'Reschedule',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getTaskIcon(String type) {
    switch (type) {
      case 'water':
        return Icons.water_drop;
      case 'fertilize':
        return Icons.scatter_plot;
      case 'transplant':
        return Icons.transfer_within_a_station;
      case 'harvest':
        return Icons.agriculture;
      default:
        return Icons.task;
    }
  }

  Color _getTaskColor(String type) {
    switch (type) {
      case 'water':
        return Colors.blue;
      case 'fertilize':
        return Colors.brown;
      case 'transplant':
        return Colors.orange;
      case 'harvest':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getTaskTitle(String type, bool isPortuguese) {
    if (isPortuguese) {
      switch (type) {
        case 'water':
          return 'Regar plantas';
        case 'fertilize':
          return 'Adubar';
        case 'transplant':
          return 'Transplantar';
        case 'harvest':
          return 'Colher';
        default:
          return 'Tarefa';
      }
    } else {
      switch (type) {
        case 'water':
          return 'Water plants';
        case 'fertilize':
          return 'Fertilize';
        case 'transplant':
          return 'Transplant';
        case 'harvest':
          return 'Harvest';
        default:
          return 'Task';
      }
    }
  }

  String _formatDate(DateTime date, bool isPortuguese) {
    return isPortuguese 
      ? '${date.day}/${date.month}/${date.year}'
      : '${date.month}/${date.day}/${date.year}';
  }
}

class TaskWithDetails {
  final Task task;
  final Planting? planting;
  final Crop? crop;

  TaskWithDetails({
    required this.task,
    this.planting,
    this.crop,
  });
}