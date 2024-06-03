/** 
 * @author Diego
 * Essa classe faz parte da FlowLib
 * Mais informações: https://github.com/DiegoSou/Apex-FlowLib
*/

@IsTest
private class FlowInterviewService_HelperTest 
{
    private static Map<String, Object> getInputVariables()
    {
        return new Map<String, Object> {
            'variable_1' => 'Test value',
            'variable_2' => '{! dynamic_variable_1 }',
            'variable_3' => 'Test value',
            'variable_4' => '{! dynamic_variable_2 }'
        };
    }

    @IsTest
    static void serviceHelperTestOne()
    {
        // GIVE
        Map<String, Object> inputVariables = getInputVariables();

        // WHEN
        Map<String, Object> dynamicVariables = FlowInterviewService_Helper.instance.listDynamicVariables(inputVariables);
        
        // THEN
        Iterator<String> iterator = dynamicVariables.keySet().iterator();
        String firstDynamicVariable = iterator.next();
        String secondDynamicVariable = iterator.next();

        System.assert(dynamicVariables.keySet().size() == 2, 'The size of dynamic variables listed should be equals 2');
        System.assert(firstDynamicVariable == 'dynamic_variable_1', 'First dynamic variable name shoud be equals dynamic_variable_1');
        System.assert(secondDynamicVariable == 'dynamic_variable_2', 'Second dynamic variable name shoud be equals dynamic_variable_2');
    }

    @IsTest
    static void serviceHelperTestTwo()
    {
        // GIVE
        Map<String, Object> inputVariables = getInputVariables();
        Map<String, Object> outputs = new Map<String, Object> {
            'dynamic_variable_1' => 'Dynamic Value 1',
            'dynamic_variable_2' => 'Dynamic Value 2'
        };
       
        // WHEN
        Map<String, Object> dynamicVariablesWithValue = FlowInterviewService_Helper.instance.replaceDynamicVariables(inputVariables, outputs);

        // THEN
        System.assert(dynamicVariablesWithValue.keySet().size() == 2, 'The size of dynamic variables listed should be equals 2');
        System.assert(
            ((String) dynamicVariablesWithValue.get('variable_2') == 'Dynamic Value 1'),
            'First dynamic variable value shoud be assigned correctly'
        );
        System.assert(
            ((String) dynamicVariablesWithValue.get('variable_4') == 'Dynamic Value 2'),
            'Second dynamic variable value shoud be assigned correctly'
        );
    }
}