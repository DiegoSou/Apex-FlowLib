/** 
 * @author Diego
 * Essa classe faz parte da FlowLib
 * Mais informações: https://github.com/DiegoSou/Apex-FlowLib
*/

@SuppressWarnings('PMD')

@IsTest
@TestVisible
private class FlowInterviewServiceTestStubs
{
    /** 
     * FlowInterviewService_Helper stub
    */
    public class FlowInterviewService_Helper implements System.StubProvider
    {
        public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, System.Type returnType, List<System.Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs)
        {
            Object returnValue;

            switch on stubbedMethodName 
            {
                when 'listDynamicVariables'
                {
                    returnValue = new Map<String, Object> { 'dynamicVar' => null };
                }
                when 'replaceDynamicVariables'
                {
                    returnValue = new Map<String, Object> { 'dynamicVar' => 'dynamicValue' };
                }
            }

            return returnValue;
        }
    }

    /** 
     * FlowInterviewModel stub
    */
    public class FlowInterviewModel implements System.StubProvider
    {
        public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, System.Type returnType, List<System.Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs)
        {
            Object returnValue;

            switch on stubbedMethodName 
            {
                when 'getVariableValue'
                {
                    String variableName = (String) listOfArgs[0];

                    if (variableName == 'dynamicVar')
                    {
                        returnValue = 'This is the dynamicVar value';
                    }
                }
            }

            return returnValue;
        }
    }
}