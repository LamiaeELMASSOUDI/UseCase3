public class SendEmail implements Queueable {
   public List<Contact> contacts ;
    public SendEmail(List<Contact> contacts){
        this.contacts = contacts;
    }
    public void execute(QueueableContext context) {
        EmailUtils.sendEmails(contacts);
        update contacts;
    }
}