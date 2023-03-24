public class CaseTriggerHandler extends TriggerHandler{
  
    public override void beforeInsert() {
      CaseTriggerHelper.validateCase((List<Case>) Trigger.new);
    }
  
    public override void beforeUpdate() {
      CaseTriggerHelper.handleUpdate((List<Case>)Trigger.new, (Map<Id, Case>) Trigger.oldMap);
    }
}