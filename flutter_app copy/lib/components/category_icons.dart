import 'package:flutter/material.dart';
import 'package:vision_check_test/step_builder.dart';
import 'package:vision_check_test/home_page.dart';
import 'dream_card.dart';
import 'Constants.dart';
import 'package:vision_check_test/main.dart';
import 'package:vision_check_test/components/step_card.dart';

IconData usersIconData = Icons.favorite;
String chosenCategoryText = "";
List<StepCard> s = new List<StepCard>();

class CategoryWidget extends StatelessWidget {
  const CategoryWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Category(
          text: "Fitness",
          iconData: Icons.fitness_center,
        ),
        new Category(
          text: "Building a Project",
          iconData: Icons.build,
        ),
        new Category(
          text: "Spiritual",
          iconData: Icons.mood,
        ),
        new Category(
          text: "Career",
          iconData: Icons.work,
        ),
        new Category(
          text: "Relationships",
          iconData: Icons.people,
        ),
        new Category(
          text: "Traveling",
          iconData: Icons.flight,
        ),
        new Category(
          text: "Studying",
          iconData: Icons.mode_edit,
        ),
        new Category(
          text: "Giving Back/Philanthropy",
          iconData: Icons.nature_people,
        ),
        new Category(
          text: "Entrepreneurship",
          iconData: Icons.lightbulb_outline,
        ),
        new Category(
          text: "Athletics",
          iconData: Icons.directions_bike,
        ),
        new Category(
          text: "Other",
          iconData: Icons.more_horiz,
        ),
      ],
    );
  }
}

class Category extends StatelessWidget {
  Category({@required this.text, @required this.iconData});
  final String text;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.1),
            bottom: BorderSide(
              color: Colors.black,
              width: 0.5,
            ),
          ),
        ),
        child: FlatButton(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          onPressed: () {
            onHomePage = false;
            usersIconData = this.iconData;
            chosenCategoryText = this.text;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Steps(
                      icon: usersIconData,
                      stepsList: s,
                    ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Icon(
                iconData,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
