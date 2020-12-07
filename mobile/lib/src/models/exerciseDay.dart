import 'package:flutter/foundation.dart';

class ExerciseDay {
  bool isPrivate;
  DateTime startedAt;
  DateTime scheduledAt;
  String channelName;
  List<String> friendIds;
  String packLeader;
  ExerciseDay({
    this.startedAt,
    this.channelName,
    @required this.isPrivate,
    @required this.scheduledAt,
    @required this.friendIds,
    @required this.packLeader,
  });
  bool get hasBegun => scheduledAt.isBefore(DateTime.now());
}
