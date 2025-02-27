class Icon {
  final String id;

  const Icon._({required this.id});

  static const Icon sort = Icon._(id: 'sort');
  static const Icon filter = Icon._(id: 'filter');
  static const Icon add = Icon._(id: 'add');
  static const Icon edit = Icon._(id: 'edit');
  static const Icon delete = Icon._(id: 'delete');
  static const Icon save = Icon._(id: 'save');
  static const Icon cancel = Icon._(id: 'cancel');
}
