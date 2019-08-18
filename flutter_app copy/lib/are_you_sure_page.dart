import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'components/Constants.dart';
import 'step_builder.dart';
import 'components/step_card.dart';
import 'home_page.dart';
import 'components/dream_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int dreamPosition;

class AreYouSurePage extends StatefulWidget {
  AreYouSurePage(
      {@required iconData, @required dreamTitle, @required position});
  IconData iconData;
  String dreamTitle;
  int position;

  @override
  createState() => _AreYouSureState();
}

class _AreYouSureState extends State<AreYouSurePage> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Are you sure you want to delete this dream?",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 170.0,
                  color: mainAccentColor,
                  child: FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
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
                              .updateData({
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

                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
                Container(
                  width: 170.0,
                  color: Colors.grey[200],
                  child: FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Nope!",
                        style:
                            TextStyle(color: mainAccentColor, fontSize: 30.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
