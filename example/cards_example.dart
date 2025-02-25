import 'package:apptree_dart_sdk/base.dart';
import 'package:apptree_dart_sdk/src/models/expression.dart';
class Card extends Record {
  final StringField cardId = StringField();
  final StringField name = StringField();
  final StringField owner = StringField();
  final StringField description = StringField();
  final StringField rarity = StringField();
  final StringField type = StringField();
  final Attack attacks = Attack();
}

class MyCardsRequest extends Request {
  final StringField owner = User().username;
}

class MyCardsEndpoint extends CollectionEndpoint<MyCardsRequest, Card> {
  MyCardsEndpoint()
      : super(
            name: 'MyCards',
            dataSource: DataSource(url: 'https://corey.apptree.dev/MyCards', collection: 'my_cards', dataSource: 'my_cards'),
            request: MyCardsRequest(),
            record: Card());
}

class Attack extends Record {
  final StringField attackId = StringField();
  final StringField name = StringField();
  final IntField damage = IntField();
}

class CardRecordListBuilder extends RecordListBuilder {
  @override
  final Card record = Card();

  CardRecordListBuilder()
      : super(
            id: 'MyCardsRecordList', record: Card(), endpoint: MyCardsEndpoint());

  @override
  RecordList build() {
    return RecordList(
        id: id,
        collectionEndpoint: MyCardsEndpoint(),
        template: Template(
            id: 'workbench',
            values: Values(values: {
              'title': Value(value: record.cardId),
              'subtitle': Value(value: record.name),
            })),
        noResultsText: 'No results',
        showDivider: true,
        topAccessoryViews: [],
        onItemSelected: OnItemSelected(builder: CardFormBuilder()));
  }
}

class CardFormBuilder extends FormBuilder {
  @override
  final Card record = Card();

  CardFormBuilder() : super(id: 'CardsUpdateForm', record: Card());

  @override
  Form build() {
    return Form(
        id: id,
        toolbar: Toolbar(items: [
          ToolbarItem(title: 'Save', actions: [
            SubmitFormAction(
                url: 'https://corey.apptree.dev/UpdateCard',
                title: 'Updating Card')
          ])
        ]),
        fields: FormFields(fields: {
          'Header': Header(title: 'Card'),
          'Id': Text(title: 'Id', displayValue: 'cardId'),
          'Name': TextInput(title: 'Name', bindTo: record.name, required: true),
          'Owner': TextInput(title: 'Owner', bindTo: record.owner, required: true),
          'Description': TextInput(
              title: 'Description', 
              bindTo: record.description, 
              required: true),
          'Common': Text(
            title: 'Common', 
            displayValue: 'Name: ${record.name}', 
            visibleWhen: record.rarity.contains('Common')
          ),
          'Rare': Text(
            title: 'Rare', 
            displayValue: 'This is a rare card',
            visibleWhen: record.rarity.contains('Rare')
          ),
          'Epic': Text(
            title: 'Epic', 
            displayValue: 'This is an epic card!!!',
            visibleWhen: record.rarity.contains('Epic')
          ),
          'Type': Text(title: 'Type', displayValue: 'type'),
          'Attacks': RecordListFormField(
              title: 'Attacks', builder: AttackRecordListBuilder())
        }));
  }
}

class AttackRecordListBuilder extends FormRecordListBuilder {
  @override
  final Attack record = Attack();

  AttackRecordListBuilder() : super(id: 'AttacksRecordList', record: Attack());

  @override
  FormRecordList build() {
    return FormRecordList(
        id: id,
        bindTo: 'attacks',
        template: Template(
            id: 'attack_workbench',
            values: Values(values: {
              'title': Value(value: record.attackId),
              'subtitle': Value(value: record.name),
            })),
        showHeader: true,
        headerText: 'Attacks',
        collapsed: false,
        collapsible: true,
        placeholderText: 'Search attacks',
        sort: 'damage ASC',
        onItemSelected: OnItemSelectedForm(
            builder: AttackFormBuilder(), primaryKey: 'attackId'));
  }
}

class AttackFormBuilder extends FormBuilder {
  @override
  final Attack record = Attack();

  AttackFormBuilder() : super(id: 'AttacksUpdateForm', record: Attack());

  @override
  Form build() {
    return Form(
        id: id,
        toolbar: Toolbar(items: []),
        fields: FormFields(fields: {
          'Id': Text(title: 'Id', displayValue: 'attackId'),
          'Name': TextInput(title: 'Name', bindTo: record.name, required: true),
          'Damage': TextInput(title: 'Damage', bindTo: record.damage, required: true)
        }));
  }
}

void main() {
  final app = App(name: 'Cards', configVersion: 2);
  app.addFeature(
      CardRecordListBuilder(),
      MenuItem(
          title: 'MyCards', icon: 'dashboard', defaultItem: false, order: 1));
  app.initialize();
}
