import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klashelper/apis/semesterApi.dart';
import 'package:klashelper/models/semester.dart';
import 'package:klashelper/models/user.dart';
import 'package:klashelper/models/workType.dart';
import 'package:klashelper/pages/assignmentFactory.dart';
import 'package:klashelper/response/semesterResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'assignmentType.dart';
import 'package:klashelper/models/assignment.dart';
import 'package:klashelper/apis/assignmentApi.dart';
import 'package:klashelper/response/assignmentResponse.dart';
import 'package:klashelper/dao/assignmentDao.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ignore: must_be_immutable
class AssignmentPage extends StatefulWidget {
  AssignmentPage({Key key}) : super(key: key);

  @override
  AssignmentPageState createState() => new AssignmentPageState();
}

class AssignmentPageState extends State<AssignmentPage>
    with SingleTickerProviderStateMixin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final List<Tab> assignmentTabs = <Tab>[
    new Tab(text: "진행 과제"),
    new Tab(text: "지난 과제")
  ];
  final List<BottomNavigationBarItem> assignmentBottomsTabs =
      <BottomNavigationBarItem>[
    new BottomNavigationBarItem(
      icon: new Icon(Icons.assignment),
      title: new Text('과제'),
    ),
    new BottomNavigationBarItem(
      icon: new Icon(Icons.class_),
      title: new Text('온라인 강의'),
    ),
    new BottomNavigationBarItem(
      icon: new Icon(Icons.assignment_returned),
      title: new Text('강의 자료'),
    ),
    new BottomNavigationBarItem(
        icon: new Icon(Icons.menu), title: new Text('메뉴'))
  ];
  TabController _tabController;
  User _user = new User();
  AssignmentDao _assignmentDao = new AssignmentDao();
  String _semesterCode = "";
  List<Semester> _semesters = [];
  List<Assignment> _totalAssignments = [];
  bool hasData = false;
  int _currentTopIndex = 0;
  int _currentBottomIndex = 0;
  AssignmentFactory _todoAssignment;
  AssignmentFactory _lateAssignment;
  DateTime lastTimeBackPressed = DateTime.fromMicrosecondsSinceEpoch(0);

  Future<bool> _onWillPop() async {
    if (DateTime.now().difference(lastTimeBackPressed) < Duration(seconds: 2)) {
      SystemNavigator.pop();
      return Future.value(true);
    }
    //Toast.makeText(this, "'뒤로' 버튼을 한번 더 누르시면 앱이 종료됩니다.", Toast.LENGTH_SHORT).show();
    lastTimeBackPressed = DateTime.now();
    return Future.value(false);
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userInfoFile");
    Navigator.pushNamedAndRemoveUntil(context, '/loginPage', (_) => false);
  }

  void _handleTopTabSelection() {
    setState(() {
      _currentTopIndex = _tabController.index;
      print("TopIndex " + _currentTopIndex.toString());
    });
  }

  void _handleBottomTabSelection(int index) {
    if (_currentBottomIndex != index) {
      setState(() {
        _currentBottomIndex = index;
        if (index < 3) {
          _settingAssignmentItems(WorkType.values[index]); //
        }
        else{
          _showNotification();
        }
      });
    }
  }

  Future<void> _onRefresh() async {
    await _fetchAssignment();
  }

  Future<void> _fetchAssignment() async {
    AssignmentResponse assignmentResponse =
        await AssignmentApi().getAssignment(_user, _semesterCode);
    Iterable iterable = assignmentResponse.assignmentList;
    List<Assignment> assignments =
        iterable.map((model) => Assignment.fromJson(model)).toList();
    await _assignmentDao.insertAssignments(assignments);
    _totalAssignments =
        await _assignmentDao.getAllAssignmentBySemesterCode(_semesterCode);
    _settingAssignmentItems(WorkType.values[_currentBottomIndex]);
  }

  _setSemesterCode(int index) {
    setState(() {
      _semesterCode = _semesters[index].semesterCode;
    });
  }

  Future<void> _setSemesters() async {
    _semesters.clear();
    SemesterResponse semesterResponse = await SemesterApi().getSemester(_user);
    setState(() {
      List<String> semesterCodes = semesterResponse.semesters.split(",");
      for (final semesterCode in semesterCodes) {
        Semester semester = new Semester();
        semester.semesterCode = semesterCode;
        semester.semesterName = _getSemesterName(semesterCode);
        _semesters.add(semester);
      }
    });
  }

  String _getSemesterName(String semesterCode) {
    List<String> temp = semesterCode.split("_");
    switch (temp[1]) {
      case "10":
        temp[1] = "1학기";
        break;
      case "15":
        temp[1] = "여름학기";
        break;
      case "20":
        temp[1] = "2학기";
        break;
      case "25":
        temp[1] = "겨울학기";
        break;
      default:
        break;
    }
    return (temp[0] + "년 " + temp[1]);
  }

  void _initData() async {
    if (await _loadUser()) {
      String tableName = "assignment_" + _user.id;
      await _assignmentDao.setDatabase(tableName);
      await _setSemesters();
      _setSemesterCode(0);
      await _loadData();
    }
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
  }
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    };
    showDialog(context: context,builder: (_)=> new AlertDialog(
      title: new Text('notification'),
      content: new Text("$payload"),
    ));
    //Navigator.pushNamedAndRemoveUntil(
    //            context, '/assignmentPage', (_) => false);
  }
  _showNotification() async{
    var scheduledNotificationDateTime =  new DateTime.now().add(new Duration(seconds: 5));
    var android = new AndroidNotificationDetails('channelId', 'channelName', 'channelDescription');
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, "new video is out", "flutter noti local body", platform,payload: "test payload ");
    await flutterLocalNotificationsPlugin.schedule(0, "5초 뒤 알람 is out", "flutter noti local body",scheduledNotificationDateTime, platform,payload: "test payload ");
    scheduledNotificationDateTime =  new DateTime.now().add(new Duration(seconds: 10));
    await flutterLocalNotificationsPlugin.schedule(1, "10초 뒤 알람 is out", "flutter noti local body",scheduledNotificationDateTime, platform,payload: "test payload ");


  }

  Future<bool> _loadUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userInfo = prefs.getString("userInfoFile");
    if (userInfo != null && userInfo.isNotEmpty) {
      _user = User.fromJson(json.decode(userInfo));
      return true;
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/loginPage', (_) => false);
      return false;
    }
  }

  Future<void> _loadData() async {
    _totalAssignments =
        await _assignmentDao.getAllAssignmentBySemesterCode(_semesterCode);
    _settingAssignmentItems(WorkType.values[_currentBottomIndex]);
  }

  void _settingAssignmentItems(WorkType workType) {
    setState(() {
      _todoAssignment = AssignmentFactory(AssignmentType.TODO);
      _todoAssignment.setWorkType(workType);
      _lateAssignment = AssignmentFactory(AssignmentType.LATE);
      _lateAssignment.setWorkType(workType);
      _classifyAssignment(workType);
    });
  }

  void _classifyAssignment(WorkType workType) {
    List<Assignment> _tempTodoAssignments = [];
    List<Assignment> _templateAssignment = [];
    for (final assignment in _totalAssignments) {
      if (assignment.workType == workType && assignment.flag == 1) {
        var now = DateTime.now();
        String workFinishTime = assignment.workFinishTime;
        if (workFinishTime != "0") {
          workFinishTime = (workFinishTime.length < 11)
              ? workFinishTime + " 24:00"
              : workFinishTime;
          workFinishTime = workFinishTime.replaceAll("(RE)", "");
          var finishDateTime = DateTime.parse(workFinishTime);
          if (now.isAfter(finishDateTime)) {
            _templateAssignment.add(assignment);
          } else {
            _tempTodoAssignments.add(assignment);
          }
        } else {
          _tempTodoAssignments.add(assignment);
        }
      }
    }
    _todoAssignment.setAssignments(_tempTodoAssignments);
    _lateAssignment.setAssignments(_templateAssignment);
  }

  @override
  void initState() {
    super.initState();
    _settingAssignmentItems(WorkType.HOMEWORK);
    _initData();
    _tabController =
        new TabController(vsync: this, length: assignmentTabs.length);
    _tabController.addListener(_handleTopTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  static const _primaryColor = const Color(0xFF0D326F);
  // const Color(0xFF151026); 검정 #AD1D19 다홍? #A40F16 기본 빨강  #dc143c크림슨 0D326F 남색 
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: _primaryColor,
        ),
        home: DefaultTabController(
          length: assignmentTabs.length,
          child: Scaffold(
            key: _scaffoldKey,
            drawer: _buildDrawer(),
            appBar: AppBar(
              title: Text("과제 현황"),
              automaticallyImplyLeading: false,
              leading: IconButton(
                  icon: new Icon(Icons.dehaze),
                  onPressed: () => _scaffoldKey.currentState.openDrawer()),
              actions: <Widget>[],
              bottom: TabBar(
                indicatorColor:  Color(0xFFA40F16),
                controller: _tabController,
                tabs: assignmentTabs,
                isScrollable: false, // 많으면 자동 스크롤 근데 false 면 사이즈가 딱 맞네?
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentBottomIndex,
              items: assignmentBottomsTabs,
              onTap: _handleBottomTabSelection,
              type: BottomNavigationBarType.fixed,
            ),
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                RefreshIndicator(
                  child: _todoAssignment,
                  onRefresh: _onRefresh,
                ),
                RefreshIndicator(
                  child: _lateAssignment,
                  onRefresh: _onRefresh,
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  SizedBox _buildDrawer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.70, //20.0,
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(_user.id),
              accountEmail: Text("ashishrawat2911@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  _user.id.substring(2, 4),
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ExpansionTile(
              title: Text("수강 학기"),
              children: <Widget>[
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _semesters.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading:
                            (_semesters[index].semesterCode == _semesterCode)
                                ? Icon(Icons.check)
                                : Text(""),
                        title: Text(_semesters[index].semesterName),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          _setSemesterCode(index);
                          _loadData();
                          Navigator.pop(context);
                        },
                      );
                    }),
              ],
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.trash),
              title: Text("휴지통"),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("설정"),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.signOutAlt),
              title: Text("로그아웃"),
              //onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
