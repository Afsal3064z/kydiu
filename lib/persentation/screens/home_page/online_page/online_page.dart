import 'package:flutter/material.dart';

class OnlinePage extends StatefulWidget {
  const OnlinePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<OnlinePage> {
  int selectedTab =
      1; // 1 represents the first button, 2 represents the second button

  void _setSelectedTab(int tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  Widget _buildBodyContent() {
    if (selectedTab == 1) {
      return Container(
        color: Colors.blue,
        child: const Center(
          child: Text(
            'Body Content 1',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.green,
        child: const Center(
          child: Text(
            'Body Content 2',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome back user'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => _setSelectedTab(1),
                child: const Text('Tab 1'),
              ),
              ElevatedButton(
                onPressed: () => _setSelectedTab(2),
                child: const Text('Tab 2'),
              ),
            ],
          ),
          Expanded(child: _buildBodyContent()),
        ],
      ),
    );
  }
}
