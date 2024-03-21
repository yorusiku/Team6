// VOC 레코드에 대한 트리거
trigger VOCTrigger on VOC__c (after insert, after update, before delete) {
    // 삽입 또는 업데이트 이벤트 후
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        // VOCTriggerHandler 클래스의 updateVOCCount 메서드 호출하여 VOC 카운트 업데이트
        VOCTriggerHandler.updateVOCCount(Trigger.new, Trigger.oldMap);
    }
    // 삭제 이벤트 전
    else if (Trigger.isBefore && Trigger.isDelete) {
        // VOCTriggerHandler 클래스의 updateVOCCountOnDeleteTrigger 메서드 호출하여 VOC 카운트 업데이트
        VOCTriggerHandler.updateVOCCountOnDeleteTrigger(Trigger.old, Trigger.oldMap);
    }
}