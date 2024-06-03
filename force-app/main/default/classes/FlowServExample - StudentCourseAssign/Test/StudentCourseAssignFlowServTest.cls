/** 
 * @author Diego
 * Essa classe faz parte de um caso de uso exemplo para utilizar a FlowLib
 * Mais informações: https://github.com/DiegoSou/Apex-FlowLib
*/

@SuppressWarnings('PMD')

@IsTest
private class StudentCourseAssignFlowServTest 
{
    /** 
     * Objetivos:
     * 
     * Testar a execução padrão do método assignStudentToCourse().
     * As entrevistas de fluxo, handlers e finalizers não são executadas em contexto de teste.
    */
    @IsTest
    static void assignStudentToCourseTest()
    {
        // GIVE
        StudentCourseAssignFlowServ service = new StudentCourseAssignFlowServ();

        // WHEN
        service.assignStudentToCourse('Test student name', 'Test course name');

        // THEN
    }

    /** 
     * Objetivos:
     * 
     * Construir a finalizer da primeira entrevista de fluxo passando o parâmetro "courseName" e chamar o método execute()
     * As entrevistas de fluxo, handlers e finalizers não são executadas em contexto de teste.
    */
    @IsTest
    static void createNewAccFlowFinalizerTest()
    {
        // GIVE
        StudentCourseAssignFlowServ.CreateNewAccFlowFinalizer finalizer = new StudentCourseAssignFlowServ.CreateNewAccFlowFinalizer('Test Course Name');
        
        FlowInterviewService execution = FlowInterviewService.execution();
        execution.outputs.put('account_id', '001');

        // WHEN
        finalizer.execute(execution, null);

        // THEN
    }

    /** 
     * Objetivos:
     * 
     * Construir a handler da segunda entrevista de fluxo e executar o método handle().
     * Testar o armazenamento do output opportuntiy_id
    */
    @IsTest
    static void findOppsByNameHandlerTestOne()
    {
        // GIVE
        StudentCourseAssignFlowServ.FindOppsByNameHandler handler = new StudentCourseAssignFlowServ.FindOppsByNameHandler();

        List<Opportunity> stubOpps = new List<Opportunity>{
            new Opportunity(Name = 'Test Opp Name')
        };

        FlowInterviewModel modelStub = (FlowInterviewModel) Test.createStub(
            FlowInterviewModel.class, new StudentCourseAssignFlowServTestStubs.FlowInterviewModel(stubOpps)
        );

        Map<String, Object> dynamicVariables = new Map<String, Object>();

        // WHEN
        Map<String, Object> handlerOutputs = handler.handle(modelStub, dynamicVariables);

        // THEN
        System.assert(handlerOutputs.containsKey('opportunity_id'), 'Handler must return the opportunity id from interview stub');
    }

    /** 
     * Objetivos:
     * 
     * Construir a handler da segunda entrevista de fluxo e executar o método handle().
     * Testar o armazenamento do output case_id
    */
    @IsTest
    static void findOppsByNameHandlerTestTwo()
    {
        // GIVE
        StudentCourseAssignFlowServ.FindOppsByNameHandler handler = new StudentCourseAssignFlowServ.FindOppsByNameHandler();
        
        List<Opportunity> stubOpps = new List<Opportunity>();

        FlowInterviewModel modelStub = (FlowInterviewModel) Test.createStub(
            FlowInterviewModel.class, new StudentCourseAssignFlowServTestStubs.FlowInterviewModel(stubOpps)
        );

        Map<String, Object> dynamicVariables = new Map<String, Object>();

        // WHEN
        Map<String, Object> handlerOutputs = handler.handle(modelStub, dynamicVariables);

        // THEN
        System.assert(handlerOutputs.containsKey('case_id'), 'Handler must return the inserted case id');
    }

    /** 
     * Objetivos:
     * 
     * Construir a finalizer da segunda entrevista de fluxo e executar o método execute()
     * Testar o rotemento para o caminho de assignToCourse()
    */
    @IsTest
    static void findOppsByNameFinalizerTestOne()
    {
        // GIVE
        StudentCourseAssignFlowServ.FindOppsByNameFinalizer finalizer = new StudentCourseAssignFlowServ.FindOppsByNameFinalizer();

        FlowInterviewService execution = FlowInterviewService.execution();
        execution.outputs.put('account_id', '');
        execution.outputs.put('opportunity_id', '');

        // WHEN
        finalizer.execute(execution, null);

        // THEN
    }

    /** 
     * Objetivos:
     * 
     * Construir a finalizer da segunda entrevista de fluxo e executar o método execute()
     * Testar o rotemento para o caminho de assignToCase()
    */
    @IsTest
    static void findOppsByNameFinalizerTestTwo()
    {
        // GIVE
        StudentCourseAssignFlowServ.FindOppsByNameFinalizer finalizer = new StudentCourseAssignFlowServ.FindOppsByNameFinalizer();

        FlowInterviewService execution = FlowInterviewService.execution();
        execution.outputs.put('account_id', '');
        execution.outputs.put('case_id', '');

        // WHEN
        finalizer.execute(execution, null);

        // THEN
    }
}