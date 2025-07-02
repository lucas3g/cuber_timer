import 'package:flutter/material.dart';

class ListScramblesPage extends StatefulWidget {
  final PageController pageController;
  final List<Widget> pages;

  const ListScramblesPage({
    super.key,
    required this.pages,
    required this.pageController,
  });

  @override
  State<ListScramblesPage> createState() => _ListScramblesPageState();
}

class _ListScramblesPageState extends State<ListScramblesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Scrambles'),
        centerTitle: true,
      ),
      body: Expanded(
        child: PageView.builder(
          controller: widget.pageController,
          itemCount: widget.pages.length,
          itemBuilder: (context, index) {
            return widget.pages[index];
          },
        ),
      ),
    );
  }
}
