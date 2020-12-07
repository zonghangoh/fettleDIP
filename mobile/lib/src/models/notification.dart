enum NotificationType {
  FriendRequest,
  FriendAccepted,
  WorkoutInvitation,
  Petted,
  FettleTeam
}

class FettleNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String subtitle;
  final Map body;
  int action;
  bool read;
  FettleNotification(
      {this.id,
      this.read,
      this.type,
      this.title,
      this.subtitle,
      this.body,
      this.action = 0});

  static NotificationType returnNotificationTypeFromFirebase(String value) {
    switch (value) {
      case 'FriendRequest':
        return NotificationType.FriendRequest;
      case 'WorkoutInvitation':
        return NotificationType.WorkoutInvitation;
      case 'FettleTeam':
        return NotificationType.FettleTeam;
      case 'Petted':
        return NotificationType.Petted;
      default:
        return NotificationType.FettleTeam;
    }
  }

  static String returnStringFromNotificationType(NotificationType value) {
    switch (value) {
      case NotificationType.FriendRequest:
        return 'FriendRequest';
      case NotificationType.WorkoutInvitation:
        return 'WorkoutInvitation';
      case NotificationType.FettleTeam:
        return 'FettleTeam';
      case NotificationType.Petted:
        return 'Petted';
      default:
        return 'FettleTeam';
    }
  }
}
