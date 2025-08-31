import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/domain/entities/planting.dart';
import '../../../shared/domain/entities/task.dart';
import '../../../shared/data/datasources/supabase_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(isPortuguese ? 'Configurações' : 'Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(isPortuguese),
            const SizedBox(height: 24),
            _buildLanguageSection(localeProvider, isPortuguese),
            const SizedBox(height: 24),
            _buildCollaboratorsSection(isPortuguese),
            const SizedBox(height: 24),
            _buildDataSection(isPortuguese),
            const SizedBox(height: 24),
            _buildAboutSection(isPortuguese),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(bool isPortuguese) {
    final profile = SupabaseService.currentUser;

    return _buildSection(
      title: isPortuguese ? 'Perfil' : 'Profile',
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: AppTheme.primaryPurple,
            child: Text(
              profile?.email?.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(profile?.email?.split('@')[0] ?? 'Usuário'),
          subtitle: Text(profile?.email ?? 'email@exemplo.com'),
          trailing: const Icon(Icons.edit),
          onTap: () {
            // Navigate to profile edit
          },
        ),
      ],
    );
  }

  Widget _buildLanguageSection(
      LocaleProvider localeProvider, bool isPortuguese) {
    return _buildSection(
      title: isPortuguese ? 'Idioma' : 'Language',
      children: [
        ListTile(
          leading: const Icon(Icons.language, color: AppTheme.primaryPurple),
          title: Text(isPortuguese ? 'Português' : 'Portuguese'),
          trailing: Icon(
            localeProvider.locale.languageCode == 'pt'
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            color: localeProvider.locale.languageCode == 'pt'
                ? AppTheme.primaryPurple
                : Colors.grey,
          ),
          onTap: () => localeProvider.setLocale(const Locale('pt')),
        ),
        ListTile(
          leading: const Icon(Icons.language, color: AppTheme.primaryPurple),
          title: Text(isPortuguese ? 'Inglês' : 'English'),
          trailing: Icon(
            localeProvider.locale.languageCode == 'en'
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            color: localeProvider.locale.languageCode == 'en'
                ? AppTheme.primaryPurple
                : Colors.grey,
          ),
          onTap: () => localeProvider.setLocale(const Locale('en')),
        ),
      ],
    );
  }

  Widget _buildCollaboratorsSection(bool isPortuguese) {
    return _buildSection(
      title: isPortuguese ? 'Colaboradores' : 'Collaborators',
      children: [
        ListTile(
          leading: const Icon(Icons.group_add, color: AppTheme.primaryPurple),
          title: Text(
              isPortuguese ? 'Convidar colaborador' : 'Invite collaborator'),
          subtitle: Text(isPortuguese
              ? 'Compartilhe sua horta com outros'
              : 'Share your garden with others'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showInviteDialog(isPortuguese);
          },
        ),
        ListTile(
          leading: const Icon(Icons.people, color: AppTheme.primaryPurple),
          title: Text(isPortuguese
              ? 'Gerenciar colaboradores'
              : 'Manage collaborators'),
          subtitle: Text(isPortuguese
              ? 'Ver e editar permissões'
              : 'View and edit permissions'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Navigate to collaborators management
          },
        ),
      ],
    );
  }

  Widget _buildDataSection(bool isPortuguese) {
    return _buildSection(
      title: isPortuguese ? 'Dados' : 'Data',
      children: [
        ListTile(
          leading: _isExporting
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.file_download, color: AppTheme.primaryPurple),
          title: Text(isPortuguese ? 'Exportar dados' : 'Export data'),
          subtitle: Text(isPortuguese
              ? 'Baixar seus dados em CSV'
              : 'Download your data as CSV'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _isExporting ? null : () => _exportData(isPortuguese),
        ),
        ListTile(
          leading: const Icon(Icons.backup, color: AppTheme.primaryPurple),
          title: Text(isPortuguese ? 'Backup automático' : 'Auto backup'),
          subtitle: Text(isPortuguese
              ? 'Seus dados são salvos automaticamente'
              : 'Your data is automatically saved'),
          trailing: Switch(
            value: true,
            onChanged: null, // Disabled for now
            activeTrackColor: AppTheme.primaryPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(bool isPortuguese) {
    return _buildSection(
      title: isPortuguese ? 'Suporte' : 'Support',
      children: [
        ListTile(
          leading:
              const Icon(Icons.help_outline, color: AppTheme.primaryPurple),
          title: Text(isPortuguese ? 'Ajuda' : 'Help'),
          subtitle: Text(isPortuguese
              ? 'Perguntas frequentes e tutoriais'
              : 'FAQ and tutorials'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showHelpDialog(isPortuguese);
          },
        ),
        ListTile(
          leading:
              const Icon(Icons.info_outline, color: AppTheme.primaryPurple),
          title: Text(isPortuguese ? 'Sobre' : 'About'),
          subtitle: const Text('Seedfy v1.0.0'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showAboutDialog(isPortuguese);
          },
        ),
        ListTile(
          leading:
              const Icon(Icons.star_outline, color: AppTheme.primaryPurple),
          title: Text(isPortuguese ? 'Avaliar app' : 'Rate app'),
          subtitle: Text(isPortuguese
              ? 'Deixe sua avaliação na loja'
              : 'Leave a review in the store'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Open app store
          },
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
          ),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _exportData(bool isPortuguese) async {
    setState(() {
      _isExporting = true;
    });

    try {
      final userId = SupabaseService.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Load plantings data
      final plantingsResponse =
          await SupabaseService.client.from('plantings').select('''
            *,
            crops_catalog(*),
            beds(name, plots(farms!inner(owner_id)))
          ''').eq('beds.plots.farms.owner_id', userId);

      // Load tasks data
      final tasksResponse =
          await SupabaseService.client.from('tasks').select('''
            *,
            plantings(crops_catalog(*))
          ''').eq('plantings.beds.plots.farms.owner_id', userId);

      // Convert to CSV
      final List<List<dynamic>> plantingsRows = [
        [
          isPortuguese ? 'Data Plantio' : 'Planting Date',
          isPortuguese ? 'Cultura' : 'Crop',
          isPortuguese ? 'Canteiro' : 'Bed',
          isPortuguese ? 'Quantidade' : 'Quantity',
          isPortuguese ? 'Status' : 'Status',
        ]
      ];

      for (final plantingJson in plantingsResponse) {
        final planting = Planting.fromJson(plantingJson);
        plantingsRows.add([
          planting.sowingDate.toIso8601String().split('T')[0],
          plantingJson['crops_catalog']?['name_pt'] ?? 'N/A',
          plantingJson['beds']?['name'] ?? 'N/A',
          planting.quantity,
          planting.getStatus().toString().split('.').last,
        ]);
      }

      final plantingsCsv = const ListToCsvConverter().convert(plantingsRows);

      // Create tasks CSV
      final List<List<dynamic>> tasksRows = [
        [
          isPortuguese ? 'Tipo' : 'Type',
          isPortuguese ? 'Data Vencimento' : 'Due Date',
          isPortuguese ? 'Concluída' : 'Completed',
          isPortuguese ? 'Cultura' : 'Crop',
        ]
      ];

      for (final taskJson in tasksResponse) {
        final task = GardenTask.fromJson(taskJson);
        tasksRows.add([
          task.type.toString().split('.').last,
          task.dueDate.toIso8601String().split('T')[0],
          task.done
              ? (isPortuguese ? 'Sim' : 'Yes')
              : (isPortuguese ? 'Não' : 'No'),
          taskJson['plantings']?['crops_catalog']?['name_pt'] ?? 'N/A',
        ]);
      }

      final tasksCsv = const ListToCsvConverter().convert(tasksRows);

      // Combine both CSVs
      final combinedData = '''
${isPortuguese ? 'DADOS DO SEEDFY' : 'SEEDFY DATA'}
${isPortuguese ? 'Exportado em:' : 'Exported on:'} ${DateTime.now().toIso8601String().split('T')[0]}

${isPortuguese ? 'PLANTIOS' : 'PLANTINGS'}
$plantingsCsv

${isPortuguese ? 'TAREFAS' : 'TASKS'}
$tasksCsv
''';

      // Save and share the file
      await SharePlus.instance.share(
        ShareParams(
          text: combinedData,
          subject: isPortuguese ? 'Dados do Seedfy' : 'Seedfy Data',
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isPortuguese
                  ? 'Dados exportados com sucesso!'
                  : 'Data exported successfully!',
            ),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isPortuguese
                  ? 'Erro ao exportar dados: $e'
                  : 'Error exporting data: $e',
            ),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }

  void _showInviteDialog(bool isPortuguese) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(isPortuguese ? 'Convidar Colaborador' : 'Invite Collaborator'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isPortuguese
                  ? 'O colaborador receberá um convite por email para acessar sua horta.'
                  : 'The collaborator will receive an email invitation to access your garden.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(isPortuguese ? 'Cancelar' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Send invitation logic
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isPortuguese ? 'Convite enviado!' : 'Invitation sent!',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
            ),
            child: Text(isPortuguese ? 'Enviar' : 'Send'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(bool isPortuguese) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isPortuguese ? 'Ajuda' : 'Help'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem(
                isPortuguese ? 'Como adicionar plantas?' : 'How to add plants?',
                isPortuguese
                    ? 'Use a câmera AI para identificar e adicionar plantas automaticamente.'
                    : 'Use the AI camera to identify and add plants automatically.',
              ),
              _buildHelpItem(
                isPortuguese ? 'Como usar o mapa?' : 'How to use the map?',
                isPortuguese
                    ? 'Toque nos canteiros para editá-los ou adicione novos arrastando da barra lateral.'
                    : 'Tap on beds to edit them or add new ones by dragging from the sidebar.',
              ),
              _buildHelpItem(
                isPortuguese
                    ? 'Como funcionam as tarefas?'
                    : 'How do tasks work?',
                isPortuguese
                    ? 'O app gera automaticamente tarefas baseadas no ciclo de crescimento das plantas.'
                    : 'The app automatically generates tasks based on plant growth cycles.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(isPortuguese ? 'Fechar' : 'Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(bool isPortuguese) {
    showAboutDialog(
      context: context,
      applicationName: 'Seedfy',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.eco,
          color: Colors.white,
          size: 32,
        ),
      ),
      children: [
        Text(
          isPortuguese
              ? 'Seedfy é um aplicativo de gestão de hortas que utiliza IA para ajudar pequenos produtores e entusiastas da jardinagem urbana a otimizar suas colheitas.'
              : 'Seedfy is a garden management app that uses AI to help small producers and urban gardening enthusiasts optimize their harvests.',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
        Text(
          isPortuguese ? 'Desenvolvido com:' : 'Built with:',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text('• Flutter'),
        const Text('• Firebase'),
        const Text('• Supabase'),
        const Text('• NVIDIA NIM APIs'),
      ],
    );
  }
}
