part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

sealed class ProductActionState extends ProductState {}

final class ProductInitial extends ProductState {}

class ProductFetchSucess extends ProductState {
  late final List<Medicament> medi;
  ProductFetchSucess({required this.medi});
}
