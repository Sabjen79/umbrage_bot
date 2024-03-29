import 'package:nyxx/nyxx.dart';
import 'package:nyxx_lavalink/nyxx_lavalink.dart';

class MusicTrack {
  final Track track;
  final Member member;
  bool isUnskippable;
  bool hidden;

  MusicTrack(this.track, {required this.member, this.isUnskippable = false, this.hidden = false});
}