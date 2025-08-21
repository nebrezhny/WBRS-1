import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key, required this.navigationShell});

  /// Контейнер для навигационного бара.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
          items: _buildBottomNavBarItems,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex
        ),
      ),
    );
  }

  // Возвращает лист элементов для нижнего навигационного бара.
  List<BottomNavigationBarItem> get _buildBottomNavBarItems => [
    const BottomNavigationBarItem(
      icon: Icon(Icons.note),
      label: 'Заметки',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Любимые',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Профиль',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Профиль',
    ),
  ];
}
