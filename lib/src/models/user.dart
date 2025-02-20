// User model populated with static fields

import 'package:apptree_dart_sdk/base.dart';
import 'package:apptree_dart_sdk/src/constants.dart';

class User extends Record {
  final StringField app = StringField(scope: FieldScope.user);
  final StringField appVersion = StringField(scope: FieldScope.user);
  final StringField appVersionNumber = StringField(scope: FieldScope.user);
  final StringField bundleId = StringField(scope: FieldScope.user);
  final StringField deviceOsType = StringField(scope: FieldScope.user);
  final StringField deviceType = StringField(scope: FieldScope.user);
  final StringField email = StringField(scope: FieldScope.user);
  final StringField externalId = StringField(scope: FieldScope.user);
  final StringField lastSeen = StringField(scope: FieldScope.user);
  final StringField online = StringField(scope: FieldScope.user);
  final StringField osVersion = StringField(scope: FieldScope.user);
  final StringField patchVersion = StringField(scope: FieldScope.user);
  final StringField status = StringField(scope: FieldScope.user);
  final StringField uid = StringField(scope: FieldScope.user);
  final StringField username = StringField(scope: FieldScope.user);

  User() {
    register();
  }
}



// TODO: Need Way of Dynamically Populate User Model with User Data and Debug Flags