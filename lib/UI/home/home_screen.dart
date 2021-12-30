import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lr_challenge/UI/home/components/addtask_screen.dart';
import 'package:lr_challenge/UI/home/components/searchtask_screen.dart';
import 'package:lr_challenge/UI/home/components/task_card.dart';
import 'package:lr_challenge/UI/shared/custom_primarybutton.dart';
import 'package:lr_challenge/UI/shared/custom_textfield.dart';
import 'package:lr_challenge/UI/sign_in/authentication_screen.dart';
import 'package:lr_challenge/models/firestore_user.dart';
import 'package:lr_challenge/models/task.dart';
import 'package:lr_challenge/services/authentication_provider.dart';
import 'package:lr_challenge/services/firestore_provider.dart';
import 'package:lr_challenge/utils/adapt.dart';
import 'package:lr_challenge/utils/hexcolor.dart';
import 'package:lr_challenge/utils/images.dart';
import 'package:lr_challenge/utils/strings.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<Task> tasks = [];
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    fetchTasks();
    super.didChangeDependencies();
  }

  Future<void> fetchTasks() async {
    var list = await Provider.of<FirestoreProvider>(context, listen: false).userTasks();

    setState(() {
      tasks = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: AddTaskScreen(),
      drawer: Drawer(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(Adapt.px(12)),
              child: CustomPrimaryButton(
                  onPressed: () async {
                    await Provider.of<AuthenticationProvider>(context, listen: false).signOut();

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AuthenticationScreen()));
                  },
                  label: Strings.signOut),
            )
          ],
        ),
      ),
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
      body: Column(
        children: [
          GestureDetector(

            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchTaskScreen(tasks))),
            child: CustomTextField(
              enabled: false,
              searchBar: true,
              radius: 100,
              hint: Strings.search,
            ),
          ),
          TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            controller: tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).primaryColor.withOpacity(.3),
            tabs: [Tab(text: Strings.tasks), Tab(text: Strings.completed)],
            labelStyle: Theme.of(context).textTheme.headline2!.copyWith(fontSize: Adapt.px(14)),
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelStyle: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(fontSize: Adapt.px(14), color: Theme.of(context).primaryColor.withOpacity(.3)),
            indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor)),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: EdgeInsets.all(Adapt.px(16)),
                  child: StreamBuilder<FirestoreUser>(
                      initialData: FirestoreUser(email: '', uid: '', privacyPolicy: true, termsNConditions: true),
                      stream: Provider.of<FirestoreProvider>(context).currentUserStream(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Text("No Connections");
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          case ConnectionState.active:
                          case ConnectionState.done:
                            if (snapshot.hasData) {
                              if (snapshot.data!.tasks.isNotEmpty) {
                                return tasksView(snapshot.data!.tasks);
                              } else {
                                return noTasks();
                              }
                            } else
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ),
                              );
                        }
                      }),
                ),
              ),
            ),
          )
        ],
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
      height: Adapt().hp(100),
      child: TabBarView(controller: tabController, children: [
        Padding(
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
        taskList(tasks.where((element) => element.completed).toList(), completedTasks: true),
      ]),
    );
  }

  Column taskList(List<Task> tasks, {bool completedTasks = false}) {
    int priority = tasks.first.priority;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!completedTasks)
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

  Center noTasks() {
    return Center(
      child: Text(
        Strings.noTasks,
        style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: Adapt.px(16)),
        textAlign: TextAlign.center,
      ),
    );
  }
}
