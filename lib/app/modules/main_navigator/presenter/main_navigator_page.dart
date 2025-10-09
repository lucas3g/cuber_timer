import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:cuber_timer/app/core/data/clients/shared_preferences/adapters/shared_params.dart';
import 'package:cuber_timer/app/core/data/clients/shared_preferences/local_storage_interface.dart';
import 'package:cuber_timer/app/core/domain/entities/app_global.dart';
import 'package:cuber_timer/app/di/dependency_injection.dart';
import 'package:cuber_timer/app/modules/dashboard/presenter/controller/dashboard_controller.dart';
import 'package:cuber_timer/app/modules/dashboard/presenter/dashboard_page.dart';
import 'package:cuber_timer/app/modules/home/presenter/home_page.dart';
import 'package:cuber_timer/app/shared/components/database_migration_dialog.dart';
import 'package:cuber_timer/app/shared/translate/translate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainNavigatorPage extends StatefulWidget {
  const MainNavigatorPage({super.key});

  @override
  State<MainNavigatorPage> createState() => _MainNavigatorPageState();
}

class _MainNavigatorPageState extends State<MainNavigatorPage> {
  final DashboardController dashboardController = getIt<DashboardController>();
  final ILocalStorage _localStorage = getIt<ILocalStorage>();
  int _currentIndex = 0;

  List<Widget> get _pages {
    if (AppGlobal.instance.isAnnualPremium || kDebugMode) {
      return const [DashboardPage(), HomePage()];
    }
    return const [HomePage()];
  }

  List<BottomNavigationBarItem> get _navigationItems {
    final items = <BottomNavigationBarItem>[];

    if (AppGlobal.instance.isAnnualPremium || kDebugMode) {
      items.add(
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard),
          label: translate('main_navigator.dashboard'),
        ),
      );
    }

    items.add(
      BottomNavigationBarItem(
        icon: const Icon(Icons.list),
        label: translate('main_navigator.records'),
      ),
    );

    return items;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowMigrationDialog();
    });
  }

  Future<void> _checkAndShowMigrationDialog() async {
    const String migrationKey = 'database_migration_dialog_shown_v4.0.4';
    final bool? dialogShown = await _localStorage.getData(migrationKey);

    if (dialogShown == null || dialogShown == false) {
      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const DatabaseMigrationDialog(),
      );

      await _localStorage.setData(
        params: SharedParams(key: migrationKey, value: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: (AppGlobal.instance.isAnnualPremium || kDebugMode)
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) async {
                setState(() {
                  _currentIndex = index;
                });

                if (_currentIndex == 0) {
                  await dashboardController.loadAllRecords();
                }
              },
              backgroundColor: context.colorScheme.surface,
              selectedItemColor: context.colorScheme.primary,
              unselectedItemColor: context.colorScheme.onSurface.withOpacity(
                0.6,
              ),
              type: BottomNavigationBarType.fixed,
              elevation: 8,
              items: _navigationItems,
            )
          : null,
    );
  }
}
