import 'package:apptree_dart_sdk/apptree.dart';

abstract class Template {
  final String id;
  bool isFormTemplate = false;

  Template({required this.id});

  void setIsFormTemplate(bool isFormTemplate) {
    this.isFormTemplate = isFormTemplate;
  }

  Map<String, dynamic> toDict();

  String toFsx();
}

class Workbench extends Template {
  final StringField title;
  final StringField subtitle;

  Workbench({required this.title, required this.subtitle}) : super(id: "workbench");

  @override
  Map<String, dynamic> toDict() => {
        'id': id,
        'values': {
          'title': title,
          'subtitle': subtitle,
        },
      };

  @override
  String toFsx() => '''
<template id="$id">
  <Card elevation="1" color="#ffffff">
    <Padding padding="8.0,8.0,8.0,8.0">
      <Column mainAxisSize="min">
        // Title
        <Row crossAxisAlignment="center" mainAxisAlignment="spaceBetween" mainAxisSize="max">
            <Text textAlign="start" overflow="ellipsis" style:fontColor="ff448aff" style:fontSize="18.0"
                  value:binding="title" value="This is the title"/>
        </Row>
        // Subtitle
        <Text textAlign="start" value:binding="subtitle" value="This is the subtitle"/>
      </Column>
    </Padding>
  </Card>
</template>
  ''';
}

class ListTile extends Template {
  final StringField title;
  final StringField subtitle;

  ListTile({required this.title, required this.subtitle}) : super(id: "list_tile");

  @override
  Map<String, dynamic> toDict() => {
        'id': id,
        'values': {
          'title': title,
          'subtitle': subtitle,
        },
      };

  @override
  String toFsx() => '''
<template id="$id">
  <Card elevation="1" color="#ffffff">
    <Padding padding="8.0,8.0,8.0,8.0">
      <Column mainAxisSize="min">
        // Title
        <Text textAlign="start" overflow="ellipsis" style:fontColor="ff448aff" style:fontSize="18.0" value:binding="title" value="This is the title"/>
        // Subtitle
        <Text textAlign="start" value:binding="subtitle" value="This is the subtitle"/>
      </Column>
    </Padding>
  </Card>
</template>
  ''';
}
