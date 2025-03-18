import 'package:apptree_dart_sdk/apptree.dart';

import 'models.dart';

class MyCardsEndpoint extends CollectionEndpoint<MyCardsRequest, Card> {
  const MyCardsEndpoint() : super(id: 'MyCards');
}

class OwnersListEndpoint extends ListEndpoint<Owner> {
  const OwnersListEndpoint() : super(id: 'Owners');
}

class AttacksEndpoint
    extends CollectionEndpoint<CardRelationshipRequest, Attack> {
  const AttacksEndpoint() : super(id: 'Attacks');
}

class CardRelationshipRequest extends Request {
  final String cardId;

  CardRelationshipRequest({required this.cardId});
}

class CreateCardEndpoint
    extends SubmissionEndpoint<CardSubmissionRequest, Card> {
  const CreateCardEndpoint()
    : super(id: 'CreateCard', submissionType: SubmissionType.create);
}

class CreateOwnerEndpoint extends SubmissionEndpoint<EmptyRequest, Owner> {
  const CreateOwnerEndpoint()
    : super(id: 'CreateOwner', submissionType: SubmissionType.create);
}
