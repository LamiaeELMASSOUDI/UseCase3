@isTest
public class SendEmailTest {
   @isTest
    static void testSendEmail() {
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            testContacts.add((Contact) TestDataFactory.createSObject('Contact',new Map<String, Object>{
                        'FirstName' => 'Test',
                        'LastName' => 'Contact ' + i,
                        'Email' => 'test' + i + '@example.com'
                    } ));
        }
        
        Test.startTest();
        SendEmail sendEmailJob = new SendEmail(testContacts);
        Id jobId =System.enqueueJob(sendEmailJob);
        Test.stopTest();
        System.assertEquals('Completed', [SELECT Status FROM AsyncApexJob WHERE Id = :jobId].Status, 'no email sent !');
    }
  }
