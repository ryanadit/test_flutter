import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_app/helper/helper.dart';
import 'package:test_app/helper/helper_widget.dart';
import 'package:test_app/notifier/users_notifier.dart';
import 'package:test_app/page/user_page/create_user_page.dart';
import 'package:test_app/viewmodel/user_detail_view_model.dart';

class DetailUserPage extends StatefulWidget {

  static const String route_name = "/detail_user_page";

  final int? id;

  DetailUserPage({
    Key? key,
    this.id
  }) : super(key: key);

  @override
  _DetailUserPageState createState() => _DetailUserPageState(
    id: id
  );
}

class _DetailUserPageState extends State<DetailUserPage> {

  int? id;
  _DetailUserPageState({this.id});

  UsersNotifier? _usersNotifier;
  bool? _loadData = false;
  UserDetailViewModel? _userDetailViewModel = UserDetailViewModel();

  Future<void> _initDataUserDetail() async {
    _usersNotifier = Provider.of(context, listen: false);
    final response = await _usersNotifier?.actionUserDetail(id.toString());
    if(mounted) setState(() {
      if(response != null) {
        print(response);
        _userDetailViewModel?.setDataUser(_usersNotifier?.getResponseUserDetail());

        _loadData = true;
      }
    });


  }

  Future<void> _goToEditUser() async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) =>
            CreateUserPage(mode: Helper.modeUpdate,
              usersModel: _userDetailViewModel?.getDataUser!.data,
            ))
    ).then((value) async {
      setState(() {
        _loadData = false;
      });
      await _initDataUserDetail();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initDataUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent(){
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;
    return Container(
      width: _mediaWidth,
      height: _mediaHeight,
      child: Builder(
        builder: (context) {
          if(_loadData!) return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeaderWithImage(),
                _buildBodyInfo(),
              ],
            ),
          );
          return Center(
            child: WidgetHelper.buildLoading(context),
          );
        },
      ),
    );
  }


  Widget _buildHeaderWithImage() {
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;

    final _colorIcon = Colors.white;

    Widget? _header = SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Builder(
              builder: (context) {
                if(Platform.isIOS) {
                  return Icon(
                      Icons.arrow_back_ios_rounded,
                    color: _colorIcon,
                  );
                }
                return Icon(
                    Icons.arrow_back_rounded,
                  color: _colorIcon,
                );
              },
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            onPressed: _goToEditUser,
            icon: Container(
              child: Icon(
                  Icons.edit_outlined,
                color: _colorIcon,
              ),
            ),
          )
        ],
      ),
    ) ;

    Widget? _imageUser = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Builder(
            builder: (context) {
              if(_userDetailViewModel?.getDataUser!.data!.avatar != "" && _userDetailViewModel?.getDataUser!.data!.avatar != null) {
                return Container(
                  width: _mediaHeight/4,
                  height: _mediaHeight/4,
                  margin: EdgeInsets.symmetric(
                      horizontal: _mediaWidth/70
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: Uri.encodeFull(_userDetailViewModel!.getDataUser!.data!.avatar.toString()),
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
                  size: _mediaWidth/4,
                ),
              );
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: _mediaHeight/80
            ),
            child: Text("${_userDetailViewModel?.getDataUser!.data!.firstName}",
              style: GoogleFonts.poppins(
                fontSize: _mediaHeight/20,
                color: _colorIcon,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        ],
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: _mediaWidth/50
      ),
      color: Colors.blue,
      height: _mediaHeight/2,
      width: _mediaWidth,
      child: Column(
        children: [
          _header,
          Expanded(
            child: _imageUser,
          )
        ],
      ),
    );
  }

  Widget _buildBodyInfo() {
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: _mediaHeight/200
      ),
      child: Column(
        children: [
          _buildListTileCard("Full Name" , "${_userDetailViewModel?.getDataUser!.data!.firstName} ${_userDetailViewModel?.getDataUser!.data!.lastName}", Icons.person_outline_rounded),
          _buildListTileCard("Email" , "${_userDetailViewModel?.getDataUser!.data!.email}", Icons.email_outlined),
          _buildListTileCard("Description" , "${_userDetailViewModel?.getDataUser!.support!.text}", Icons.add_business_outlined),
        ],
      ),
    );
  }

  Widget _buildListTileCard(String? firstName, String? email, IconData? icons) {
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Card(
        child: ListTile(
          title: Text("$firstName",
            style: GoogleFonts.poppins(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: _mediaHeight/40),
          ),
          subtitle: Text("$email",
            style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontSize: _mediaHeight/50
            ),
          ),
          leading: Container(
            padding: EdgeInsets.all(_mediaWidth/60),
            margin: EdgeInsets.symmetric(
                horizontal: _mediaWidth/80
            ),
            child: Icon(
              icons,
              color: Colors.tealAccent.shade700,
              size: _mediaWidth/15,
            ),
          ),
        ),
      ),
    );
  }


}
