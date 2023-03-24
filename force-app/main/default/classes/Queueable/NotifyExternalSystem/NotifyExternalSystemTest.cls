@isTest
public class NotifyExternalSystemTest {
  @isTest
  static void testNotifyExternalSystemWithSuccessCallout() {
      NotifyExternalSystem.doChainJob = false;
      List<Contact> testContacts = new List<Contact>();
      for (Integer i = 0; i < 5; i++) {
          testContacts.add((Contact) TestDataFactory.createSObject('Contact',new Map<String, Object>{
                      'FirstName' => 'Test',
                      'LastName' => 'Contact ' + i,
                      'Email' => 'test' + i + '@example.com'
                  } ));
      }
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(201));
      Test.startTest();
      NotifyExternalSystem notifyExternalSystem = new NotifyExternalSystem(testContacts);
      Id jobId =System.enqueueJob(notifyExternalSystem);
      Test.stopTest();

      List<Contact> updatedContacts = [SELECT Id, Name, Email FROM Contact WHERE Id = :testContacts];
      System.assertEquals(testContacts.size(), updatedContacts.size(), 'Number of updated contacts should be equal to the number of test contacts.');
  }
  @isTest
  static void testNotifyExternalSystemWithFailedCallout() {
      NotifyExternalSystem.doChainJob = false;
      List<Contact> contacts = new List<Contact>();
      for (Integer i = 0; i < 1; i++) {
          contacts.add((Contact) TestDataFactory.createSObject('Contact',new Map<String, Object>{
                      'FirstName' => 'Test',
                      'LastName' => 'Contact ' + i,
                      'Email' => 'test' + i + '@example.com'
                  } ));
      }
      Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(500));
      Test.startTest();
      NotifyExternalSystem notifyExternalSystem = new NotifyExternalSystem(contacts);
      System.enqueueJob(notifyExternalSystem);
      Test.stopTest();
      List<Log__c> logs = [SELECT Message__c, Method__c FROM Log__c];
      System.assert(logs.size() == 1, 'no log is recorded!');
  
      Log__c log = logs.get(0);
      System.assert(log.Message__c.contains('The status code returned was not expected: 500'), 'Incorrect log message!');
  
  }
}