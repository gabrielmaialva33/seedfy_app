import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../models/invitation.dart';
import '../../../services/collaboration_service.dart';

class InvitationsScreen extends StatefulWidget {
  const InvitationsScreen({super.key});

  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  List<Invitation> _invitations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvitations();
  }

  Future<void> _loadInvitations() async {
    try {
      setState(() => _isLoading = true);
      final invitations = await CollaborationService.getPendingInvitations();
      setState(() {
        _invitations = invitations;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading invitations: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleInvitation(Invitation invitation, bool accept) async {
    final localeProvider = context.read<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    try {
      if (accept) {
        await CollaborationService.acceptInvitation(invitation.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isPortuguese
                    ? 'Convite aceito! Você agora faz parte da horta ${invitation.farmName}'
                    : 'Invitation accepted! You are now part of ${invitation.farmName}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await CollaborationService.declineInvitation(invitation.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isPortuguese ? 'Convite recusado' : 'Invitation declined',
              ),
            ),
          );
        }
      }
      _loadInvitations();
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
          isPortuguese ? 'Convites Recebidos' : 'Received Invitations',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadInvitations,
              child: _invitations.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mail_outline,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              isPortuguese
                                  ? 'Nenhum convite pendente'
                                  : 'No pending invitations',
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isPortuguese
                                  ? 'Quando alguém convidar você para colaborar em uma horta, o convite aparecerá aqui'
                                  : 'When someone invites you to collaborate on a garden, the invitation will appear here',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _invitations.length,
                      itemBuilder: (context, index) {
                        final invitation = _invitations[index];
                        final isExpired = invitation.expiresAt != null &&
                            invitation.expiresAt!.isBefore(DateTime.now());

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Farm name and icon
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.grass,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            invitation.farmName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            isPortuguese
                                                ? 'Convidado por ${invitation.inviterName}'
                                                : 'Invited by ${invitation.inviterName}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Role information
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        invitation.role == 'editor'
                                            ? Icons.edit
                                            : Icons.visibility,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        invitation.role == 'editor'
                                            ? (isPortuguese
                                                ? 'Permissão de Editor'
                                                : 'Editor Permission')
                                            : (isPortuguese
                                                ? 'Permissão de Visualizador'
                                                : 'Viewer Permission'),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  invitation.role == 'editor'
                                      ? (isPortuguese
                                          ? 'Você poderá editar e gerenciar todos os aspectos da horta'
                                          : 'You will be able to edit and manage all aspects of the garden')
                                      : (isPortuguese
                                          ? 'Você poderá visualizar os dados da horta, mas não fazer alterações'
                                          : 'You will be able to view garden data but not make changes'),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),

                                const SizedBox(height: 16),

                                // Expiration warning
                                if (invitation.expiresAt != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isExpired
                                          ? Colors.red[100]
                                          : Colors.orange[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      isExpired
                                          ? (isPortuguese
                                              ? 'Convite expirado'
                                              : 'Invitation expired')
                                          : (isPortuguese
                                              ? 'Expira em ${invitation.expiresAt!.difference(DateTime.now()).inDays} dias'
                                              : 'Expires in ${invitation.expiresAt!.difference(DateTime.now()).inDays} days'),
                                      style: TextStyle(
                                        color: isExpired
                                            ? Colors.red[700]
                                            : Colors.orange[700],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),

                                const SizedBox(height: 16),

                                // Action buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: isExpired
                                          ? null
                                          : () => _handleInvitation(
                                              invitation, false),
                                      child: Text(
                                        isPortuguese ? 'Recusar' : 'Decline',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: isExpired
                                          ? null
                                          : () => _handleInvitation(
                                              invitation, true),
                                      child: Text(
                                        isPortuguese ? 'Aceitar' : 'Accept',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
