public class CaseTriggerHelper {
    private static final String WEB = 'Web';
    private static final String PHONE = 'Phone';
  
    public static void validateCase(List<Case> newCases) {
        Map<Id, Set<Case>> accoutIdToCases = CaseUtils.getAccountIdToCases(newCases);
        Set<Id> accountIds = accoutIdToCases.keySet();
        List<Account> accounts = [
          SELECT Id, Name, (SELECT id FROM Contacts)
          FROM Account
          WHERE Id IN :accountIds
        ];
        for (Account account : accounts) {
          Integer numberOfContacts = account.Contacts.size();
          Set<Case> accountCases = accoutIdToCases.get(account.Id);
          for (Case accountCase : accountCases) {
            if (numberOfContacts == 0) {
              accountCase.addError('You cannot create a request for accounts without contacts');
            } else if (WEB.equals(accountCase.Origin) && numberOfContacts >= 2) {
              accountCase.addError('Web request are only allowed to have one attendee');
            } else if (PHONE.equals(accountCase.Origin) && numberOfContacts >= 4) {
              accountCase.addError('Phone request are only allowed to have three attendee');
            }
          }
        }
      }
        

    public static void handleUpdate(List<Case> newCases, Map<Id, Case> oldMap) {
        Set<Id> accountsIds = CaseUtils.getAccountsIdsForClosedCases(newCases,oldMap);
        List<Contact> contacts = [SELECT Name, Email FROM Contact WHERE AccountId IN :accountsIds];
        if (!contacts.isEmpty()) {
            NotifyExternalSystem notifyExternalSystem = new NotifyExternalSystem(contacts);
            System.enqueueJob(notifyExternalSystem);
        }
    }
}