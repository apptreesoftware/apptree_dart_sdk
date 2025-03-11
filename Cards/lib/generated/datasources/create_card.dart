import 'package:server/server.dart';

import 'package:Cards/generated/models/card.dart';
abstract class CreateCard extends SubmissionDataSource<Card> {
    @override
    Future<Card> submit(Request request) {
      return request;
    }
    }
