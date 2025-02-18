import 'package:apptree_dart_sdk/base.dart';

class Card extends Record {
  final StringField cardId = StringField();
  final StringField name = StringField();
  final StringField description = StringField();
  final StringField rarity = StringField();
  final StringField type = StringField();
  final Attack attacks = Attack();
}

class Attack extends Record {
  final StringField id = StringField();
  final StringField name = StringField();
  final StringField description = StringField();
  final StringField damage = StringField();
}

class CardRecordListBuilder extends Builder {
  @override
  final Card record = Card();

  CardRecordListBuilder() : super(id: 'MyCardsRecordList', record: Card());

  @override
  Feature build() {
    return RecordList(
        id: id,
        dataSource: 'my_cards',
        template: Template(
            id: 'workbench',
            values: Values(values: {
              'title': Value(value: record.cardId),
              'subtitle': Value(value: record.name),
            })),
        onLoad: OnLoad(collection: 'my_cards', url: 'https://corey.apptree.dev/MyCards'),
        noResultsText: 'No results',
        showDivider: true,
        topAccessoryViews: [],
        onItemSelected: OnItemSelected(builder: CardFormBuilder()));
  }
}

class CardFormBuilder extends Builder {
  @override
  final Card record = Card();

  CardFormBuilder() : super(id: 'CardsUpdateForm', record: Card());

  @override
  Feature build() {
    return Form(
        id: id,
        toolbar: Toolbar(items: [
          ToolbarItem(title: 'Save', actions: [
            SubmitFormAction(url: 'https://corey.apptree.dev/UpdateCard', title: 'Updating Card')
          ])
        ]),
        fields: FormFields(fields: {
          'Header': Header(title: 'Card'),
          'Id': Text(title: 'Id', displayValue: 'cardId'),
          'Name': TextInput(title: 'Name', bindTo: 'name', required: true),
          'Description': TextInput(
              title: 'Description', bindTo: 'description', required: true),
          'Rarity':
              TextInput(title: 'Rarity', bindTo: 'rarity', required: true),
          'Type': TextInput(title: 'Type', bindTo: 'type', required: true),
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
