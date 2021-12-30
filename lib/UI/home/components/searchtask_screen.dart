import 'package:flutter/material.dart';
import 'package:lr_challenge/UI/home/components/task_card.dart';
import 'package:lr_challenge/UI/shared/custom_textfield.dart';
import 'package:lr_challenge/models/task.dart';
import 'package:lr_challenge/services/firestore_provider.dart';
import 'package:lr_challenge/utils/adapt.dart';
import 'package:lr_challenge/utils/hexcolor.dart';
import 'package:lr_challenge/utils/strings.dart';
import 'package:provider/provider.dart';

class SearchTaskScreen extends StatefulWidget {
  final List<Task> tasks;

  SearchTaskScreen(this.tasks);

  @override
  _SearchTaskScreenState createState() => _SearchTaskScreenState();
}

class _SearchTaskScreenState extends State<SearchTaskScreen> {
  TextEditingController searchQueryController = TextEditingController();
  bool startedSearching = false;

  List<Task> results = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: buildSearchField(),
        actions: buildActions(),
        elevation: 0,
      ),
      body: Container(
        width: double.maxFinite,
        color: Theme.of(context).cardColor,
        child: ListView(
          padding: EdgeInsets.all(Adapt.px(8)),
          children: results.isEmpty
              ? startedSearching
                  ? [Center(child: Text(Strings.noResults, style: Theme.of(context).textTheme.headline1))]
                  : [Container()]
              : [tasksView(results)],
        ),
      ),
    );
  }

  Widget tasksView(List<Task> tasks) {
    List<Task> lowPriority = tasks.where((element) => element.priority == 0).toList();
    List<Task> normalPriority = tasks.where((element) => element.priority == 1).toList();
    List<Task> highPriority = tasks.where((element) => element.priority == 2).toList();

    bool hasLow = lowPriority.isNotEmpty;
    bool hasNormal = normalPriority.isNotEmpty;
    bool hasHigh = highPriority.isNotEmpty;

    return SizedBox(
      height: Adapt().hp(90),
      child: Padding(
        padding: EdgeInsets.only(top: Adapt.px(24)),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            if (hasHigh) taskList(highPriority),
            if (hasNormal) taskList(normalPriority),
            if (hasLow) taskList(lowPriority),
          ],
        ),
      ),
    );
  }

  Column taskList(List<Task> tasks) {
    int priority = tasks.first.priority;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          taskListTitle(priority),
          style:
              Theme.of(context).textTheme.headline2!.copyWith(color: priorityColor(priority), fontSize: Adapt.px(14)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Adapt.px(12)),
          child: SizedBox(
            height: Adapt().hp(tasks.length * 10),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) => TaskCard(
                tasks[index],
                onPressed: () async =>
                    await Provider.of<FirestoreProvider>(context, listen: false).updateTask(tasks[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String taskListTitle(int priority) {
    late String title;

    switch (priority) {
      case 0:
        title = Strings.lowPriority.toUpperCase();
        break;
      case 1:
        title = Strings.normalPriority.toUpperCase();
        break;
      case 2:
        title = Strings.highPriority.toUpperCase();
        break;
    }
    return title;
  }

  Color priorityColor(int priority) {
    late Color color;

    switch (priority) {
      case 0:
        color = HexColor('4196EA');
        break;
      case 1:
        color = HexColor('48CE00');
        break;
      case 2:
        color = HexColor('#FF2765');
        break;
    }
    return color;
  }

  buildActions() {
    return [
      Padding(
        padding: EdgeInsets.all(Adapt.px(8)),
        child: GestureDetector(
          child: Center(
            child: Text(
              Strings.cancel,
              style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontSize: Adapt.px(14),
                  ),
            ),
          ),
          onTap: () => Navigator.pop(context),
        ),
      )
    ];
  }

  Widget buildSearchField() {
    return CustomTextField(
      controller: searchQueryController,
      searchBar: true,
      radius: 100,
      hint: Strings.search,
      onSuffixPressed: clearSearchQuery,
      onChanged: updateSearchQuery,
    );
  }

  void clearSearchQuery() {
    setState(() {
      searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  updateSearchQuery(String query) {
    List<Task> list =
        widget.tasks.where((element) => element.title.toLowerCase().contains(query.toLowerCase())).toList();
    setState(() {
      startedSearching = true;
      results = list;
    });

    if (query.isEmpty) {
      setState(() {
        startedSearching = false;
      });
    }

    print('updated results' + results.map((e) => e.title).toString());
  }
}
