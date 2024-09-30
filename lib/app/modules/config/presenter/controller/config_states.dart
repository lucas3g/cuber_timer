abstract class ConfigStates {}

class ConfigInitialState extends ConfigStates {}

class AdRemovalInProgressState extends ConfigStates {}

class AdRemovalSuccessState extends ConfigStates {}

class AdRemovalFailureState extends ConfigStates {
  final String errorMessage;

  AdRemovalFailureState(this.errorMessage);
}
