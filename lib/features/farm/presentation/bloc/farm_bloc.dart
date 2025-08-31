import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/create_farm.dart';
import '../../domain/usecases/get_farm_details.dart';
import '../../domain/usecases/get_user_farms.dart';
import 'farm_event.dart';
import 'farm_state.dart';

@injectable
class FarmBloc extends Bloc<FarmEvent, FarmState> {
  final GetUserFarms getUserFarms;
  final CreateFarm createFarm;
  final GetFarmDetails getFarmDetails;

  FarmBloc({
    required this.getUserFarms,
    required this.createFarm,
    required this.getFarmDetails,
  }) : super(const FarmState.initial()) {
    on<FarmEvent>((event, emit) {
      event.when(
        getUserFarms: () => _onGetUserFarms(event, emit),
        getFarmDetails: (farmId) => _onGetFarmDetails(event, emit),
        createFarm: (farm) => _onCreateFarm(event, emit),
        updateFarm: (farm) => _onUpdateFarm(event, emit),
        deleteFarm: (farmId) => _onDeleteFarm(event, emit),
        refreshFarms: () => _onRefreshFarms(event, emit),
      );
    });
  }

  Future<void> _onGetUserFarms(
    FarmEvent event,
    Emitter<FarmState> emit,
  ) async {
    emit(const FarmState.loading());

    final result = await getUserFarms(NoParams());

    result.fold(
      (failure) => emit(FarmState.error(failure.message)),
      (farms) => emit(FarmState.farmsLoaded(farms)),
    );
  }

  Future<void> _onGetFarmDetails(
    FarmEvent event,
    Emitter<FarmState> emit,
  ) async {
    emit(const FarmState.loading());

    final result = await getFarmDetails(
      GetFarmDetailsParams(farmId: event.farmId),
    );

    result.fold(
      (failure) => emit(FarmState.error(failure.message)),
      (details) => emit(FarmState.farmDetailsLoaded(details)),
    );
  }

  Future<void> _onCreateFarm(
    FarmEvent event,
    Emitter<FarmState> emit,
  ) async {
    emit(const FarmState.loading());

    final result = await createFarm(
      CreateFarmParams(farm: event.farm),
    );

    result.fold(
      (failure) => emit(FarmState.error(failure.message)),
      (farm) {
        emit(FarmState.farmCreated(farm));
        // Refresh farms list after creation
        add(const FarmEvent.getUserFarms());
      },
    );
  }

  Future<void> _onRefreshFarms(
    FarmEvent event,
    Emitter<FarmState> emit,
  ) async {
    // Don't emit loading state for refresh to avoid UI flicker
    final result = await getUserFarms(NoParams());

    result.fold(
      (failure) => emit(FarmState.error(failure.message)),
      (farms) => emit(FarmState.farmsLoaded(farms)),
    );
  }

  Future<void> _onUpdateFarm(
    FarmEvent event,
    Emitter<FarmState> emit,
  ) async {
    // TODO: Implement update farm logic
    emit(const FarmState.error('Update farm not implemented'));
  }

  Future<void> _onDeleteFarm(
    FarmEvent event,
    Emitter<FarmState> emit,
  ) async {
    // TODO: Implement delete farm logic
    emit(const FarmState.error('Delete farm not implemented'));
  }
}
