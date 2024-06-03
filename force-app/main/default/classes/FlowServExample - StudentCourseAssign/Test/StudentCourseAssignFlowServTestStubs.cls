/** 
 * @author Diego
 * Essa classe faz parte de um caso de uso exemplo para utilizar a FlowLib
 * Mais informações: https://github.com/DiegoSou/Apex-FlowLib
*/

@SuppressWarnings('PMD')

@IsTest
@TestVisible
private class StudentCourseAssignFlowServTestStubs 
{
    /** 
     * FlowInterviewModel stub
    */
    public class FlowInterviewModel implements System.StubProvider
    {
        List<Opportunity> oppsFound; 

        public FlowInterviewModel(List<Opportunity> oppsFound)
        {
            this.oppsFound = oppsFound;
        }

        public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, System.Type returnType, List<System.Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs)
        {
            Object returnValue;

            switch on stubbedMethodName 
            {
                when 'getVariableValue'
                {
                    String variableName = (String) listOfArgs[0];

                    if (variableName == 'opportunities_found')
                    {
                        returnValue = oppsFound;
                    }
                }
                when 'getInputVariables'
                {
                    returnValue = new Map<String, Object> { 'opportunity_name' => 'Test Opp Name' };
                }
            }

            return returnValue;
        }
    }
}