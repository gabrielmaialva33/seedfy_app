import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/farm.dart';

part 'farm_event.freezed.dart';

@freezed
class FarmEvent with _$FarmEvent {
  const factory FarmEvent.getUserFarms() = _GetUserFarms;
  const factory FarmEvent.getFarmDetails(String farmId) = _GetFarmDetails;
  const factory FarmEvent.createFarm(Farm farm) = _CreateFarm;
  const factory FarmEvent.updateFarm(Farm farm) = _UpdateFarm;
  const factory FarmEvent.deleteFarm(String farmId) = _DeleteFarm;
  const factory FarmEvent.refreshFarms() = _RefreshFarms;
}