import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/entities/farm.dart';
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
        getUserFarms: () => _onGetUserFarms(emit),
        getFarmDetails: (farmId) => _onGetFarmDetails(farmId, emit),
        createFarm: (farm) => _onCreateFarm(farm, emit),
        updateFarm: (farm) => _onUpdateFarm(farm, emit),
        deleteFarm: (farmId) => _onDeleteFarm(farmId, emit),
        refreshFarms: () => _onRefreshFarms(emit),
      );
    });
  }

  Future<void> _onGetUserFarms(
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
    String farmId,
    Emitter<FarmState> emit,
  ) async {
    emit(const FarmState.loading());

    final result = await getFarmDetails(
      GetFarmDetailsParams(farmId: farmId),
    );

    result.fold(
      (failure) => emit(FarmState.error(failure.message)),
      (details) => emit(FarmState.farmDetailsLoaded(details)),
    );
  }

  Future<void> _onCreateFarm(
    Farm farm,
    Emitter<FarmState> emit,
  ) async {
    emit(const FarmState.loading());

    final result = await createFarm(
      CreateFarmParams(farm: farm),
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
    Farm farm,
    Emitter<FarmState> emit,
  ) async {
    // TODO: Implement update farm logic
    emit(const FarmState.error('Update farm not implemented'));
  }

  Future<void> _onDeleteFarm(
    String farmId,
    Emitter<FarmState> emit,
  ) async {
    // TODO: Implement delete farm logic
    emit(const FarmState.error('Delete farm not implemented'));
  }
}
