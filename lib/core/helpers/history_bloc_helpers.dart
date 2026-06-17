import '../../features/image_url/domain/usecases/image_url.dart';
import '../../features/logging/domain/usecases/logging.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../features/history/data/models/history_model.dart';

Future<List<HistoryModel>> historyModelsWithPosterUris({
  required String tautulliId,
  required List<HistoryModel> historyList,
  required ImageUrl imageUrl,
  required SettingsBloc settingsBloc,
  required Logging logging,
}) async {
  List<HistoryModel> historyWithImages = [];

  for (HistoryModel history in historyList) {
    final failureOrImageUrl = await imageUrl.getImageUrl(
      tautulliId: tautulliId,
      img: history.thumb,
      ratingKey: history.ratingKey,
    );

    await failureOrImageUrl.fold(
      (failure) async {
        logging.error(
          'History :: Failed to fetch image url for ${history.id} [$failure]',
        );

        historyWithImages.add(history);
      },
      (imageUri) async {
        settingsBloc.add(
          SettingsUpdatePrimaryActive(
            tautulliId: tautulliId,
            primaryActive: imageUri.value2,
          ),
        );

        historyWithImages.add(
          history.copyWith(
            posterUri: imageUri.value1,
          ),
        );
      },
    );
  }

  return historyWithImages;
}
