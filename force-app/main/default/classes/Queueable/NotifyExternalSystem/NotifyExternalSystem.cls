public class NotifyExternalSystem implements Queueable, Database.AllowsCallouts{
    @testVisible
    private static Boolean doChainJob = true;
    private List<Contact> contacts;

    public NotifyExternalSystem(List<Contact> contacts) {
        this.contacts = contacts;
    }
    public void execute(QueueableContext context) {
        List<Contact> updatedContacts = new List<Contact>();
        for (Contact contact: contacts ) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Reservation_System_API');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody('{"name":"' + contact.Name + '-' + contact.Email + '}');
            HttpResponse response = http.send(request);
            if (response.getStatusCode() != 201) {
              Log.error('The status code returned was not expected: ' +response.getStatusCode() +' ' + response.getStatus());
            } else {
                updatedContacts.add(contact);
            }
        }
        if(!updatedContacts.isEmpty()&& doChainJob){
            SendEmail sendEmail = new SendEmail(updatedContacts);
            System.enqueueJob(sendEmail);    
         }
    }
}