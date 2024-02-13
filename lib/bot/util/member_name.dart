import 'package:nyxx/nyxx.dart';

extension MemberName on Member {
  String get effectiveName {
    if(nick != null) return nick!;
    if(user?.globalName != null) return user!.globalName!;
    return user!.username;
  }
}