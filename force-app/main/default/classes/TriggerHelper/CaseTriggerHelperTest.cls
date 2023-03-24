@isTest
public class CaseTriggerHelperTest {
    private static final String CASE_SUBJECT = 'Event Booking';

    private static Account createAccount() {
        return (Account) TestDataFactory.createSObject(
            'Account',
            new Map<String, Object>{ 'Name' => 'Salesforce' }
        );
    }

    private static List<Contact> createContacts(Account account, Integer numContacts) {
        Contact contactItem;
        List<Contact> contacts= new List<Contact>();
        for (Integer i = 0; i < numContacts; i++) {
            contactItem = (Contact) TestDataFactory.createSObject(
                'Contact',
                new Map<String, Object>{
                    'LastName' => 'Contact ' + i,
                    'AccountId' => account.Id
                }
            );
            contacts.add(contactItem);
        }
        return contacts;
    }

    @isTest
    public static void refuseCaseCreationWhenNoContactIsAttachedToAnAccount(){
        // Given
        Account a1 = createAccount();
        Case request = new Case(Origin = 'Phone',Subject = 'Event Booking', Description = 'Book Spots', AccountId = a1.ID);
        
        // When 
        Test.startTest();
        Database.SaveResult result = Database.insert(request, false);
        Test.stopTest();

        // Then
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('You cannot create a request for accounts without contacts',
        result.getErrors()[0].getMessage());
    }

    @isTest
    static void refuseEventBookingWhenNumberOfAttendeesIsThwoForWebCases() {
        Account account = createAccount();
        Case request = new Case(Origin = 'Web', AccountId = account.Id);
        List<Contact> contacts = createContacts(account,2);
        Test.startTest();
        Database.SaveResult result = Database.insert(request, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assertEquals('Web request are only allowed to have one attendee', result.getErrors()[0].getMessage(), 'Incorrect error message.');
    }
    
    @isTest
    public static void refuseEventBookingWhenNumberOfAttendeesIsFourForPhoneCases(){
        // Given
        Account a1 = createAccount();   
        List<Contact> contacts = createContacts(a1,4);
        Case request = new Case(Origin = 'Phone',Subject = 'Event Booking', Description = 'Book Spots for Company A1 & their 4 employees', AccountId = a1.ID);
        
        // When 
        Test.startTest();
        Database.SaveResult result = Database.insert(request, false);
        Test.stopTest();

        // Then
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Phone request are only allowed to have three attendee',
        result.getErrors()[0].getMessage());

    }

    @isTest
    public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanFourForPhoneCases(){
        // Given
        Account a1 = createAccount();   
        List<Contact> contacts = createContacts(a1,5);
        Case request = new Case(Origin = 'Phone',Subject = 'Event Booking', Description = 'Book Spots for Company A1 & their 5 employees', AccountId = a1.ID);
        
        // When 
        Test.startTest();
        Database.SaveResult result = Database.insert(request, false);
        Test.stopTest();

        // Then
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Phone request are only allowed to have three attendee',
        result.getErrors()[0].getMessage());

    }

    @isTest
    public static void refuseCaseCreationWhenAnAccountIsNotAttachedToACase(){
        // Given
        Case request = new Case(Origin = 'Phone',Subject = 'Event Booking', Description = 'Book Spots');  

        // When 
        Test.startTest();
        Database.SaveResult result = Database.insert(request, false);
        Test.stopTest();

        // Then
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('You cannot create a request without attaching an account',
        result.getErrors()[0].getMessage());
    }

    @isTest
    public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanOneForWebCases(){
        // Given
        
        Account a1 = createAccount();   
        List<Contact> contacts = createContacts(a1,3);
        Case request = new Case(Origin = 'Web',Subject = 'Event Booking', Description = 'Book Spots for Company A1 & their 3 employees', AccountId = a1.ID);
        
        // When 
        Test.startTest();
        Database.SaveResult result = Database.insert(request, false);
        Test.stopTest();

        // Then
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Web request are only allowed to have one attendee',
        result.getErrors()[0].getMessage()); 
    } 

    @isTest
    public static void bookEventFromTheWeb(){
        // Given
        Account a1 = createAccount();   
        List<Contact> contacts = createContacts(a1,1);
        Case request = new Case(Origin = 'Web',Subject = 'Event Booking', Description = 'Book One Spot for Company A1', AccountId = a1.ID);
        
        // When 
        Test.startTest();
        Database.SaveResult result = Database.insert(request, false);
        Test.stopTest();

        // Then
        System.assert(result.isSuccess());
    } 
    
    @isTest
    public static void bookEventFromPhone(){
        // Given    
        Account a1 = createAccount();   
        List<Contact> contacts = createContacts(a1,3);
        Case request = new Case(Origin = 'Phone',Subject = 'Event Booking', Description = 'Book Spots for Company A1 & their 3 employees', AccountId = a1.ID);
        
        // When 
        Test.startTest();
        Database.SaveResult result = Database.insert(request, false);
        Test.stopTest();

        // Then
        System.assert(result.isSuccess());
    }

}