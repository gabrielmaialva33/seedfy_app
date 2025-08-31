import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/farm.dart';
import '../../domain/usecases/get_farm_details.dart';

part 'farm_state.freezed.dart';

@freezed
class FarmState with _$FarmState {
  const factory FarmState.initial() = _Initial;
  const factory FarmState.loading() = _Loading;
  const factory FarmState.farmsLoaded(List<Farm> farms) = _FarmsLoaded;
  const factory FarmState.farmDetailsLoaded(FarmDetailsResult details) = _FarmDetailsLoaded;
  const factory FarmState.farmCreated(Farm farm) = _FarmCreated;
  const factory FarmState.farmUpdated(Farm farm) = _FarmUpdated;
  const factory FarmState.farmDeleted() = _FarmDeleted;
  const factory FarmState.error(String message) = _Error;
}