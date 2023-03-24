@isTest
public class EmailUtilsTest {
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
        EmailUtils.sendEmails(testContacts);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        
        System.assert(invocations == 1, 'no email sent');
    }


}