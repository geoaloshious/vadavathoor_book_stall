import 'package:vadavathoor_book_stall/db/functions/book.dart';
import 'package:vadavathoor_book_stall/db/functions/book_author.dart';
import 'package:vadavathoor_book_stall/db/functions/book_category.dart';
import 'package:vadavathoor_book_stall/db/functions/book_purchase.dart';
import 'package:vadavathoor_book_stall/db/functions/publisher.dart';
import 'package:vadavathoor_book_stall/db/functions/sales.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_item.dart';
import 'package:vadavathoor_book_stall/db/functions/stationary_purchase.dart';
import 'package:vadavathoor_book_stall/db/functions/user_batch.dart';
import 'package:vadavathoor_book_stall/db/functions/users.dart';
import 'package:vadavathoor_book_stall/db/functions/utils.dart';

clearData() async {
  await (await getBookAuthorsBox()).clear();
  await (await getBookCategoriesBox()).clear();
  await (await getBookPurchaseBox()).clear();
  await (await getPublishersBox()).clear();
  await (await getBooksBox()).clear();
  await (await getLoginHistoryBox()).clear();
  await (await getMiscBox()).clear();
  await (await getSalesBox()).clear();
  await (await getStationaryItemBox()).clear();
  await (await getStationaryPurchaseBox()).clear();
  await (await getUserBatchBox()).clear();
  await (await getUsersBox()).clear();
}
