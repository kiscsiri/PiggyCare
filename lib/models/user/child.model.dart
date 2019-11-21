import 'package:piggybanx/models/chore/chore.model.dart';
import 'package:piggybanx/models/piggy/piggy.model.dart';

import 'user.model.dart';

class Child extends UserData {
  String parentId;
  List<Chore> chores;
  List<Piggy> piggies;
}
