import 'package:flutter/material.dart';
import 'package:lr_challenge/utils/adapt.dart';
import 'package:lr_challenge/utils/hexcolor.dart';
import 'package:lr_challenge/utils/images.dart';
import 'package:lr_challenge/utils/strings.dart';

class TaskTile extends StatefulWidget {
  final String title;
  const TaskTile(this.title, {Key? key}) : super(key: key);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool showFirst = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Adapt.px(6)),
      child: Container(
        decoration:
            BoxDecoration(color: HexColor('#F4F7FA'), borderRadius: BorderRadius.all(Radius.circular(Adapt.px(10)))),
        padding: EdgeInsets.all(Adapt.px(10)),
        child: AnimatedCrossFade(
          duration: kThemeAnimationDuration,
          crossFadeState: isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: CircularProgressIndicator(),
          secondChild: AnimatedCrossFade(
            duration: kThemeAnimationDuration,
            crossFadeState: showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            secondChild: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                priorityCard(Strings.highPriority.replaceAll(' ', '\n'), 2),
                priorityCard(Strings.normalPriority.replaceAll(' ', '\n'), 1),
                priorityCard(Strings.lowPriority.replaceAll(' ', '\n'), 0),
                IconButton(
                  icon:
                      Image(image: AssetImage(Images.closeIcon), color: Theme.of(context).primaryColor.withOpacity(.5)),
                  onPressed: () => setState(() {
                    print('tap ' + showFirst.toString());
                    showFirst = true;
                  }),
                ),
              ],
            ),
            firstChild: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    flex: 8,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(widget.title,
                          maxLines: 1, style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: Adapt.px(18))),
                    )),
                Flexible(
                  flex: 2,
                  child: IconButton(
                    icon: Image(image: AssetImage(Images.addIcon), color: Theme.of(context).primaryColor),
                    onPressed: () => setState(() {
                      print('tap ' + showFirst.toString());

                      showFirst = false;
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  priorityCard(String title, int priority) {
    return Flexible(
      flex: 3,
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(6)),
          child: Container(
            decoration: BoxDecoration(
              color: priorityColor(priority),
              borderRadius: BorderRadius.all(
                Radius.circular(Adapt.px(10)),
              ),
            ),
            padding: EdgeInsets.all(Adapt.px(6)),
            child: Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: Adapt.px(12), color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
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
}
