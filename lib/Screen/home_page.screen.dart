import "package:flutter/material.dart";
import "package:flutter_app/Model/user.model.dart";
import "package:flutter_app/Screen/conversation.screen.dart";
import "package:flutter_app/Screen/settings.screen.dart";
import "package:flutter_app/Screen/users.screen.dart";

import "package:persistent_bottom_nav_bar/persistent-tab-view.dart";

class HomePage extends StatefulWidget {
  const HomePage({required this.loggedInUser, final Key? key}) : super(key: key);
  final UserModel loggedInUser;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PersistentTabController _controller =
      PersistentTabController();

  late double height = MediaQuery.of(context).size.width;

  List<Widget> _buildScreens() => [
      UsersScreen(loggedInUser: widget.loggedInUser),
      ConversationScreen(loggedInUser: widget.loggedInUser),
      SettingScreen(user: widget.loggedInUser),
    ];

  @override
  void initState() {
    super.initState();
  }

  List<PersistentBottomNavBarItem> _navBarsItems() => [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.people),
        title: "Users",
        activeColorPrimary: Colors.cyan,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.textsms),
        title: "Conversations",
        activeColorPrimary: Colors.deepOrange,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        title: "Settings",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];

  @override
  Widget build(final BuildContext context) => PersistentTabView(
      context,
      backgroundColor: const Color(0xFF303030),
      controller: _controller,
      items: _navBarsItems(),
      screens: _buildScreens(),
      navBarStyle:
          NavBarStyle.style3, // Choose the nav bar style with this property
      onItemSelected: print,
    );
}
