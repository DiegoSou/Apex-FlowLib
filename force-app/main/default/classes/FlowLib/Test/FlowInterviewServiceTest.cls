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

    @IsTest
    static void featureTestTwo()
    {
        // GIVE
        FlowInterviewService_Helper.instance = (FlowInterviewService_IHelper) Test.createStub(FlowInterviewService_IHelper.class, new FlowInterviewService_HelperStub());
        
        FlowInterviewService opportunityStudentAssign = FlowInterviewService.execution().ignoreDone(true);
        
        // WHEN
        opportunityStudentAssign
        .when('Criar_conta_aluno', new Map<String, Object>{ 'student_name' => 'Student Name', 'student_cpf' => 'Student CPF'})
        /** 
         * Output variables:
         *  student_id
        */
        .when('Buscar_curso_disponivel', new Map<String, Object>{ 'course_option_1' => 'featureTestTwoCourse1', 'course_option_2' => 'featureTestTwoCourse2' })
        /** 
         * Output variables:
         *  available_course_id
        */
        .when('Associar_aluno_ao_curso', new Map<String, Object>{ 'accountRecordId' => '{! student_id }', 'opportunityRecordId' => '{! available_course_id }' })
        /** 
         * Input variables:
         *  accountRecordId = student_id (student_id is added as dynamic variable to be filled by the context)
         *  opportunityRecordId = available_course_id (available_course_id is added as dynamic variable to be filled by the context)
         * 
         * Output variables:
         *  operation_result
        */
        .then();

        // THEN
        System.assert(opportunityStudentAssign.dynamicInputs.containsKey('dynamicVariableMock_Name'), 'Dynamic variables should be handled by Service Helper Stub');
    }

    /** 
     * FlowInterviewService_Helper stub provider
    */
    public class FlowInterviewService_HelperStub implements System.StubProvider
    {
        public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, System.Type returnType, List<System.Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs)
        {
            Object returnValue;

            switch on stubbedMethodName 
            {
                when 'listDynamicVariables'
                {
                    returnValue = new Map<String, Object> { 'dynamicVariableMock_Name' => null };
                }
                when 'replaceDynamicVariables'
                {
                    returnValue = new Map<String, Object> { 'dynamicVariableMock_Name' => 'dynamicVariable_Value' };
                }
            }

            return returnValue;
        }
    }
}