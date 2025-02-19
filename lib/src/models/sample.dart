// Generated

abstract class CollectionEndpoint<INPUT,RESPONSE> extends CollectionEndpoint<INPUT,RESPONSE> {
  Future<List<RESPONSE>> fetch(INPUT input);
}

class MyWorkOrderRequest {
  final String userId;
  final String status;
}

class MyWorkOrderEndpoint extends CollectionEndpoint<MyWorkOrderRequest,WorkOrder> {
  final WorkOrderDataSource dataSource;
  @override
  Future<List<WorkOrder>> fetch(MyWorkOrderRequest input) {
    return dataSource.fetch(input);
  }
}


var server = Sever()..addEndpiont(MyWorkOrderEndpoint(dataSource: SampleWorkOrderDataSource(new FAMISWorkOrderDataSource())));
server.start();




// Generated, user overridable

class SampleWorkOrderDataSource extends DataSource<WorkOrder> {
  @override
  Future<List<WorkOrder>> fetch(MyWorkOrderRequest input) {
    //Return sample data
  }
}

// User created

class FAMISWorkOrderDataSource extends DataSource<WorkOrder> {
  @override
  Future<List<WorkOrder>> fetch(MyWorkOrderRequest input) {
    //Make HTTP request to FAMIS API
  }
}

var colletionEndpoint = new CollectionEndpoint(input: MyWorkOrderRequest(), ouput: WorkOrder(), id: 'myWorkOrder');



var feature = new RecordListFeature<MyWorkOrderRequest,WorkOrder>(
  endpoint: colletionEndpoint,
);

var app = new App()..addFeature(feature);