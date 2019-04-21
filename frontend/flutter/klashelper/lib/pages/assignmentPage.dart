import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klashelper/models/user.dart';
import 'package:klashelper/models/workType.dart';
import 'package:klashelper/pages/assignmentFactory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'assignmentType.dart';
import 'package:klashelper/models/assignment.dart';
import 'package:klashelper/apis/assignmentApi.dart';
import 'package:klashelper/response/assignmentResponse.dart';
import 'package:klashelper/dao/assignmentDao.dart';

// ignore: must_be_immutable
class AssignmentPage extends StatefulWidget {
  AssignmentPage({Key key}) : super(key: key);
  User user = new User();
  AssignmentDao assignmentDao = new AssignmentDao();
  String semesterCode;
  @override
  AssignmentPageState createState() => new AssignmentPageState();
}

class AssignmentPageState extends State<AssignmentPage>
    with SingleTickerProviderStateMixin {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final List<Tab> assignmentTabs = <Tab>[
    new Tab(text: "진행 과제"),
    new Tab(text: "완료 과제"),
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

  int _currentTopIndex = 0;
  int _currentBottomIndex = 0;
  AssignmentFactory _todoAssignment;
  AssignmentFactory _completeAssignment;
  AssignmentFactory _lateAssignment;
  DateTime lastTimeBackPressed = DateTime.fromMicrosecondsSinceEpoch(0);

  Future<bool> _onWillPop() async {
    if (DateTime.now().difference(lastTimeBackPressed) < Duration(seconds: 2)) {
      SystemNavigator.pop();
      return Future.value(true);
    }
    //'뒤로' 버튼 한번 클릭 시 메시지
    //Toast.makeText(this, "'뒤로' 버튼을 한번 더 누르시면 앱이 종료됩니다.", Toast.LENGTH_SHORT).show();
    lastTimeBackPressed = DateTime.now();
    return Future.value(false);
  }

  Future<Null> _loadUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userInfo = prefs.getString("userInfoFile");
    if (userInfo != null && userInfo.isNotEmpty) {
      print("자동로그인");
      widget.user = User.fromJson(json.decode(userInfo));
      print(widget.user.toJson().toString());
    } else {
      print("유저 정보가 없어서 로그인 ㄱㄱ");
      Navigator.pushNamedAndRemoveUntil(context, '/loginPage', (_) => false);
    }
  }

  void _logout() async {
    // Causes the app to rebuild with the new _selectedChoice.
    print("logtout button");
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userInfoFile");
    Navigator.pushNamedAndRemoveUntil(context, '/loginPage', (_) => false);
  }

  _handleTopTabSelection() {
    setState(() {
      _currentTopIndex = _tabController.index;
      print("TopIndex " + _currentTopIndex.toString());
    });
  }

  void _handleBottomTabSelection(int index) {
    if(_currentBottomIndex != index){
      setState(() {
        _currentBottomIndex = index;
        print("BottomIndex " + _currentBottomIndex.toString());
        if(index <3){
          _settingAssignmentItems(WorkType.values[index]);//
        }
      });
    }
  }
  void _settingAssignmentItems(WorkType workType) {
    _todoAssignment = AssignmentFactory(AssignmentType.TODO);
    _todoAssignment.setWorkType(workType);
    _completeAssignment = AssignmentFactory(AssignmentType.COMPLETE);
    _completeAssignment.setWorkType(workType);
    _lateAssignment = AssignmentFactory(AssignmentType.LATE);
    _lateAssignment.setWorkType(workType);
  }
  Future<void> _onRefresh() async{
    _fetchAssignment();
    print("refresh");
  }
  Future<void> _fetchAssignment() async{
    AssignmentResponse assignmentResponse = await AssignmentApi().getAssignment(widget.user, widget.semesterCode);
    Iterable iterable = assignmentResponse.assignmentList;
    List<Assignment> assignments = iterable.map((model)=>Assignment.fromJson(model)).toList();
    widget.assignmentDao.tableName = 'a'+widget.user.id+'_'+widget.semesterCode;
    print("createTable");
    if(await widget.assignmentDao.setConnection()){
      widget.assignmentDao.createTable();
      print("insertAssignments");
      await widget.assignmentDao.insertAssignments(assignments);
      print("insertAssignments");
      List<Assignment> assignmentsUpdated = await widget.assignmentDao.getAllAssignment();
      print(assignmentsUpdated[1].toJson().toString());
    }
  }

  @override
  void initState() {
    super.initState();
    widget.semesterCode = "2018_20";
    _tabController =
        new TabController(vsync: this, length: assignmentTabs.length);
    _tabController.addListener(_handleTopTabSelection);
    _settingAssignmentItems(WorkType.HOMEWORK);
    _loadUser();
    //widget.assignmentDao.getConnection();

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 가장 간단하고 쉽게 사용할 수 있는 기본 탭바 컨트롤러. 탭바와 탭바뷰 연결.
    return WillPopScope(
      child: MaterialApp(
        home: DefaultTabController(
          length: assignmentTabs.length,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('과제 현황'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: _logout,
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _onRefresh,
                )
              ],
              bottom: TabBar(
                controller: _tabController,
                tabs: assignmentTabs,
                isScrollable: false, // 많으면 자동 스크롤 근데 false 면 사이즈가 딱 맞네?
              ),
            ),
            // 탭바와 연결된 탣바뷰 생성.
            // 탭바 코드와 똑같이 map 함수로 리스트 생성
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentBottomIndex,
              items: assignmentBottomsTabs,
              onTap: _handleBottomTabSelection,
              type: BottomNavigationBarType.fixed,
            ),
            body:
             TabBarView(
              controller: _tabController,
                children: <Widget>[
                  _todoAssignment,
                  _completeAssignment,
                  _lateAssignment,
              ],
            ),
          ),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

}
