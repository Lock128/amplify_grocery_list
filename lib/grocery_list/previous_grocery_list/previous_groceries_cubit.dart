import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_grocery_list/models/Grocery.dart';
import 'package:amplify_grocery_list/utils/helpers.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

part 'previous_groceries_state.dart';

class PreviousGroceriesCubit extends Cubit<PreviousGroceriesState> {
  PreviousGroceriesCubit() : super(PreviousGroceriesInitial());

  Future<void> fetchPreviousGroceries() async {
    emit(PreviousGroceriesLoading());
    // FIXME: Fix this with the predicate fix.
    // final queryPredicate = Grocery.FINALIZATIONDATE.ne(null);
    // final request =
    //     ModelQueries.list<Grocery>(Grocery.classType, where: queryPredicate);
    final request = ModelQueries.list<Grocery>(Grocery.classType);
    final response = await runMutation(request, (error) {
      PreviousGroceriesError(error);
    });
    final items = response?.items
        .whereNotNull()
        // FIXME: Remove this with the predicate fix.
        .where((item) => item.finalizationDate != null)
        .toList(growable: false);
    if (items == null) {
      emit(PreviousGroceriesError('Something went wrong while fetching data'));
    } else {
      emit(PreviousGroceriesSuccess(items));
    }
  }
}
