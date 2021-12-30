import 'package:flutter/material.dart';
import 'package:lr_challenge/UI/home/components/task_tile.dart';
import 'package:lr_challenge/UI/shared/custom_backbutton.dart';
import 'package:lr_challenge/utils/adapt.dart';
import 'package:lr_challenge/utils/strings.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: Adapt().wp(100),
      child: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.all(Adapt.px(16)),
          children: <Widget>[
            Stack(
              children: [
                Positioned(left: -12, top: 0, bottom: 0, child: CustomBackButton()),
                Center(
                  child: Text(
                    Strings.addTask,
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontWeight: FontWeight.w500, fontSize: Adapt.px(22)),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: Adapt.px(46)),
              child: Container(
                height: Adapt().hp(85),
                child: ListView.builder(
                    itemCount: Strings.taskTitles.length,
                    itemBuilder: (context, index) => TaskTile(Strings.taskTitles[index])),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
