public interface FlowInterviewService_IHelper 
{
    Map<String, Object> listDynamicVariables(Map<String, Object> inputVariables);
    Map<String, Object> replaceDynamicVariables(Map<String, Object> inputVariables, Map<String, Object> outputs);
}