import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:test_app/helper/helper.dart';
import 'package:test_app/helper/helper_widget.dart';
import 'package:test_app/model/users/data_users_model.dart';
import 'package:test_app/notifier/users_notifier.dart';
import 'package:test_app/page/user_page/create_user_page.dart';
import 'package:test_app/page/user_page/detail_user_page.dart';
import 'package:test_app/viewmodel/users_view_model.dart';

class HomePage extends StatefulWidget {

  static const String route_name = "/home_page";

  HomePage({
    Key? key
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PagingController<int, DataUsersModel>? _pagingController = PagingController(firstPageKey: 1);
  UsersNotifier? _usersNotifier;
  int? _perPage = 10;

  Future<void> _fetchDataUsers(int pageKey) async {
    _usersNotifier = Provider.of(context, listen: false);
    UsersViewModel? _usersViewModel = UsersViewModel();

    try{
      // TODO INITIAL PAGE
      final page = (pageKey / _perPage!).floor()+1;

      final response = await _usersNotifier?.actionGetUsers(
          page: page.toString(),
          perPage: _perPage.toString()
      );
      _usersViewModel.setDataUsers(response);
      var newItems = _usersViewModel.getDataUser?.data;
      final isLastPage = newItems!.length < _perPage!;
      if(isLastPage){
        _pagingController?.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController?.appendPage(newItems, nextPageKey);
      }

    } catch(error) {
      print(error);
      _pagingController?.error = error;
    }

  }

  Future<void> _refreshData() async {
    Future.sync(
          () => _pagingController?.refresh(),
    );
  }

  _alertLogout(BuildContext context) async {
    final title = "Konfirmasi";
    final message = "Apakah anda yakin ingin logout?";

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if(Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height/75
              ),
              child: Text("$title",
                style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.height/45,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepOrange
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("$message",
                    style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.height/50,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('OK',
                  style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height/55,
                      color: Colors.teal
                  ),),
                onPressed: () async {
                  await Helper.logoutSession(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('Batal',
                  style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height/55,
                      color: Colors.blueGrey
                  ),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height/75
              ),
              child: Text(title,
                style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.height/45,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepOrange
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message,
                    style: GoogleFonts.roboto(
                        fontSize: MediaQuery.of(context).size.height/50,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK',
                  style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height/55,
                      color: Colors.teal
                  ),),
                onPressed: () async {
                  await Helper.logoutSession(context);
                },
              ),
              TextButton(
                child: Text('Batal',
                  style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.height/55,
                      color: Colors.blueGrey
                  ),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }

      },
    );
  }

  void _goToDetailUser(int? id) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailUserPage(
        id: id,
      ))
    ).then((value) async => await _refreshData() );
  }

  @override
  void initState() {
    // TODO: implement initState
    _pagingController?.addPageRequestListener((pageKey) {
      _fetchDataUsers(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pagingController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBodyContent(),
      floatingActionButton: _buildFloatingButton(),
    );
  }

  AppBar _buildAppBar() {
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;
    return AppBar(
      title: Text("Employees",
        style: GoogleFonts.poppins(
          fontSize: _mediaHeight/40
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              _alertLogout(context);
            },
            icon: Icon(
              Icons.logout
            )
        ),
      ],
    );
  }

  Widget _buildBodyContent() {
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;
    return Container(
      height: _mediaHeight,
      width: _mediaWidth,
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: PagedListView<int?, DataUsersModel>(
          pagingController: _pagingController!,
          builderDelegate: PagedChildBuilderDelegate<DataUsersModel>(
            animateTransitions: true,
            transitionDuration: const Duration(milliseconds: 500),
            itemBuilder: (context, item, index)  => Container(
              child: _buildListItem(item.firstName, item.email, item.avatar, item.id),
            )
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(String? firstName, String? email, String? urlAvatar, int? id) {
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;

    return Container(
      child: InkWell(
        onTap: () {
          _goToDetailUser(id);
        },
        child: Row(
          children: [
            Container(
              width: _mediaWidth/1.15,
              child: ListTile(
                title: Text("$firstName",
                  style: GoogleFonts.poppins(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: _mediaHeight/45),
                ),
                subtitle: Text("$email",
                  style: GoogleFonts.poppins(
                      color: Colors.teal,
                      fontSize: _mediaHeight/60
                  ),
                ),
                leading: Builder(
                  builder: (context) {
                    if(urlAvatar != "" && urlAvatar != null) {
                      return Container(
                        width: _mediaHeight/19,
                        height: _mediaHeight/19,
                        margin: EdgeInsets.symmetric(
                            horizontal: _mediaWidth/70
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: Uri.encodeFull(urlAvatar),
                            fit: BoxFit.cover,
                            errorWidget: (context, url, build) => WidgetHelper.buildIconError(context),
                            placeholder: (context, url) => Center(
                              child: WidgetHelper.buildLoading(context),
                            ),
                          ),
                        ),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle
                      ),
                      padding: EdgeInsets.all(_mediaWidth/60),
                      margin: EdgeInsets.symmetric(
                          horizontal: _mediaWidth/80
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.tealAccent.shade700,
                        size: _mediaWidth/22.5,
                      ),
                    );
                  },
                ),
              ),
            ),
            Flexible(
              child: Container(
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                  size: _mediaWidth/20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingButton() {
    final _mediaHeight = MediaQuery.of(context).size.height;

    return FloatingActionButton(
      backgroundColor: Colors.blueAccent,
      onPressed: () {
        Navigator.of(context).pushNamed(CreateUserPage.route_name).then((value) async => _refreshData());
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: _mediaHeight/35,
      ),
    );
  }



}
