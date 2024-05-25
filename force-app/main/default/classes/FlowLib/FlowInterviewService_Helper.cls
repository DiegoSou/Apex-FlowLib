@SuppressWarnings('PMD')

public virtual class FlowInterviewService_Helper implements FlowInterviewService_IHelper
{
    /** 
     * Obter variaveis dinâmicas caso haja alguma
    */
    public Map<String, Object> listDynamicVariables(Map<String, Object> inputVariables)
    {
        Map<String, Object> dynamicVariables = new Map<String, Object>();

        for (String variableName : inputVariables.keySet())
        {
            String dynamicVariableName = this.dynamicVariableCheck(inputVariables.get(variableName));
            
            if (dynamicVariableName == null) { continue; }

            dynamicVariables.put(dynamicVariableName, null);
        }

        return dynamicVariables;
    }

    /** 
     * Atualizar variaveis dinâmicas caso haja alguma mapeada
    */
    public Map<String, Object> replaceDynamicVariables(Map<String, Object> inputVariables, Map<String, Object> outputs)
    {
        Map<String, Object> dynamicVariables = new Map<String, Object>();

        for (String variableName : inputVariables.keySet())
        {   
            String dynamicVariableName = this.dynamicVariableCheck(inputVariables.get(variableName));

            if (dynamicVariableName == null) { continue; }

            if (outputs.containsKey(dynamicVariableName))
            {
                dynamicVariables.put(variableName, outputs.get(dynamicVariableName));
            }
        }

        return dynamicVariables;
    }

    /** 
     * Obtém o nome da variável dinâmica
    */
    private String dynamicVariableCheck(Object variableValue)
    {
        if (!(variableValue instanceOf String)) { return null; }

        String stringValue = (String) variableValue;

        // Mude a partir dessa linha caso queira mudar a condição para reconhecer variáveis dinâmicas
        Boolean isDynamic = stringValue.startsWith('{!') && stringValue.endsWith('}');

        if (!isDynamic) { return null; }

        Integer indexEntry = stringValue.indexOf('{!') + 2;
        Integer indexOut = stringValue.indexOf('}');
        
        String dynamicVariableName = stringValue.substring(indexEntry, indexOut).trim();

        return dynamicVariableName;
    }

    /** 
     * Instância padrão da helper
    */
    @TestVisible
    public static FlowInterviewService_IHelper instance
    {
        get
        {
            if (instance == null) instance = new FlowInterviewService_Helper();
            return instance;
        }
        protected set;
    }
}