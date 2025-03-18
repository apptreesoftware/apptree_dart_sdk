import 'package:apptree_dart_sdk/apptree.dart';

import 'models.dart';

class MyCardsEndpoint extends CollectionEndpoint<MyCardsRequest, Card> {
  const MyCardsEndpoint() : super(id: 'MyCards');
}

class OwnersListEndpoint extends ListEndpoint<Owner> {
  const OwnersListEndpoint() : super(id: 'Owners');
}

class CreateCardEndpoint
    extends SubmissionEndpoint<CardSubmissionRequest, Card> {
  const CreateCardEndpoint()
    : super(id: 'CreateCard', submissionType: SubmissionType.create);
}

class UpdateCardEndpoint
    extends SubmissionEndpoint<CardSubmissionRequest, Card> {
  const UpdateCardEndpoint()
    : super(id: 'UpdateCard', submissionType: SubmissionType.update);
}

class CreateOwnerEndpoint extends SubmissionEndpoint<EmptyRequest, Owner> {
  const CreateOwnerEndpoint()
    : super(id: 'CreateOwner', submissionType: SubmissionType.create);
}

class UpdateOwnerEndpoint extends SubmissionEndpoint<EmptyRequest, Owner> {
  const UpdateOwnerEndpoint()
    : super(id: 'UpdateOwner', submissionType: SubmissionType.update);
}
