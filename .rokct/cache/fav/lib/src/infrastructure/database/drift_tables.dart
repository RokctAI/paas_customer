import 'package:drift/drift.dart';

@DataClassName('ShopEntity')
class ShopTable extends Table {
  TextColumn get id => text()();
  TextColumn get data => text()();

  @override
  Set<Column> get primaryKey => {id};
}
