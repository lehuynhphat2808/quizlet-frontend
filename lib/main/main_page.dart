import 'dart:async';
import 'dart:ui';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizlet_frontend/folder/folder_page.dart';
import 'package:quizlet_frontend/home/home_page.dart';
import 'package:quizlet_frontend/user/user_settingPage.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:quizlet_frontend/utilities/router_manager.dart';

import '../topic/topic_list_page.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late GlobalKey<FolderPageState> folderPageKey;
  late List<Widget> bottomBarPages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    folderPageKey = GlobalKey<FolderPageState>();
    bottomBarPages = [
      const HomePage(),
      const TopicListPage(),
      FolderPage(
        key: folderPageKey,
      ),
      const UserSettingPage(),
    ];
  }

  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _indexPage = 0;

  final List<IconData> iconList = [
    Icons.home,
    Icons.topic,
    Icons.folder_outlined,
    Icons.person
  ];

  final List<AppBar?> appBarList = [
    AppBar(
      title: const Text(
        "Hone",
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Pacifico'),
      ),
      centerTitle: true,
      elevation: 4,
      shadowColor: Colors.grey,
    ),
    AppBar(
      title: const Text(
        "Topic",
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Pacifico'),
      ),
      centerTitle: true,
      elevation: 4,
      shadowColor: Colors.grey,
    ),
    AppBar(
      title: const Text(
        "Folder",
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Pacifico'),
      ),
      centerTitle: true,
      elevation: 4,
      shadowColor: Colors.grey,
    ),
    AppBar(
      title: const Text(
        "User Setting",
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Pacifico'),
      ),
      centerTitle: true,
      elevation: 4,
      shadowColor: Colors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    print('Build main');
    return Scaffold(
      appBar: appBarList[_indexPage],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        onPressed: () {
          _showAddBottomPopup();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedBottomNavigationBar.builder(
              height: 80,
              tabBuilder: (int index, bool isActive) {
                return Icon(
                  iconList[index],
                  size: 24,
                  color: isActive ? Colors.black : Colors.grey,
                );
              },
              activeIndex: _indexPage,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.softEdge,
              leftCornerRadius: 24,
              rightCornerRadius: 24,
              onTap: (index) => _changePage(index),
              itemCount: iconList.length,
              //other params
            )
          : null,
    );
  }

  void _showAddBottomPopup() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(
                              10, 10), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(8))),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Topic',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Pacifico",
                              fontSize: 24),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, Routes.updateTopicPage);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(
                              10, 10), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(8))),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Folder',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Pacifico",
                              fontSize: 24),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await Navigator.pushNamed(
                            context, Routes.updateFolderPage);
                        folderPageKey.currentState!.reset();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _changePage(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _indexPage = index;
    });
  }

  void _showAddTopicBottomPopup() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: Colors.amber,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    child: const Text('Topic'),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.updateTopicPage);
                    },
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    child: const Text('Folder'),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.updateTopicPage);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
