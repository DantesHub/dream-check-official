import 'package:flutter/material.dart';
import 'dream_card.dart';

const Color mainAccentColor = Color(0xFF15C96C);
Color mainButtonColor = Colors.grey[100];
const Color mainButtonTextColor = Colors.black;
List<Widget> dreamCards = new List<Widget>();
const Color titleColor = Color(0xFF39414C);
var iconMap = {
  "Fitness": Icons.fitness_center,
  "Building a Project": Icons.build,
  "Spiritual": Icons.mood,
  "Career": Icons.work,
  "Relationships": Icons.people,
  "Traveling": Icons.flight,
  "Studying": Icons.mode_edit,
  "Giving Back/Philanthropy": Icons.nature_people,
  "Entrepreneurship": Icons.lightbulb_outline,
  "Athletics": Icons.directions_bike,
  "Other": Icons.more_horiz,
};
var inverseIconMap = {
  Icons.fitness_center: "Fitness",
  Icons.build: "Building a Project",
  Icons.mood: "Spiritual",
  Icons.work: "Career",
  Icons.people: "Relationships",
  Icons.flight: "Traveling",
  Icons.mode_edit: "Studying",
  Icons.nature_people: "Giving Back/Philanthropy",
  Icons.lightbulb_outline: "Entrepreneurship",
  Icons.directions_bike: "Athletics",
  Icons.more_horiz: "Other",
};

//Function userOnPressed =
