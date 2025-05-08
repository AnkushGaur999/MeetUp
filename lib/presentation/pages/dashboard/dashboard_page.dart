import 'package:flutter/material.dart';
import 'package:meet_up/presentation/pages/dashboard/buddies/buddies_page.dart';
import 'package:meet_up/presentation/pages/dashboard/chats/chats_page.dart';
import 'package:meet_up/presentation/pages/dashboard/settings/settings_page.dart';
import 'package:meet_up/presentation/pages/dashboard/status/status_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _pages = [
    const ChatsPage(),
    const StatusPage(),
    const BuddiesPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _tabClick(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 90,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(label: "Chats", icon: Icon(Icons.chat)),

              BottomNavigationBarItem(
                label: "Status",
                icon: Icon(Icons.update),
              ),

              BottomNavigationBarItem(
                label: "Buddies",
                icon: Icon(Icons.family_restroom),
              ),

              BottomNavigationBarItem(
                label: "Settings",
                icon: Icon(Icons.settings),
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _tabClick,
            selectedItemColor: Colors.blue.shade900,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
          ),
        ),
      ),
    );
  }
}
