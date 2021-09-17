import 'package:flutter/material.dart';
import 'package:test_app/api/api_service.dart';
import 'package:test_app/helper/helper.dart';

class UsersNotifier with ChangeNotifier {

  Map? _usersResponse = {};

  setUsersResponseData(Map? value) {
    _usersResponse = {};
    _usersResponse = value;
    notifyListeners();
  }

  Map? getResponseUser() => _usersResponse;

  Future actionGetUsers({ String? page, String? perPage }) async {
    final response = await ApiService.getUsers(page: page, perPage: perPage);
    if(response != Helper.networkError && response != null) {
      if(response is Map) {
        setUsersResponseData(response);
        return response;
      }
      return ;
    }
    return ;
  }

  // TODO : CREATE USER

  Map? _userCreateResponse = {};

  setUserCreateResponseData(Map? value) {
    _userCreateResponse = {};
    _userCreateResponse = value;
    notifyListeners();
  }

  Map? getResponseUserCreate() => _userCreateResponse;

  Future actionUserCreate(dynamic bodyObject) async {
    final response = await ApiService.createUser(bodyObject);
    if(response != Helper.networkError && response != null) {
      if(response is Map) {
        setUserCreateResponseData(response);
        return response;
      }
      return ;
    }
    return ;
  }

  // TODO : CREATE DETAIL USER

  Map? _userDetailResponse = {};

  setUserDetailResponseData(Map? value) {
    _userDetailResponse = {};
    _userDetailResponse = value;
    notifyListeners();
  }

  Map? getResponseUserDetail() => _userDetailResponse;

  Future actionUserDetail(String? id) async {
    final response = await ApiService.getUserDetail(id);
    if(response != Helper.networkError && response != null) {
      if(response is Map) {
        setUserDetailResponseData(response);
        return response;
      }
      return ;
    }
    return ;
  }

  // TODO : UPDATE USER

  Map? _userUpdateResponse = {};

  setUserUpdateResponseData(Map? value) {
    _userUpdateResponse = {};
    _userUpdateResponse = value;
    notifyListeners();
  }

  Map? getResponseUserUpdate() => _userUpdateResponse;

  Future actionUserUpdate(dynamic bodyObject ,String? id) async {
    final response = await ApiService.updateUser(bodyObject,id);
    if(response != Helper.networkError && response != null) {
      if(response is Map) {
        setUserUpdateResponseData(response);
        return response;
      }
      return ;
    }
    return ;
  }


}