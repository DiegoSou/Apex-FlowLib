@SuppressWarnings('PMD')

@IsTest
private class FlowInterviewServiceTest 
{
    @IsTest
    static void featureTestOne()
    {
        // GIVE
        FlowInterviewService test_AutoLaunch = FlowInterviewService.execution();

        // WHEN
        test_AutoLaunch.ignoreDone(true)
        .when('Test_AutoLaunchFlowOne')
        .when('Test_AutoLaunchFlowTwo')
        .then();

        // THEN
        System.assertEquals(2, test_AutoLaunch.handlers.size(), 'The flow service should have 2 key-value pairs');
        System.assert(
            new List<FlowInterviewModel>(test_AutoLaunch.handlers.keySet())[0].hasDone(),
            'The flow interview one should execute correctly.'
        );
        System.assert(
            new List<FlowInterviewModel>(test_AutoLaunch.handlers.keySet())[1].hasDone(),
            'The flow interview two should execute correctly.'
        );
    }
}