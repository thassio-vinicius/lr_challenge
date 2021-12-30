import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lr_challenge/UI/home/components/addtask_screen.dart';
import 'package:lr_challenge/utils/adapt.dart';
import 'package:lr_challenge/utils/images.dart';
import 'package:lr_challenge/utils/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: AddTaskScreen(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          Strings.reNest,
          style: Theme.of(context).textTheme.headline2,
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
              icon: Image(image: AssetImage(Images.menuIcon), color: Theme.of(context).primaryColor.withOpacity(.5)),
              onPressed: () => Scaffold.of(context).openDrawer()),
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
                icon: Image(image: AssetImage(Images.addIcon), color: Theme.of(context).primaryColor.withOpacity(.5)),
                onPressed: () => Scaffold.of(context).openEndDrawer()),
          ),
        ],
      ),
      body: Center(
        child: Text(
          Strings.noTasks,
          style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: Adapt.px(16)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
