import 'package:apptree_dart_sdk/base.dart';

class Card extends Record {
  final StringField id = StringField();
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

  CardRecordListBuilder() : super(id: 'card_list', record: Card());

  @override
  Feature build() {
    return RecordList(
        id: id,
        dataSource: 'cards',
        template: Template(
            id: 'card_template',
            values: Values(values: {
              'id': Value(value: record.id),
              'name': Value(value: record.name),
              'description': Value(value: record.description),
              'rarity': Value(value: record.rarity),
              'type': Value(value: record.type)
            })),
        onLoad: OnLoad(),
        noResultsText: 'No results',
        showDivider: true,
        topAccessoryViews: [],
        onItemSelected: OnItemSelected(builder: CardFormBuilder()));
  }
}

class CardFormBuilder extends Builder {
  @override
  final Card record = Card();

  CardFormBuilder() : super(id: 'card_form', record: Card());

  @override
  Feature build() {
    return Form(
        id: id,
        toolbar: Toolbar(items: [
          ToolbarItem(title: 'Save', actions: [
            SubmitFormAction(url: '<insert_url>', title: 'Updating Card')
          ])
        ]),
        fields: FormFields(fields: {
          'Header': Header(title: 'Card'),
          'Id': Text(title: 'Id', displayValue: 'id'),
          'Name': TextInput(title: 'Name', bindTo: 'name', required: true),
          'Description': TextInput(
              title: 'Description', bindTo: 'description', required: true),
          'Rarity':
              TextInput(title: 'Rarity', bindTo: 'rarity', required: true),
          'Type': TextInput(title: 'Type', bindTo: 'type', required: true),
          'Attacks': RecordListFormField(
              title: 'Attacks', builder: AttackRecordListBuilder())
        }));
  }
}

class AttackRecordListBuilder extends Builder {
  @override
  final Attack record = Attack();

  AttackRecordListBuilder() : super(id: 'attack_list', record: Attack());

  @override
  Feature build() {
    return RecordList(
        id: id,
        dataSource: 'attacks',
        template: Template(
            id: 'attack_template',
            values: Values(values: {
              'id': Value(value: record.id),
              'name': Value(value: record.name),
              'description': Value(value: record.description),
              'damage': Value(value: record.damage)
            })),
        onLoad: OnLoad(),
        noResultsText: 'No results',
        showDivider: true,
        topAccessoryViews: [],
        onItemSelected: OnItemSelected(builder: AttackFormBuilder()));
  }
}

class AttackFormBuilder extends Builder {
  @override
  final Attack record = Attack();

  AttackFormBuilder() : super(id: 'attack_form', record: Attack());

  @override
  Feature build() {
    return Form(
        id: id,
        toolbar: Toolbar(items: [
          ToolbarItem(title: 'Save', actions: [
            SubmitFormAction(url: '<insert_url>', title: 'Updating Attack')
          ])
        ]),
        fields: FormFields(fields: {
          'Header': Header(title: 'Attack'),
          'Id': Text(title: 'Id', displayValue: 'id'),
          'Name': TextInput(title: 'Name', bindTo: 'name', required: true),
          'Description': TextInput(
              title: 'Description', bindTo: 'description', required: true),
          'Damage': TextInput(title: 'Damage', bindTo: 'damage', required: true)
        }));
  }
}

void main() {
  final app = App(name: 'Cards', version: '1.0.0');
  app.addFeature(
      CardRecordListBuilder(),
      MenuItem(
          title: 'Cards', icon: 'dashboard', defaultItem: false, order: 1));
  app.initialize();
}
