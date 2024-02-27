public class ConsultantCountController {
    public static void updateConsultationCount(Id contactId) {
        // 상담 횟수 업데이트
        List<Contact> contactsToUpdate = new List<Contact>();

        Integer consultantCount = [SELECT COUNT() FROM Consultant__c WHERE CustomerName__c = :contactId];

        contactsToUpdate.add(new Contact(Id = contactId, 
            Consultation_Count__c = consultantCount));

        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}