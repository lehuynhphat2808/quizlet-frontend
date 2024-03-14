import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:quizlet_frontend/pages/FolderPage.dart';
import 'package:quizlet_frontend/pages/HomePage.dart';
import 'package:quizlet_frontend/pages/TopicPage.dart';
import 'package:quizlet_frontend/pages/UserSettingPage.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int indexPage = 0;

  /// widget list
  final List<Widget> bottomBarPages = [
    const HomePage(),
    const TopicPage(),
    Container(),
    const FolderPage(),
    const UserSettingPage(),
  ];
  final List<String> topicString = [
    'Home',
    'Topic',
    '',
    'Folder',
    'User Setting'
  ];

  final List<IconData?> actionList = [
    null,
    Icons.add,
    null,
    Icons.add,
    null,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          topicString[indexPage],
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontFamily: 'Pacifico'),
        ),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: actionList[indexPage] != null
                ? Icon(actionList[indexPage])
                : null,
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: false,
              shadowElevation: 5,
              kBottomRadius: 28.0,
              // notchShader: const SweepGradient(
              //   startAngle: 0,
              //   endAngle: pi / 2,
              //   colors: [Colors.red, Colors.green, Colors.orange],
              //   tileMode: TileMode.mirror,
              // ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
              notchColor: Colors.white,

              /// restart app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: 500,
              durationInMilliSeconds: 300,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_outlined,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_outlined,
                    color: Colors.greenAccent,
                  ),
                  itemLabel: 'Page 1',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.topic_outlined,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.topic_outlined,
                    color: Colors.greenAccent,
                  ),
                  itemLabel: 'Page 2',
                ),

                ///svg example
                // BottomBarItem(
                //   inActiveItem: SvgPicture.asset(
                //     'assets/search_icon.svg',
                //     color: Colors.blueGrey,
                //   ),
                //   activeItem: SvgPicture.asset(
                //     'assets/search_icon.svg',
                //     color: Colors.white,
                //   ),
                //   itemLabel: 'Page 3',
                // ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.add_circle_outline,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.add,
                    color: Colors.greenAccent,
                  ),
                  itemLabel: 'Add button',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.folder_outlined,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.folder_outlined,
                    color: Colors.greenAccent,
                  ),
                  itemLabel: 'Page 3',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.person,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.person_outline,
                    color: Colors.greenAccent,
                  ),
                  itemLabel: 'Page 4',
                ),
              ],
              onTap: (index) {
                /// perform action on tab change and to update pages you can update pages without pages
                // log('current selected index $index');
                _pageController.jumpToPage(index);
                setState(() {
                  indexPage = index;
                });
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }
}
