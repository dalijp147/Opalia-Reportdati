part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

sealed class ProductActionState extends ProductState {}

final class ProductInitial extends ProductState {}

class ProductFetchSucess extends ProductState {
  final List<Medicament> medi;
  ProductFetchSucess({required this.medi});
}

class CategorieProductFetchSucess extends ProductState {
  final List<Medicament> medi;

  late String name;
  CategorieProductFetchSucess({required this.medi, required String name});
}
