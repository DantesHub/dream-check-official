import 'package:flutter/material.dart';
import 'components/Constants.dart';
import 'components/completed_dream.dart';
import 'completed_dreams.dart';
import 'package:intl/intl.dart';
import 'home_page.dart';
import 'components/dream_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FinishedDreamAlert extends StatefulWidget {
  FinishedDreamAlert({@required this.dreamTitle, @required this.iconData});
  String dreamTitle;
  IconData iconData;
  @override
  _FinishedDreamAlertState createState() => _FinishedDreamAlertState();
}

class _FinishedDreamAlertState extends State<FinishedDreamAlert> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      title: Text(
        "Steps left",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
              "You have unfinished Steps are you sure you are done with this dream?"),
          Center(
            child: FlatButton(
              onPressed: () {
                for (int i = 1; i < dreamCards.length; i++) {
                  Firestore.instance
                      .collection('users')
                      .document(loggedInUser.email)
                      .collection("dreams")
                      .document("dream" + i.toString())
                      .collection("stepListForDream")
                      .getDocuments()
                      .then((snapshot) {
                    for (DocumentSnapshot ds in snapshot.documents) {
                      ds.reference.delete();
                    }
                  });
                }
                dreamCards.removeAt(positionOfDreamPressed);
                counter--;
                for (int i = 1; i < dreamCards.length; i++) {
                  DreamCard d = dreamCards[i];
                  d.position = i;
                }
                for (int i = 1; i < dreamCards.length; i++) {
                  print("wathappned");
                  DreamCard dCard = dreamCards[i];
                  Firestore.instance
                      .collection('users')
                      .document(loggedInUser.email)
                      .collection("dreams")
                      .document("dream" + i.toString())
                      .setData({
                    'title': dCard.dreamTitle,
                    'position': dCard.position,
                    'icon': inverseIconMap[dCard.icon],
                  });
                }
                Firestore.instance
                    .collection('users')
                    .document(loggedInUser.email)
                    .collection("dreams")
                    .document("dream" + (dreamCards.length).toString())
                    .delete();
                removedDream = true;
                onFinishedDreams = true;
                var now = new DateTime.now();
                completedDreamsList.add(new CompletedDream(
                  dreamText: widget.dreamTitle,
                  iconData: inverseIconMap[widget.iconData],
                  dateCompleted: new DateFormat("dd-MM-yyyy").format(now),
                ));
                Firestore.instance
                    .collection('users')
                    .document(loggedInUser.email)
                    .collection("completedDreams")
                    .document(now.toString())
                    .setData({
                  "title": widget.dreamTitle,
                  "icon": inverseIconMap[widget.iconData],
                  "dateCompleted": new DateFormat("dd-MM-yyyy").format(now),
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FinishedDreams(),
                  ),
                );
              },
              child: Text(
                "Yes",
                textAlign: TextAlign.center,
                style: TextStyle(color: mainAccentColor, fontSize: 20.0),
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
