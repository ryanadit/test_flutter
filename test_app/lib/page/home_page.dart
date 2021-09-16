import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  static const String route_name = "/home_page";

  HomePage({
    Key? key
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        height: _mediaHeight,
        width: _mediaWidth,
        child: Center(
          child: Text("Home Page"),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;

    return AppBar();
  }

}
