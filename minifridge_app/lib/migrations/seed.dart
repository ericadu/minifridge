import "dart:io";
import 'package:yaml/yaml.dart';

final String USER_ID = "3N6fMDSeV4bcCd59ZzrjGYTXGwG2";
final String FILENAME = '../data/user_items.yml';
main() {
  // UserItemsApi userApi = UserItemsApi(USER_ID);
  File file = new File(FILENAME);
  String yamlString = file.readAsStringSync();
  YamlList doc = loadYaml(yamlString);
  
  print(doc);
  
}