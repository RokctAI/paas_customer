import '../../domain/interface/processing_contract.dart';

/// Pure transition rules for the generalized lifecycle.
///
/// Kept free of I/O so feature SDKs and backends can share identical rules.
class ProcessingStateMachine {
  /// Allowed transitions. Anything not listed is rejected.
  static const Map<ProcessingState, Set<ProcessingState>> transitions = {
    ProcessingState.draft: {
      ProcessingState.submitted,
      ProcessingState.cancelled,
    },
    ProcessingState.submitted: {
      ProcessingState.accepted,
      ProcessingState.failed,
      ProcessingState.cancelled,
    },
    ProcessingState.accepted: {
      ProcessingState.processing,
      ProcessingState.cancelled,
    },
    ProcessingState.processing: {
      ProcessingState.ready,
      ProcessingState.active,
      ProcessingState.failed,
    },
    ProcessingState.ready: {
      ProcessingState.dispatched,
      ProcessingState.completed,
    },
    ProcessingState.dispatched: {
      ProcessingState.completed,
      ProcessingState.failed,
    },
    ProcessingState.active: {
      ProcessingState.completed,
      ProcessingState.cancelled,
    },
    ProcessingState.completed: {},
    ProcessingState.failed: {ProcessingState.submitted},
    ProcessingState.cancelled: {},
  };

  static bool canTransition(ProcessingState from, ProcessingState to) {
    return transitions[from]?.contains(to) ?? false;
  }

  /// Returns the reachable next states from [from].
  static Set<ProcessingState> nextStates(ProcessingState from) {
    return transitions[from] ?? const {};
  }

  static bool isTerminal(ProcessingState s) => nextStates(s).isEmpty;
}
