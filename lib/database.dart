
import 'package:delivery_ctpaga/models/delivery.dart';
import 'package:delivery_ctpaga/models/commerce.dart';
import 'package:delivery_ctpaga/models/paid.dart';
import 'package:delivery_ctpaga/models/picture.dart';
import 'package:delivery_ctpaga/models/document.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io'as io;
import 'dart:async';


class DBctpaga{

  static Database? dbInstance;
  static int versionDB = 9;

  Future<Database> get db async{
    return dbInstance ??= await initDB();
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "delivery.db");

    var db = await openDatabase(path, version: versionDB, 
      onCreate: onCreateFunc,
      onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion != newVersion) {
            onCreateFunc(db, newVersion);
          }
        },
    );

    return db;
  }


  void onCreateFunc (Database db, int version) async{
    //create table
    await db.execute('CREATE TABLE IF NOT EXISTS deliveries (id INTEGER PRIMARY KEY AUTOINCREMENT, email Text, name VARCHAR(100), phone VARCHAR(20), status INTEGER, codeUrlPaid text, statusAvailability INTEGER, tokenFCM TEXT )');
    await db.execute('CREATE TABLE IF NOT EXISTS commerces (id INTEGER PRIMARY KEY AUTOINCREMENT, rif VARCHAR(15), name Text, address Text, phone VARCHAR(20), userUrl VARCHAR(20))');
    await db.execute('CREATE TABLE IF NOT EXISTS paids (id INTEGER, user_id INTEGER, commerce_id INTEGER, codeUrl VARCHAR(10), nameClient VARCHAR(50), total text, coin INTEGER, email text, nameShipping VARCHAR(50), numberShipping VARCHAR(50), addressShipping text, detailsShipping text, selectShipping text, priceShipping text, statusShipping INTEGER, percentage INTEGER, nameCompanyPayments VARCHAR(10), date text)');
    await db.execute('CREATE TABLE IF NOT EXISTS sales (id INTEGER, user_id INTEGER, commerce_id INTEGER, codeUrl VARCHAR(10), productService_id INTEGER, name VARCHAR(50), price text, nameClient VARCHAR(50), coinClient INTEGER, coin INTEGER, type INTEGER, quantity INTEGER, statusSale INTEGER, rate text, descriptionShipping text, statusShipping INTEGER)');
    await db.execute('CREATE TABLE IF NOT EXISTS settings (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(50), value VARCHAR(50))');
    await db.execute('CREATE TABLE IF NOT EXISTS pictures (id INTEGER PRIMARY KEY AUTOINCREMENT, description VARCHAR(30), url Text)');
    await db.execute('CREATE TABLE IF NOT EXISTS documents (id INTEGER PRIMARY KEY AUTOINCREMENT, description VARCHAR(30), url Text)');
  }

  /*
    CRUD FUNCTION
  */

   // Delete service
  Future deleteAll() async{
    var dbConnection = await db;
    await dbConnection.execute('DROP TABLE IF EXISTS deliveries');
    await dbConnection.execute('DROP TABLE IF EXISTS commerces');
    await dbConnection.execute('DROP TABLE IF EXISTS paids');
    await dbConnection.execute('DROP TABLE IF EXISTS sales');
    await dbConnection.execute('DROP TABLE IF EXISTS settings');
    await dbConnection.execute('DROP TABLE IF EXISTS pictures');
    await dbConnection.execute('DROP TABLE IF EXISTS documents');
  
    onCreateFunc(dbConnection, versionDB);
  }

  // Get Delivery
  Future <Delivery> getDelivery() async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM deliveries WHERE id = 1');
    Delivery delivery = new Delivery();

    for(int i = 0; i< list.length; i++)
    {
      delivery = Delivery(
        id : list[i]['id'],
        email : list[i]['email'],
        name : list[i]['name'],
        phone : list[i]['phone'],
        status: list[i]['status'],
        codeUrlPaid: list[i]['codeUrlPaid'],
        statusAvailability: list[i]['statusAvailability'],
      );

    }

    return delivery;
  }

  existDelivery() async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM deliveries WHERE id = 1');
    
    return (list.length);
  }

  // Add New Delivery
  void addNewDelivery (Delivery delivery) async{
    var dbConnection = await db;
    String query = 'INSERT INTO deliveries (email , name, phone, status, codeUrlPaid, statusAvailability, tokenFCM) VALUES (\'${delivery.email}\',\'${delivery.name}\',\'${delivery.phone}\',\'${delivery.status}\',\'${delivery.codeUrlPaid}\',\'${delivery.statusAvailability}\', \'${delivery.tokenFCM}\')';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }

  // Update Delivery
  void updateDelivery (Delivery delivery) async{
    var dbConnection = await db;
    String query = 'UPDATE deliveries SET email=\'${delivery.email}\', name=\'${delivery.name}\', phone=\'${delivery.phone}\', status=\'${delivery.status}\', codeUrlPaid=\'${delivery.codeUrlPaid}\', statusAvailability=\'${delivery.statusAvailability}\', tokenFCM=\'${delivery.tokenFCM}\' WHERE id=1';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  // Delete Delivery
  void deleteDelivery (Delivery delivery) async{
    var dbConnection = await db;
    String query = 'DELETE FROM deliveries WHERE idUsers=${delivery.id}';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  // Get Commerces
  Future <Commerce> getCommerce() async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM commerces');
    Commerce commerce = new Commerce();

    for(int i = 0; i< list.length; i++)
    {
      commerce = Commerce(
        rif : list[i]['rif'],
        name : list[i]['name'],
        address : list[i]['address'],
        phone : list[i]['phone'],
        userUrl : list[i]['userUrl'],
      );


    }

    return commerce;
  }

  // Create or update commerces
  void createOrUpdateCommerces(Commerce commerce) async{
    var dbConnection = await db;

    String query = 'INSERT OR REPLACE INTO commerces (id, rif, name, address, phone, userUrl) VALUES ( 1, \'${commerce.rif}\', \'${commerce.name}\',\'${commerce.address}\',\'${commerce.phone}\',\'${commerce.userUrl}\')';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }

  // Get Paids 
  Future <Paid> getPaid() async{

    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM paids');
    Paid paid = new Paid();

    for(int i = 0; i< list.length; i++)
    {
      paid = Paid(
        user_id: list[i]['user_id'],
        commerce_id: list[i]['commerce_id'],
        codeUrl: list[i]['codeUrl'],
        nameClient: list[i]['nameClient'],
        total: list[i]['total'],
        coin: list[i]['coin'],
        email: list[i]['email'],
        nameShipping: list[i]['nameShipping'],
        numberShipping: list[i]['numberShipping'],
        addressShipping: list[i]['addressShipping'],
        detailsShipping: list[i]['detailsShipping'],
        selectShipping: list[i]['selectShipping'],
        priceShipping: list[i]['priceShipping'],
        statusShipping: list[i]['statusShipping'],
        percentage: list[i]['percentage'],
        nameCompanyPayments: list[i]['nameCompanyPayments'],
        date: list[i]['date'],
      );

    }

    return paid;
  }

  // Create or update Paid
  void createOrUpdatePaid(Paid paid) async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM paids WHERE id = 1 ');
    
    if(list.length == 0){
      String query = 'INSERT INTO paids (id, user_id, commerce_id, codeUrl, nameClient, total, coin, email, nameShipping, numberShipping, addressShipping, detailsShipping, selectShipping, priceShipping, statusShipping, percentage, nameCompanyPayments, date) VALUES ( 1, \'${paid.user_id}\',\'${paid.commerce_id}\',\'${paid.codeUrl}\',\'${paid.nameClient}\',\'${paid.total}\',\'${paid.coin}\',\'${paid.email}\',\'${paid.nameShipping}\',\'${paid.numberShipping}\',\'${paid.addressShipping}\',\'${paid.detailsShipping}\',\'${paid.selectShipping}\',\'${paid.priceShipping}\',\'${paid.statusShipping}\',\'${paid.percentage}\',\'${paid.nameCompanyPayments}\',\'${paid.date}\')';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
    });
    }else{
      String query = 'UPDATE paids SET user_id=\'${paid.user_id}\', commerce_id=\'${paid.commerce_id}\', codeUrl=\'${paid.codeUrl}\', nameClient=\'${paid.nameClient}\', total=\'${paid.total}\', coin=\'${paid.coin}\', email=\'${paid.email}\', nameShipping=\'${paid.nameShipping}\', numberShipping=\'${paid.numberShipping}\', addressShipping=\'${paid.addressShipping}\', detailsShipping=\'${paid.detailsShipping}\', selectShipping=\'${paid.selectShipping}\', priceShipping=\'${paid.priceShipping}\', statusShipping=\'${paid.statusShipping}\', percentage=\'${paid.percentage}\', nameCompanyPayments=\'${paid.nameCompanyPayments}\', date=\'${paid.date}\' WHERE id= 1';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
      });
    }
  }

  // Get Sales 
  Future <List<dynamic>> getSales() async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM sales');
    
    return list;
  }

  // Create or update Sales
  void createOrUpdateSales(List listsales) async{
    var dbConnection = await db;

    await dbConnection.rawQuery('DROP TABLE IF EXISTS sales');
    await dbConnection.rawQuery('CREATE TABLE IF NOT EXISTS sales (id INTEGER, user_id INTEGER, commerce_id INTEGER, codeUrl VARCHAR(10), productService_id INTEGER, name VARCHAR(50), price text, nameClient VARCHAR(50), coinClient INTEGER, coin INTEGER, type INTEGER, quantity INTEGER, statusSale INTEGER, rate text, descriptionShipping text, statusShipping INTEGER)');
    
    for (var item in listsales) {
      String query = 'INSERT INTO sales (user_id, commerce_id, codeUrl, productService_id, name, price, nameClient, coinClient, coin, type, quantity, statusSale, rate, descriptionShipping, statusShipping) VALUES (\'${item['user_id']}\', \'${item['commerce_id']}\',\'${item['codeUrl']}\',\'${item['productService_id']}\',\'${item['name']}\',\'${item['price']}\',\'${item['nameClient']}\',\'${item['coinClient']}\',\'${item['coin']}\',\'${item['type']}\',\'${item['quantity']}\',\'${item['statusSale']}\',\'${item['rate']}\',\'${item['descriptionShipping']}\',\'${item['statusShipping']}\')';
      await dbConnection.transaction((transaction) async{
        return await transaction.rawInsert(query);
      });
    }

  }

  // Get Settings 
  Future <List<dynamic>> getSettings() async{
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM Settings');
    
    return list;
  }

  // Create or update Settings
  void createOrUpdateSettings(List listSettings) async{
    var dbConnection = await db;

    for (var item in listSettings) {
      List<Map> list = await dbConnection.rawQuery('SELECT * FROM settings WHERE name=\'${item['name']}\' ');

      if(list.length == 0){
        String query = 'INSERT INTO settings (name, value) VALUES (\'${item['name']}\',\'${item['value']}\')';
        await dbConnection.transaction((transaction) async{
          return await transaction.rawInsert(query);
      });
      }else{
        String query = 'UPDATE settings SET value=\'${item['value']}\' WHERE name=\'${item['name']}\'';
        await dbConnection.transaction((transaction) async{
          return await transaction.rawInsert(query);
        });
      }
    }

  }

  // Get pictures Delivery
  Future <List<dynamic>> getPicturesDelivery() async{
    List listPicturesDelivery = [];
    listPicturesDelivery = [];
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM pictures');
    Picture pictureDelivery = new Picture();

    for(int i = 0; i< list.length; i++)
    {
      pictureDelivery = Picture(
        id : list[i]['id'],
        description : list[i]['description'],
        url : list[i]['url'],
      );

      listPicturesDelivery.add(pictureDelivery);

    }

    return listPicturesDelivery;
  }

  // Create or update pictures
  void createOrUpdatePicturesDelivery (Picture picture) async{
    var dbConnection = await db;

    String query = 'INSERT OR REPLACE INTO pictures (id, description, url) VALUES ( (SELECT id FROM pictures WHERE description = \'${picture.description}\'), \'${picture.description}\',\'${picture.url}\')';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }


  // Get Document Delivery
  Future <List<dynamic>> getDocumentsDelivery() async{
    List listDocumentsDelivery = [];
    listDocumentsDelivery = [];
    var dbConnection = await db;

    List<Map> list = await dbConnection.rawQuery('SELECT * FROM documents');
    Document documentDelivery = new Document();

    for(int i = 0; i< list.length; i++)
    {
      documentDelivery = Document(
        id : list[i]['id'],
        description : list[i]['description'],
        url : list[i]['url'],
      );

      listDocumentsDelivery.add(documentDelivery);

    }

    return listDocumentsDelivery;
  }

  // Create or update Documents
  void createOrUpdateDocumentsDelivery(Document document) async{
    var dbConnection = await db;

    String query = 'INSERT OR REPLACE INTO documents (id, description, url) VALUES ( (SELECT id FROM documents WHERE description = \'${document.description}\'), \'${document.description}\',\'${document.url}\')';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }

}

