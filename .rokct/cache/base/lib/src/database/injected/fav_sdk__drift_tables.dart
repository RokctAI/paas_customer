// Copied at compose time from package:fav_sdk/src/infrastructure/database/drift_tables.dart by sdk_installer_base.py's update_database_registration() -
// drift only understands table classes inside its own package.
import 'package:drift/drift.dart';

@DataClassName('ShopEntity')
class ShopTable extends Table {
  TextColumn get id => text()();
  TextColumn get data => text()();

  @override
  Set<Column> get primaryKey => {id};
}
