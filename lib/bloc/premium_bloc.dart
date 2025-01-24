
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_premium_database_switch_supabase_sqlite/managers/database_manager.dart';




abstract class PremiumEvent {}

class SetPremium extends PremiumEvent {}

class RemovePremium extends PremiumEvent {}


abstract class PremiumState {}

class Premium extends PremiumState {}

class NotPremium extends PremiumState {}


class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {


  PremiumBloc() : super(NotPremium()) {
    print('SETTING UP PremiumBloc');


    //subscription.resume();

    on<SetPremium>((event, emit) async {
      print('SETPREMIUM EVENT CALLED------------');

      ///switch databases
      DatabaseManager databaseManager = DatabaseManager();
      databaseManager.switchToOnline();

      emit(Premium());

    });
    on<RemovePremium>((event, emit) async {
      print('REMOVEPREMIUM EVENT CALLED');
      ///switch databases
      DatabaseManager databaseManager = DatabaseManager();
      databaseManager.switchToOffline();
      emit(NotPremium());
    });
  }
}