// REQ-11
//첫 구매를 진행한 판매점 , 최근 구매 매장 표시해주는 트리거
trigger ContactTrigger on Contact (before insert, before update) {
    if (Trigger.isInsert) {
        if(Trigger.isBefore){

        }else if (Trigger.isAfter){

        }
    }

    if(Trigger.isUpdate){
        if(Trigger.isBefore){

        }else if(Trigger.isAfter){

        }
    }
}

