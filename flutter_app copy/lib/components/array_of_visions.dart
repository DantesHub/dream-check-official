import 'reuse_card.dart';

class ArrayOfVisions {
  List<ReusableCard> visions;

  ArrayOfVisions({this.visions});

  void addedButton() {
    visions.add(
      ReusableCard(),
    );
  }

  bool isEmpty() {
    if (visions.isEmpty) {
      return true;
    }
    return false;
  }
}
