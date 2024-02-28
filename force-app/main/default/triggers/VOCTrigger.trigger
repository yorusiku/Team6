trigger VOCTrigger on VOC__c (after insert, after update, after delete) {
  // 총 VOC 횟수 카운트 하는 트리거
  if(Trigger.isAfter) {  
      if (Trigger.isInsert || Trigger.isUpdate) {
          VOCTriggerHandler.updateVOCCount(Trigger.new);
      }
    
      if (Trigger.isDelete) {
          VOCTriggerHandler.updateVOCCount(Trigger.old);
      }
  }
}