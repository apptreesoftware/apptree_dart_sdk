// User model populated with static fields

import 'package:apptree_dart_sdk/apptree.dart';
import 'package:apptree_dart_sdk/src/constants.dart';

class User extends Record {
  @PkField()
  final StringField uid = StringField();
  final StringField app = StringField();
  final StringField appVersion = StringField();
  final StringField appVersionNumber = StringField();
  final StringField bundleId = StringField();
  final StringField deviceOsType = StringField();
  final StringField deviceType = StringField();
  final StringField email = StringField();
  final StringField externalId = StringField();
  final StringField lastSeen = StringField();
  final StringField online = StringField();
  final StringField osVersion = StringField();
  final StringField patchVersion = StringField();
  final StringField status = StringField();
  final StringField username = StringField();
  Record? data;

  User({this.data}) : super() {
    register();
  }

  @override
  FieldScope get scope {
    return FieldScope.user;
  }
}

// TODO: Need Way of Dynamically Populate User Model with User Data and Debug Flags
