import 'package:flutter/material.dart';
import 'page_v2.dart';

void main() {
  runApp(const MyApp());
}

/*
 * For demonstrate image rebuild problem
 * 
 * Problem:
 * Image in listview will rebuild when navigator push and pop pages
 * 
 * How to reproduce:
 * 1. add debug log in Image widget build function
 * 2. start this project, click listview item
 *   you will see every image in listview item call build function
 * 3. pop from blank page
 *   you will see every image in list view item call build function
 * 
 * What is wrong:
 * In common sence, image widget should not be rebuilt whenever data changed
 * 
 * What to expect:
 * Image widget only build once when they show.
*/
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BlankPage()),
    );
  }

  void navigateV2() {
    Navigator.push(
      context,
      MaterialPageRouteV2(builder: (context) => const BlankPage()),
    );
  }

  void bottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const BlankPage();
      },
    );
  }

  void overlay() {
    Navigator.of(context).push(TutorialOverlay());
  }

  void fade() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (c, a1, a2) => const BlankPage(),
        transitionsBuilder: (c, anim, a2, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 2000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("MyHomePage build");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              // navigate();
              // bottomSheet();
              // overlay();
              // fade();
              navigateV2();
            },
            title: Image.network(
                "https://flutter.cn/assets/images/cn/flutter-cn-logo.png"),
            trailing: const Icon(Icons.keyboard_arrow_right),
          );
        },
      ),
    );
  }
}

class BlankPage extends StatelessWidget {
  const BlankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("BlankPage build");
    return Scaffold(
        appBar: AppBar(
      title: const Text("Blank Page"),
    ));
  }
}

class TutorialOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(1.0);

  @override
  String get barrierLabel => "";

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return const BlankPage();
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
