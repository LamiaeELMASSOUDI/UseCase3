public class CaseUtils {
    private static final String CLOSED = 'Closed';

    public static Map<Id, Set<Case>> getAccountIdToCases(List<Case> cases) {
        Map<Id, Set<Case>> accountIdToCases = new Map<Id, Set<Case>>();
        for (Case request : cases) {
          if (request.AccountId != null) {
            Id accountId = request.AccountId;
            if (accountIdToCases.containsKey(accountId)) {
              accountIdToCases.get(accountId).add(request);
            } else {
              accountIdToCases.put(accountId, new Set<Case>{ request });
            }
          } else {
            request.addError('You cannot create a request without attaching an account');
          
          }
        }
        return accountIdToCases;
      }

      public static Set<Id> getAccountsIdsForClosedCases(List<Case> updatedCases, Map<Id, Case> oldIdToCase) {
        Set<Id> accountsIds = new Set<Id>();
        for (Case updatedCase : updatedCases) {
          Case oldCase = oldIdToCase.get(updatedCase.Id);
          if (!CLOSED.equals(oldCase.Status) && CLOSED.equals(updatedCase.Status)) {
            if (updatedCase.AccountId != null) {
              accountsIds.add(updatedCase.AccountId);
            }
          }
        }
    
        return accountsIds;
      }
    
}