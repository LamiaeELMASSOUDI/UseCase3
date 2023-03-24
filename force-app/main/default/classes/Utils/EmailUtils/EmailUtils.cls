public class EmailUtils {
    public static void sendEmails(List<Contact> contacts) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for (Contact contact : contacts) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] {contact.Email});
            email.setSubject('Registration Confirmation');
            email.setPlainTextBody('Dear ' + contact.Name + ',\n\nThank you for registering for our event.');
            System.debug('Sent emails: ' + emails);
            emails.add(email);
            }
        Messaging.sendEmail(emails);

      }
}