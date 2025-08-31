import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../models/collaborator.dart';
import '../../../models/invitation.dart';
import '../../../services/collaboration_service.dart';
import '../../../services/supabase_service.dart';

class ManageCollaboratorsScreen extends StatefulWidget {
  final String farmId;
  final String farmName;

  const ManageCollaboratorsScreen({
    super.key,
    required this.farmId,
    required this.farmName,
  });

  @override
  State<ManageCollaboratorsScreen> createState() =>
      _ManageCollaboratorsScreenState();
}

class _ManageCollaboratorsScreenState extends State<ManageCollaboratorsScreen> {
  List<Collaborator> _collaborators = [];
  List<Invitation> _pendingInvitations = [];
  bool _isLoading = true;
  bool _isOwner = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);

      // Check if current user is owner
      final currentUserId = SupabaseService.currentUser?.id;
      final farm = await SupabaseService.getFarmById(widget.farmId);
      _isOwner = farm != null && farm.ownerId == currentUserId;

      // Load collaborators and invitations
      final collaborators =
          await CollaborationService.getCollaborators(widget.farmId);
      final invitations =
          await CollaborationService.getSentInvitations(widget.farmId);

      setState(() {
        _collaborators = collaborators;
        _pendingInvitations =
            invitations.where((i) => i.status == 'pending').toList();
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showInviteDialog() async {
    final localeProvider = context.read<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    final emailController = TextEditingController();
    String selectedRole = 'viewer';

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            isPortuguese ? 'Convidar Colaborador' : 'Invite Collaborator',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: isPortuguese
                      ? 'colaborador@email.com'
                      : 'collaborator@email.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                decoration: InputDecoration(
                  labelText: isPortuguese ? 'Permissão' : 'Permission',
                  prefixIcon: const Icon(Icons.security),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'viewer',
                    child: Text(isPortuguese ? 'Visualizador' : 'Viewer'),
                  ),
                  DropdownMenuItem(
                    value: 'editor',
                    child: Text(isPortuguese ? 'Editor' : 'Editor'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => selectedRole = value!);
                },
              ),
              const SizedBox(height: 8),
              Text(
                isPortuguese
                    ? selectedRole == 'viewer'
                        ? 'Pode apenas visualizar os dados'
                        : 'Pode editar e gerenciar a horta'
                    : selectedRole == 'viewer'
                        ? 'Can only view data'
                        : 'Can edit and manage the garden',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(isPortuguese ? 'Cancelar' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isPortuguese
                            ? 'Digite um email válido'
                            : 'Enter a valid email',
                      ),
                    ),
                  );
                  return;
                }

                // Capture the navigator and scaffold messenger before async operation
                final navigator = Navigator.of(context);
                final scaffoldMessenger = ScaffoldMessenger.of(context);

                try {
                  await CollaborationService.sendInvitation(
                    farmId: widget.farmId,
                    inviteeEmail: email,
                    role: selectedRole,
                  );

                  // Use captured references
                  navigator.pop();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        isPortuguese
                            ? 'Convite enviado com sucesso!'
                            : 'Invitation sent successfully!',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _loadData();
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(isPortuguese ? 'Enviar Convite' : 'Send Invite'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _removeCollaborator(Collaborator collaborator) async {
    final localeProvider = context.read<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isPortuguese ? 'Remover Colaborador?' : 'Remove Collaborator?',
        ),
        content: Text(
          isPortuguese
              ? 'Tem certeza que deseja remover ${collaborator.name} da horta?'
              : 'Are you sure you want to remove ${collaborator.name} from the garden?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(isPortuguese ? 'Cancelar' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(isPortuguese ? 'Remover' : 'Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await CollaborationService.removeCollaborator(collaborator.id);
        _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isPortuguese ? 'Colaborador removido' : 'Collaborator removed',
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _updateRole(Collaborator collaborator, String newRole) async {
    try {
      await CollaborationService.updateCollaboratorRole(
        collaborator.id,
        newRole,
      );
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isPortuguese ? 'Gerenciar Colaboradores' : 'Manage Collaborators',
        ),
        actions: [
          if (_isOwner)
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: _showInviteDialog,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Farm name header
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.grass,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.farmName,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isPortuguese
                                ? '${_collaborators.length} colaborador${_collaborators.length != 1 ? 'es' : ''}'
                                : '${_collaborators.length} collaborator${_collaborators.length != 1 ? 's' : ''}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Pending invitations section
                  if (_pendingInvitations.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      isPortuguese
                          ? 'Convites Pendentes'
                          : 'Pending Invitations',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ..._pendingInvitations.map((invitation) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.mail_outline),
                            ),
                            title: Text(invitation.inviteeEmail),
                            subtitle: Text(
                              invitation.role == 'editor'
                                  ? (isPortuguese ? 'Editor' : 'Editor')
                                  : (isPortuguese ? 'Visualizador' : 'Viewer'),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isPortuguese ? 'Pendente' : 'Pending',
                                  style: TextStyle(
                                    color: Colors.orange[700],
                                    fontSize: 12,
                                  ),
                                ),
                                if (_isOwner)
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      // Cancel invitation
                                    },
                                  ),
                              ],
                            ),
                          ),
                        )),
                  ],

                  // Active collaborators section
                  const SizedBox(height: 24),
                  Text(
                    isPortuguese
                        ? 'Colaboradores Ativos'
                        : 'Active Collaborators',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (_collaborators.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isPortuguese
                                  ? 'Nenhum colaborador ainda'
                                  : 'No collaborators yet',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isPortuguese
                                  ? 'Convide pessoas para colaborar na sua horta'
                                  : 'Invite people to collaborate on your garden',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._collaborators.map((collaborator) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                collaborator.name.isNotEmpty
                                    ? collaborator.name[0].toUpperCase()
                                    : 'U',
                              ),
                            ),
                            title: Text(collaborator.name),
                            subtitle: Text(collaborator.email),
                            trailing: _isOwner
                                ? PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'remove') {
                                        _removeCollaborator(collaborator);
                                      } else if (value == 'editor' ||
                                          value == 'viewer') {
                                        _updateRole(collaborator, value);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: collaborator.role == 'editor'
                                            ? 'viewer'
                                            : 'editor',
                                        child: Text(
                                          collaborator.role == 'editor'
                                              ? (isPortuguese
                                                  ? 'Mudar para Visualizador'
                                                  : 'Change to Viewer')
                                              : (isPortuguese
                                                  ? 'Mudar para Editor'
                                                  : 'Change to Editor'),
                                        ),
                                      ),
                                      const PopupMenuDivider(),
                                      PopupMenuItem(
                                        value: 'remove',
                                        child: Text(
                                          isPortuguese ? 'Remover' : 'Remove',
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  )
                                : Chip(
                                    label: Text(
                                      collaborator.role == 'editor'
                                          ? (isPortuguese ? 'Editor' : 'Editor')
                                          : (isPortuguese
                                              ? 'Visualizador'
                                              : 'Viewer'),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                          ),
                        )),
                ],
              ),
            ),
      floatingActionButton: _isOwner && !_isLoading
          ? FloatingActionButton.extended(
              onPressed: _showInviteDialog,
              icon: const Icon(Icons.person_add),
              label: Text(
                isPortuguese ? 'Convidar' : 'Invite',
              ),
            )
          : null,
    );
  }
}
