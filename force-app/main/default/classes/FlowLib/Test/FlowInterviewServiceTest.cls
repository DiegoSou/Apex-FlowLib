/** 
 * @author Diego
 * Essa classe faz parte da FlowLib
 * Mais informações: https://github.com/DiegoSou/Apex-FlowLib
*/

@SuppressWarnings('PMD')

@IsTest
private class FlowInterviewServiceTest
{
    /** 
     * Objetivos:
     * 
     * Registrar entrevistas de fluxo em sequência.
     * Ao utilizar o método .then() as entrevistas devem ser marcadas como "done".
    */
    @IsTest
    static void featureTestOne()
    {
        // GIVE
        FlowInterviewService test_AutoLaunch = FlowInterviewService.execution();

        // WHEN
        test_AutoLaunch
        .when('Test_AutoLaunchFlowOne')
        .when('Test_AutoLaunchFlowTwo')
        .then();

        // THEN
        System.assertEquals(2, test_AutoLaunch.getInterviews().size(), 'The flow service should have 2 interviews registered');
        System.assert(test_AutoLaunch.getInterviews()[0].hasDone(), 'The flow interview one should be marked as done.');
        System.assert(test_AutoLaunch.getInterviews()[1].hasDone(), 'The flow interview two should be marked as done.');
    }

    /** 
     * Objetivos:
     * 
     * Mapear as variáveis dinâmicas através da chamada do método when().
     * O controle da lógica das variáveis dinâmicas é feito pela classe FlowInterviewService_Helper (Stub)
    */
    @IsTest
    static void featureTestTwo()
    {
        // GIVE
        FlowInterviewService test_AutoLaunch = FlowInterviewService.execution();
        FlowInterviewService_Helper.instance = (FlowInterviewService_IHelper) Test.createStub(
            FlowInterviewService_IHelper.class, new FlowInterviewServiceTestStubs.FlowInterviewService_Helper()
        );        
        
        // WHEN
        test_AutoLaunch
        .when('Test_AutoLaunchFlowOne', new Map<String, Object>{ 
            'input_variable_name' => 'value'
        })
        .when('Test_AutoLaunchFlowTwo', new Map<String, Object>{
            'input_variable_name' => '{!dynamicVar}'
        })
        .then();

        // THEN
        System.assert(test_AutoLaunch.dynamicInputs.containsKey('dynamicVar'), 'Dynamic variables should be handled by Service Helper Stub');
    }

    /** 
     * Objetivos:
     * 
     * Mapear as variáveis dinâmicas através da chamada do método registerDynamic().
     * O controle da lógica das variáveis dinâmicas é feito pela classe FlowInterviewService_Helper (Stub)
    */
    @IsTest
    static void featureTestThree()
    {
        // GIVE
        FlowInterviewService test_AutoLaunch = FlowInterviewService.execution();
        FlowInterviewService_Helper.instance = (FlowInterviewService_IHelper) Test.createStub(
            FlowInterviewService_IHelper.class, new FlowInterviewServiceTestStubs.FlowInterviewService_Helper()
        );        
        
        // WHEN
        test_AutoLaunch
        .when('Test_AutoLaunchFlowOne', new Map<String, Object>{ 
            'input_variable_name' => 'value'
        })
        .registerDynamic('dynamicVar')
        .then();

        // THEN
        System.assert(test_AutoLaunch.dynamicInputs.containsKey('dynamicVar'), 'Dynamic variables should be handled by Service Helper Stub');
    }

    /** 
     * Objetivos:
     * 
     * Adicionar uma nova entrevista após já ter feito uma execução.
     * A segunda execução só acontece se a primeira atender uma determinada condição
    */
    @IsTest
    static void featureTestFour()
    {
        // GIVE
        FlowInterviewService test_AutoLaunch = FlowInterviewService.execution();
        
        test_AutoLaunch
        .when('Test_AutoLaunchFlowOne')
        .then();
        
        // WHEN
        if (test_AutoLaunch.getInterviews()[0].hasDone())
        {
            test_AutoLaunch.ignoreDone(true)
            .when('Test_AutoLaunchFlowTwo')
            .then();
        }

        // THEN
        System.assertEquals(2, test_AutoLaunch.getInterviews().size(), 'The flow service should have 2 interviews registered');
        System.assert(test_AutoLaunch.getInterviews()[0].hasDone(), 'The flow interview one should be marked as done.');
        System.assert(test_AutoLaunch.getInterviews()[1].hasDone(), 'The flow interview two should be marked as done.');
    }

    /** 
     * Objetivos:
     * 
     * Fazer a cobertura do código do contrato de handler padrão.
     * Variáveis dinâmicas devem ser preenchidas se a entrevista de fluxo tiver algum valor em uma variável de mesmo nome
    */
    @IsTest
    static void defaultOutputHandlerTest()
    {
        // GIVE
        FlowInterviewModel modelStub = (FlowInterviewModel) Test.createStub(
            FlowInterviewModel.class, new FlowInterviewServiceTestStubs.FlowInterviewModel()
        );

        Map<String, Object> dynamicVariables = new Map<String, Object>{
            'dynamicVar' => null
        };

        // WHEN
        Map<String, Object> output = new FlowInterviewService.DefaultOutputHandler().handle(modelStub, dynamicVariables);

        // THEN
        System.assertEquals('This is the dynamicVar value', output.get('dynamicVar'), 'Dynamic variables value must be replaced if the flow interview has the value');
    }

    /** 
     * Objetivos:
     * 
     * Fazer a cobertura do código do contrato de finalizer padrão.
     * Deve fazer a chamada dos métodos success e error de acordo com o resultado da execução 
    */
    @IsTest
    static void defaultFinalizerTest()
    {
        // GIVE
        FlowInterviewService test_AutoLaunch = FlowInterviewService.execution();
        Exception e = new NullPointerException();

        // WHEN
        
            // success
            new FlowInterviewService.DefaultFinalizer().execute(test_AutoLaunch, null);
            
            // error
            new FlowInterviewService.DefaultFinalizer().execute(test_AutoLaunch, e);

        // THEN
    }
}