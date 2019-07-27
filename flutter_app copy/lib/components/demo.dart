import 'package:flutter/material.dart';
import 'sliver.dart';
import 'package:flutter/material.dart';
import 'package:vision_check_test/StepMakerPage.dart';
import 'VerticalDivider.dart';
import 'Constants.dart';
import 'dream_card.dart';
import 'package:vision_check_test/step_builder.dart';
import 'Constants.dart';
import 'package:vision_check_test/Confirmation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'local_notification_helper.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'step_card.dart';

const title = "ReorderableListSimple demo";

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _scrollController =
      new ScrollController(initialScrollOffset: 20.0);

  List<String> _list = ["Apple", "Ball", "Cat", "Dog", "Elephant"];
  List<StepCard> gangList = [
    new StepCard(
      key: new Key(UniqueKey().toString()),
      stepNumber: (1),
      stepName: "gasng",
      cardReminderDate: "w",
      cardReminderTime: "f",
      cardDateVariable: "s",
      cardWantsRemind: true,
      uniqueNumber: uniqueNumber,
    ),
    new StepCard(
      key: new Key(UniqueKey().toString()),
      stepNumber: (1),
      stepName: "gafng",
      cardReminderDate: "w",
      cardReminderTime: "f",
      cardDateVariable: "s",
      cardWantsRemind: true,
      uniqueNumber: uniqueNumber,
    ),
    new StepCard(
      key: new Key(UniqueKey().toString()),
      stepNumber: (1),
      stepName: "ganag",
      cardReminderDate: "w",
      cardReminderTime: "f",
      cardDateVariable: "s",
      cardWantsRemind: true,
      uniqueNumber: uniqueNumber,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ReorderableListView(
        children: gangList
            .map(
              (item) => Dismissible(
                    key: new Key(UniqueKey().toString()),
                    onDismissed: (direction) {
                      setState(() {
                        gangList.remove(item);
                      });
                    },
                    direction: DismissDirection.endToStart,
                    child: new StepCard(
                      key: new Key(UniqueKey().toString()),
                      stepNumber: (1),
                      stepName: item.stepName,
                      cardReminderDate: "w",
                      cardReminderTime: "f",
                      cardDateVariable: "s",
                      cardWantsRemind: true,
                      uniqueNumber: uniqueNumber,
                    ),
                  ),
            )
            .toList(),
        onReorder: (int start, int current) {
          // dragging from top to bottom
          if (start < current) {
            int end = current - 1;
            StepCard startItem = gangList[start];
            int i = 0;
            int local = start;
            do {
              gangList[local] = gangList[++local];
              i++;
            } while (i < end - start);
            gangList[end] = startItem;
          }
          // dragging from bottom to top
          else if (start > current) {
            StepCard startItem = gangList[start];
            for (int i = start; i > current; i--) {
              gangList[i] = gangList[i - 1];
            }
            gangList[current] = startItem;
          }
          setState(() {});
        },
      ),
    );
  }
}
