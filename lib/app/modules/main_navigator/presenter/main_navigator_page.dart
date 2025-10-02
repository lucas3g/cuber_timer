import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:cuber_timer/app/modules/dashboard/presenter/dashboard_page.dart';
import 'package:cuber_timer/app/modules/home/presenter/home_page.dart';
import 'package:cuber_timer/app/shared/translate/translate.dart';
import 'package:flutter/material.dart';

class MainNavigatorPage extends StatefulWidget {
  const MainNavigatorPage({super.key});

  @override
  State<MainNavigatorPage> createState() => _MainNavigatorPageState();
}

class _MainNavigatorPageState extends State<MainNavigatorPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: context.myTheme.surface,
        selectedItemColor: context.myTheme.primary,
        unselectedItemColor: context.myTheme.onSurface.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: translate('main_navigator.dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: translate('main_navigator.records'),
          ),
        ],
      ),
    );
  }
}
