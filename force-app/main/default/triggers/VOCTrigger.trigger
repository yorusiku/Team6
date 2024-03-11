trigger VOCTrigger on VOC__c (before insert, before update, after insert, after update, after delete, after undelete) {
    // Trigger.isAfter 조건은 모든 분기에 공통적이므로, 이를 최상위에서 한 번만 검사합니다.
    if(Trigger.isAfter) {  
        // insert 또는 update 이벤트가 발생했을 경우, Trigger.new 컬렉션을 사용합니다.
        if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
            VOCTriggerHandler.updateVOCCount(Trigger.new);
        }
        
        // delete 이벤트가 발생했을 경우, Trigger.old 컬렉션을 사용합니다.
        if (Trigger.isDelete) {
            VOCTriggerHandler.updateVOCCount(Trigger.old);
        }
    }

    // if (Trigger.isBefore) {
    //     if (Trigger.isInsert || Trigger.isUpdate) {
    //         VOCTriggerHandler.validateCheckbox(Trigger.new);
    //     }
    // }
}