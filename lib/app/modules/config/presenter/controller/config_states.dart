abstract class ConfigStates {}

class ConfigInitialState extends ConfigStates {}

class AdRemovalInProgressState extends ConfigStates {
  final String message;

  AdRemovalInProgressState({this.message = 'Removendo anúncios...'});
}

class AdRemovalSuccessState extends ConfigStates {
  final String message;

  AdRemovalSuccessState({this.message = 'Anúncios removidos com sucesso!'});
}

class AdRemovalCanceledState extends ConfigStates {
  final String message;

  AdRemovalCanceledState({this.message = 'Remoção de anúncios cancelada'});
}

class AdRemovalFailureState extends ConfigStates {
  final String errorMessage;

  AdRemovalFailureState(this.errorMessage);
}
