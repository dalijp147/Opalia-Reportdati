import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/mediacment.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<MedicamentInitialFetchEvent>(medicamentInitialFetchEvent);
  }
  var client = http.Client();
  Future<FutureOr<void>> medicamentInitialFetchEvent(
      MedicamentInitialFetchEvent event, Emitter<ProductState> emit) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.medicaAPI);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      emit(ProductFetchSucess(medi: data['data']));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
