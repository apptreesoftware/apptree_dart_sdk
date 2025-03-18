import 'package:apptree_dart_sdk/apptree.dart';
import 'endpoints.dart';
import 'models.dart';

var cardsForm = Form<Card>(
  id: 'CardsUpdateForm',
  toolbarBuilder:
      (context, record) => Toolbar(
        items: [
          ToolbarItem(
            title: 'Submit',
            actions: [
              SubmitFormAction<CardSubmissionRequest, Card>(
                endpoint: CreateCardEndpoint(),
                submissionTitle: (context, record) => 'Saving ${record.name}',
                request: (context) {
                  return CardSubmissionRequest(
                    appVersion: '${context.user.appVersion}',
                  );
                },
              ),
            ],
          ),
        ],
      ),
  fieldsBuilder:
      (context, record) => [
        Header(title: 'Card', id: 'Header'),
        Text(
          title: 'Id',
          displayValue: "Hello ${record.cardId} - ${record.description}",
          id: 'Id',
        ),
        TextInput(
          title: 'Name',
          bindTo: record.name,
          required: true,
          id: 'Name',
        ),
        TextInput(
          layoutDirection: LayoutDirection.vertical,
          layoutSize: FormFieldLayoutSize(xs: 12, sm: 6),
          title: 'Owner',
          bindTo: record.owner,
          required: true,
          id: 'Owner',
        ),
        TextInput(
          id: 'Description',
          title: 'Description',
          bindTo: record.description,
          required: true,
        ),
        DurationInput(bindTo: record.cardId, id: 'Duration', title: 'Duration'),
        DateInput(bindTo: record.cardId, id: 'Date', title: 'Date'),
        NumberInput(bindTo: record.cardId, id: 'Number', title: 'Number'),
      ],
);

var cardRecordList = RecordList<MyCardsRequest, Card>(
  id: 'MyCardsRecordList',
  onLoadRequest: (context) {
    return MyCardsRequest(owner: '${context.user.uid}', filter: 'active');
  },
  dataSource: MyCardsEndpoint(),
  toolbar: (context) {
    return Toolbar(
      items: [
        ToolbarItem(
          title: 'Sort',
          icon: Icon.sort,
          actions: [ShowSortDialogAction(analytics: Analytics(tag: 'sort'))],
        ),
      ],
    );
  },
  template: (BuildContext context, Card record) {
    return Workbench(
      title: '${record.cardId}',
      subtitle: '${record.owner.name} - ${record.description}',
    );
  },
  filter: (context, record) {
    return [
      ListFilter(
        when: record.owner.name.contains('John'),
        statement: record.description
            .equals('Card')
            .and(record.owner.name.equals('John')),
      ),
      ListFilter(
        when: record.owner.name.contains('John'),
        statement: record.contains(record.owner.name),
      ),
    ];
  },
  mapSettings: (context, record) {
    return MapSettings(
      initialZoomMode: MapZoomMode.markers,
      latitudeKey: '${record.latitude}',
      longitudeKey: '${record.longitude}',
      showCurrentLocation: true,
      markerTitle: '${record.name}',
      markerSummary: '${record.description}',
      initialCameraPosition: CameraPosition(
        latitude: 37.7749,
        longitude: -122.4194,
      ),
    );
  },
  noResultsText: 'No results',
  showDivider: true,
  topAccessoryView: (context) {
    return [
      TemplateAccessoryView(
        template:
            (context) => Workbench(
              title: 'Count: ${context.recordCount}',
              subtitle: 'No results',
            ),
      ),
      SegmentedControlAccessoryView(
        defaultValue: 'all',
        bindTo: 'activeFilter',
        segments: [
          SegmentItem(title: 'All', value: 'all'),
          SegmentItem(title: 'Active', value: 'active'),
          SegmentItem(title: 'Inactive', value: 'inactive'),
        ],
      ),
      SelectListInputAccessoryView(
        label: 'Filter',
        bindTo: 'filter',
        displayValue: (context, record) => '${record.name}',
        placeholderText: 'Choose filter',
        listEndpoint: OwnersListEndpoint(),
        template:
            (context, record) => Workbench(
              title: '${record.name}',
              subtitle: '${record.ownerId}',
            ),
      ),
    ];
  },
  onItemSelected: (BuildContext context, Card record) {
    return NavigateTo(feature: attacksForm);
  },
);

var attacksForm = Form<Attack>(
  id: 'AttacksForm',
  toolbarBuilder: null,
  fieldsBuilder:
      (context, attack) => [
        Header(title: 'Attack', id: 'Header'),
        Text(title: 'Id', displayValue: "${attack.attackId}", id: 'Id'),
        Text(title: 'Name', displayValue: '${attack.name}', id: 'Name'),
        Text(
          title: 'Damage Amount',
          displayValue: '${attack.damage}',
          id: 'DamageAmount',
        ),
      ],
);

void main() {
  final app = App(name: 'Cards', configVersion: 2);
  app.addFeature(
    cardRecordList,
    menuItem: MenuItem(
      title: 'MyCards',
      icon: 'dashboard',
      defaultItem: false,
      order: 1,
    ),
  );
  app.initialize();

  var generatorController = GeneratorController(app: app);
  generatorController.generateConnectors();
}
