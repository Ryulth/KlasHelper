import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klashelper/models/user.dart';
import 'package:klashelper/pages/assignmentFactory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginPages.dart';
class AssignmentPage extends StatefulWidget {
  AssignmentPage({Key key}) : super(key: key);
  User user = new User();
  @override
  AssignmentPageState createState() => new AssignmentPageState();
}

class AssignmentPageState extends State<AssignmentPage>
    with SingleTickerProviderStateMixin {
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
        icon: new Icon(Icons.menu),
        title: new Text('메뉴'))
  ];
  TabController _tabController;
//  AssignmentListView _assignmentListView;
//  AssignmentFactory _assignmentFactory;
  int _currentTopIndex = 0;
  int _currentBottomIndex = 0;
  Widget _todoAssignment;
  Widget _completeAssignment;
  Widget _lateAssignment;
  DateTime lastTimeBackPressed = DateTime.fromMicrosecondsSinceEpoch(0);

  Future<bool> _onWillPop() async {
     if (DateTime.now().difference(lastTimeBackPressed) < Duration(seconds: 2)) {
            print("t");
            Navigator.pop(context);
            return Future.value(true);
        }
        //'뒤로' 버튼 한번 클릭 시 메시지
        //Toast.makeText(this, "'뒤로' 버튼을 한번 더 누르시면 앱이 종료됩니다.", Toast.LENGTH_SHORT).show();
        lastTimeBackPressed = DateTime.now();
        print("false");
        return Future.value(false);
  }
  Future<Null> _loadUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userInfo = prefs.getString("userInfoFile");
    if (userInfo != null && userInfo.isNotEmpty) {
      
    }
    else {
      Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return LoginPage(); 
          }));
    }
  }
  void _logout() {
    // Causes the app to rebuild with the new _selectedChoice.
    print("logtout button");
    Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return LoginPage(); 
    }));
  }
  @override
  void initState() {
    super.initState();
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String userInfo = prefs.getString("userInfoFile");
    _tabController =
        new TabController(vsync: this, length: assignmentTabs.length);
      _tabController.addListener(_handleTopTabSelection);
      _settingListItems();
    _loadUser();    
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
              )
            ],
            bottom: TabBar(
              // map 함수는 리스트의 요소를 하나씩 전달한 결과로
              // Iterable 객체를 생성하기 때문에 toList 함수로 변환
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
          body: TabBarView(
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

  _handleTopTabSelection() {
    setState(() {
      _currentTopIndex = _tabController.index;
      print("TopIndex " + _currentTopIndex.toString());
    });
  }

  void _handleBottomTabSelection(int index) {
    setState(() {
      _currentBottomIndex = index;
      print("BottomIndex " + _currentBottomIndex.toString());
    });
  }
  void _settingListItems(){
    _todoAssignment =AssignmentFactory(AssignmentType.TODO);
    _completeAssignment = AssignmentFactory(AssignmentType.COMPLETE);
    _lateAssignment = AssignmentFactory(AssignmentType.LATE);
  }
}
