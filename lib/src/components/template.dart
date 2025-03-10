import 'package:apptree_dart_sdk/src/models/builder.dart';

abstract class Template {
  final String id;
  bool isFormTemplate = false;

  Template({required this.id});

  void setIsFormTemplate(bool isFormTemplate) {
    this.isFormTemplate = isFormTemplate;
  }

  Map<String, dynamic> toDict();

  String toFsx();

  BuildResult build(BuildContext context) {
    return BuildResult(featureData: toDict(), childFeatures: [], errors: [], endpoints: []);
  }
}

class Workbench extends Template {
  final String title;
  final String subtitle;

  Workbench({required this.title, required this.subtitle})
    : super(id: "workbench");

  @override
  Map<String, dynamic> toDict() => {
    'id': id,
    'values': {'title': title, 'subtitle': subtitle},
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
