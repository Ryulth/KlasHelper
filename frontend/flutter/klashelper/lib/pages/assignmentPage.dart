import 'package:flutter/material.dart';
import 'package:klashelper/pages/assignmentFactory.dart';
class AssignmentPage extends StatefulWidget {
  AssignmentPage({Key key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
//    _assignmentListView = new AssignmentListView();
    _tabController =
        new TabController(vsync: this, length: assignmentTabs.length);
    _tabController.addListener(_handleTopTabSelection);
    _settingListItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 가장 간단하고 쉽게 사용할 수 있는 기본 탭바 컨트롤러. 탭바와 탭바뷰 연결.
    return MaterialApp(
      home: DefaultTabController(
        length: assignmentTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text('과제 현황'),
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
