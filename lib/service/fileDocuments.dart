import 'package:delivery_ctpaga/providers/provider.dart';
import 'package:delivery_ctpaga/env.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';


class FileDocuments {
    // Declaring instance variable
    String fileName;
  
    // Creating instance method name 
    // sum with two parameters
    String getName(String file)
    {

        this.fileName = basename(file);
  
        // Printing the result
        return fileName;
    }

    uploadFile(context, file, urlPrevius, description)async{
      var myProvider = Provider.of<MyProvider>(context, listen: false);

        Map<String, String> headers = { 
          "Content-type": "multipart/form-data",
          'X-Requested-With': 'XMLHttpRequest',
          'authorization': 'Bearer ${myProvider.accessTokenDelivery}',
        };

        Uri uri = Uri.parse(urlApi+"updateDeliveryDocuments");

        var request = new http.MultipartRequest("POST", uri);

        //add your fields here
        request.headers.addAll(headers);
        request.fields["urlPrevious"] = urlPrevius== null? '' : urlPrevius;
        request.fields["description"] = description;
        request.fields["type"] = 'pdf';

        // multipart that takes file
        var multipartFile = new http.MultipartFile(
          'file',
          File(file.path).readAsBytes().asStream(),
          File(file.path).lengthSync(),
          filename: this.getName(file.path)
        );

        // add file to multipart
        request.files.add(multipartFile);
        
        var response = await request.send();
        // listen for response
        response.stream.transform(utf8.decoder).listen((value) {
          print("print 1 $value");
          return value;
        });
    }
}