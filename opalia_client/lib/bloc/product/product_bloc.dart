import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:opalia_client/models/categories.dart';
import '../../config/config.dart';
import '../../models/mediacment.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<MedicamentInitialFetchEvent>(medicamentInitialFetchEvent);
    on<CategorieMedicamentInitialFetchEvent>(
        categorieMedicamentInitialFetchEvent);
  }
  // ignore: non_constant_identifier_names

  var client = http.Client();
  FutureOr<void> medicamentInitialFetchEvent(
      MedicamentInitialFetchEvent event, Emitter<ProductState> emit) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    List<Medicament> medis = [];
    var url = Uri.http(Config.apiUrl, Config.medicaAPI);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      for (int i = 0; i < data.length; i++) {
        Medicament medi = Medicament.fromMap(data[i] as Map<String, dynamic>);
        medis.add(medi);
      }
      print(data);
      emit(ProductFetchSucess(medi: medis));
    } else {
      throw Exception('Failed to load data medicament');
    }
  }

  FutureOr<void> categorieMedicamentInitialFetchEvent(
    CategorieMedicamentInitialFetchEvent event,
    Emitter<ProductState> emit,
  ) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    List<Medicament> medis = [];

    var url = Uri.http(
        Config.apiUrl, Config.medicaCategorieAPI + "65eafb8e699ec0f45a15b472");
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      print(data);
      emit(CategorieProductFetchSucess(
          medi: medis, name: "65eafb8e699ec0f45a15b472"));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
