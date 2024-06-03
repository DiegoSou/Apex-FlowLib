/** 
 * @author Diego
 * Essa classe faz parte da FlowLib
 * Mais informações: https://github.com/DiegoSou/Apex-FlowLib
*/

public interface FlowInterviewService_IHelper 
{
    Map<String, Object> listDynamicVariables(Map<String, Object> inputVariables);
    Map<String, Object> replaceDynamicVariables(Map<String, Object> inputVariables, Map<String, Object> outputs);
}