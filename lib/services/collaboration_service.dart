import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/invitation.dart';
import '../models/collaborator.dart';
import '../models/farm.dart';

class CollaborationService {
  static final _supabase = Supabase.instance.client;

  // Send invitation to collaborate on a farm
  static Future<void> sendInvitation({
    required String farmId,
    required String inviteeEmail,
    required String role,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Get inviter details and farm name
      final profileResponse = await _supabase
          .from('profiles')
          .select('name, email')
          .eq('id', user.id)
          .single();

      final farmResponse = await _supabase
          .from('farms')
          .select('name')
          .eq('id', farmId)
          .single();

      // Generate a unique token for the invitation
      final token = DateTime.now().millisecondsSinceEpoch.toString();

      // Create invitation record
      await _supabase.from('invitations').insert({
        'farm_id': farmId,
        'farm_name': farmResponse['name'],
        'inviter_id': user.id,
        'inviter_name': profileResponse['name'],
        'inviter_email': profileResponse['email'],
        'invitee_email': inviteeEmail,
        'role': role,
        'status': 'pending',
        'token': token,
        'expires_at':
            DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      });

      // TODO: Send email notification to invitee
      // This would typically be done through a backend function
      // that sends an email with the invitation link
    } catch (e) {
      throw Exception('Failed to send invitation: $e');
    }
  }

  // Get pending invitations for current user
  static Future<List<Invitation>> getPendingInvitations() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('invitations')
          .select('*')
          .eq('invitee_email', user.email!)
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      return (response as List).map((json) => Invitation.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get invitations: $e');
    }
  }

  // Get sent invitations for a farm
  static Future<List<Invitation>> getSentInvitations(String farmId) async {
    try {
      final response = await _supabase
          .from('invitations')
          .select('*')
          .eq('farm_id', farmId)
          .order('created_at', ascending: false);

      return (response as List).map((json) => Invitation.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get sent invitations: $e');
    }
  }

  // Accept invitation
  static Future<void> acceptInvitation(String invitationId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Get invitation details
      final invitationResponse = await _supabase
          .from('invitations')
          .select('*')
          .eq('id', invitationId)
          .single();

      final invitation = Invitation.fromJson(invitationResponse);

      // Check if invitation is valid
      if (invitation.status != 'pending') {
        throw Exception('Invitation is no longer valid');
      }

      if (invitation.inviteeEmail != user.email) {
        throw Exception('This invitation is for a different email');
      }

      if (invitation.expiresAt != null &&
          invitation.expiresAt!.isBefore(DateTime.now())) {
        throw Exception('Invitation has expired');
      }

      // Add user as collaborator
      await _supabase.from('collaborators').insert({
        'farm_id': invitation.farmId,
        'profile_id': user.id,
        'role': invitation.role,
      });

      // Update invitation status
      await _supabase
          .from('invitations')
          .update({'status': 'accepted'})
          .eq('id', invitationId);
    } catch (e) {
      throw Exception('Failed to accept invitation: $e');
    }
  }

  // Decline invitation
  static Future<void> declineInvitation(String invitationId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _supabase
          .from('invitations')
          .update({'status': 'declined'})
          .eq('id', invitationId)
          .eq('invitee_email', user.email!);
    } catch (e) {
      throw Exception('Failed to decline invitation: $e');
    }
  }

  // Get collaborators for a farm
  static Future<List<Collaborator>> getCollaborators(String farmId) async {
    try {
      final response = await _supabase
          .from('collaborators')
          .select('*, profile:profiles(*)')
          .eq('farm_id', farmId)
          .order('created_at', ascending: false);

      return (response as List).map((json) {
        // Flatten the profile data
        final Map<String, dynamic> collaboratorData = {
          ...json as Map<String, dynamic>,
          'name': json['profile']['name'],
          'email': json['profile']['email'],
        };
        return Collaborator.fromJson(collaboratorData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get collaborators: $e');
    }
  }

  // Remove collaborator
  static Future<void> removeCollaborator(String collaboratorId) async {
    try {
      await _supabase.from('collaborators').delete().eq('id', collaboratorId);
    } catch (e) {
      throw Exception('Failed to remove collaborator: $e');
    }
  }

  // Update collaborator role
  static Future<void> updateCollaboratorRole(
      String collaboratorId, String newRole) async {
    try {
      await _supabase
          .from('collaborators')
          .update({'role': newRole})
          .eq('id', collaboratorId);
    } catch (e) {
      throw Exception('Failed to update collaborator role: $e');
    }
  }

  // Get farms where user is a collaborator
  static Future<List<Farm>> getCollaborativeFarms() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('collaborators')
          .select('farm:farms(*)')
          .eq('profile_id', user.id)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Farm.fromJson(json['farm']))
          .toList();
    } catch (e) {
      throw Exception('Failed to get collaborative farms: $e');
    }
  }

  // Check if user has permission to edit a farm
  static Future<bool> canEditFarm(String farmId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      // Check if user is owner
      final ownerResponse = await _supabase
          .from('farms')
          .select('owner_id')
          .eq('id', farmId)
          .single();

      if (ownerResponse['owner_id'] == user.id) {
        return true;
      }

      // Check if user is an editor collaborator
      final collaboratorResponse = await _supabase
          .from('collaborators')
          .select('role')
          .eq('farm_id', farmId)
          .eq('profile_id', user.id)
          .maybeSingle();

      return collaboratorResponse != null &&
          collaboratorResponse['role'] == 'editor';
    } catch (e) {
      return false;
    }
  }
}