import 'popup_item.dart';
import 'Constants.dart';
import 'package:flutter/material.dart';

class Choices {
  static Item Add = Item(
    title: const Text(
      "Add Step",
      style: TextStyle(fontSize: 15.0, color: Colors.black),
    ),
    icon: Icon(
      Icons.add,
      color: mainAccentColor,
    ),
  );

  static Item Done = Item(
    title: const Text(
      "Done editing",
      style: TextStyle(fontSize: 15.0, color: Colors.black),
    ),
    icon: Icon(
      Icons.edit,
      color: mainAccentColor,
    ),
  );

  static Item Finished = Item(
    title: const Text(
      "Finished Dream",
      style: TextStyle(fontSize: 15.0, color: Colors.black),
    ),
    icon: Icon(
      Icons.check,
      color: mainAccentColor,
    ),
  );

  static List<Item> choices = <Item>[Add, Done, Finished];
}

class AddDreamChoices {
  static Item Add = Item(
    title: const Text(
      "Add Step",
      style: TextStyle(fontSize: 15.0, color: Colors.black),
    ),
    icon: Icon(
      Icons.add,
      color: mainAccentColor,
    ),
  );

  static Item Done = Item(
    title: const Text(
      "Done editing",
      style: TextStyle(fontSize: 15.0, color: Colors.black),
    ),
    icon: Icon(
      Icons.edit,
      color: mainAccentColor,
    ),
  );

  static List<Item> finisheddreamchoices = <Item>[
    Add,
    Done,
  ];
}
