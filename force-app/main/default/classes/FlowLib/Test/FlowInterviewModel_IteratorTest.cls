@IsTest
private class FlowInterviewModel_IteratorTest 
{
    private static Set<FlowInterviewModel> getFlowInterviewSet()
    {   
        Set<FlowInterviewModel> flowInterviews = new Set<FlowInterviewModel>();
        for (Integer i = 1; i <= 5; i++)
        {
            flowInterviews.add(new FlowInterviewModel('Test Flow '+String.valueOf(i), new Map<String, Object>{'key' => 'value'}));
        }
        return flowInterviews;
    }

    @IsTest
    static void iteratorTestOne()
    {
        // GIVE
        FlowInterviewModel_Iterator iterator = new FlowInterviewModel_Iterator(
            new List<FlowInterviewModel>(getFlowInterviewSet())
        );

        // WHEN
        Boolean hasFirst = iterator.hasNext();

        FlowInterviewModel firstRecord = iterator.next();
        FlowInterviewModel secondRecordWithoutChange = iterator.nextWithoutChange();
        FlowInterviewModel secondRecord = iterator.next();
        FlowInterviewModel lastRecord;

        while (iterator.hasNext()) 
        {
            lastRecord = iterator.next();
        }

        // THEN
        System.assert(hasFirst, 'The iterator should have more than 0 elements');
        System.assert(firstRecord.getFlowName() == 'Test Flow 1', 'The first element should be named as Test Flow 1');
        System.assert(secondRecordWithoutChange == secondRecord, 'The iterator should not change the index when calling nextWithoutChange');
        System.assert(lastRecord.getFlowName() == 'Test Flow 5', 'The last element should be named as Test Flow 5');
    }

    @IsTest
    static void iteratorTestTwo()
    {
        // GIVE
        FlowInterviewModel_Iterator iterator = new FlowInterviewModel_Iterator(
            getFlowInterviewSet()
        );

        // WHEN
        Boolean hasFirst = iterator.hasNext();

        FlowInterviewModel firstRecord = iterator.next();
        FlowInterviewModel secondRecordWithoutChange = iterator.nextWithoutChange();
        FlowInterviewModel secondRecord = iterator.next();
        FlowInterviewModel lastRecord;

        while (iterator.hasNext()) 
        {
            lastRecord = iterator.next();
        }

        // THEN
        System.assert(hasFirst, 'The iterator should have more than 0 elements');
        System.assert(firstRecord.getFlowName() == 'Test Flow 1', 'The first element should be named as Test Flow 1');
        System.assert(secondRecordWithoutChange == secondRecord, 'The iterator should not change the index when calling nextWithoutChange');
        System.assert(lastRecord.getFlowName() == 'Test Flow 5', 'The last element should be named as Test Flow 5');
    }
}