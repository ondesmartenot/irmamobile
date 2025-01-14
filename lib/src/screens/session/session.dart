// This code is not null safe yet.
// @dart=2.11

class SessionScreenArguments {
  final int sessionID;
  final String sessionType;
  final bool hasUnderlyingSession;
  final bool wizardActive;
  final String wizardCred;

  SessionScreenArguments({
    this.sessionID,
    this.sessionType,
    this.hasUnderlyingSession,
    this.wizardActive,
    this.wizardCred,
  });
}
