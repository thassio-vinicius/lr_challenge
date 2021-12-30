import 'package:flutter/material.dart';
import 'package:lr_challenge/models/task.dart';
import 'package:lr_challenge/utils/adapt.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final void Function()? onPressed;
  const TaskCard(this.task, {this.onPressed});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late Task task;

  @override
  void initState() {
    task = widget.task;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Adapt.px(8)),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.all(Adapt.px(8)),
        child: Row(
          children: [
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                value: task.completed,
                checkColor: Theme.of(context).primaryColor.withOpacity(.4),
                activeColor: Theme.of(context).primaryColor.withOpacity(.05),
                onChanged: (value) {
                  setState(() {
                    task.completed = value!;
                  });

                  widget.onPressed;
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(.5)),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: Adapt.px(10)),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    widget.task.title,
                    maxLines: 1,
                    style: !widget.task.completed
                        ? Theme.of(context).textTheme.headline1
                        : Theme.of(context).textTheme.headline1!.copyWith(
                            color: Theme.of(context).primaryColor.withOpacity(.2),
                            decoration: TextDecoration.lineThrough),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
