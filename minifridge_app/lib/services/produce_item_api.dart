import 'package:minifridge_app/services/firestore.dart';

class ProduceItemsApi extends FirestoreApi {
  static final String produceItemsApi = "produce_items";
  
  ProduceItemsApi() : super(produceItemsApi);
}