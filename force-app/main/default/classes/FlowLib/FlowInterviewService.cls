@SuppressWarnings('PMD')

public without sharing class FlowInterviewService 
{
    private FlowInterviewService() {}

    /** 
     * Mapeamento das handlers de cada fluxo
    */
    public Map<FlowInterviewModel, OutputHandler> handlers {get; private set;}

    /** 
     * Mapeamento das variáveis de entrada dinâmicas
    */
    public Map<String, Object> dynamicInputs {get; private set;}

    /** 
     * Mapeamento das variáveis de saída (resultados) de cada fluxo
    */
    public Map<String, Object> outputs {get; private set;}

    /** 
     * Inicializar uma execução de fluxos
    */
    public static FlowInterviewService execution()
    {
        FlowInterviewService service = new FlowInterviewService();
        service.handlers = new Map<FlowInterviewModel, OutputHandler>();
        service.dynamicInputs = new Map<String, Object>();
        service.outputs = new Map<String, Object>();
        
        return service;
    }

    /** 
     * Mapear handler para um fluxo já adicionado ao iterator 
    */
    public FlowInterviewService when(String flowName, Object inputVariables, OutputHandler handler)
    {
        FlowInterviewModel flowInterview = new FlowInterviewModel(flowName, inputVariables);
        handlers.put(flowInterview, handler);
        
        listDynamicVariables(flowInterview.getInputVariables());
        
        return this;
    }

    /** 
     * Obter variaveis dinâmicas caso haja alguma
    */
    private void listDynamicVariables(Map<String, Object> inputVariables)
    {
        for (String variableKey : inputVariables.keySet())
        {
            if (!(inputVariables.get(variableKey) instanceOf String)) continue;

            String variableStringValue = (String) inputVariables.get(variableKey);
            Boolean isDynamic = variableStringValue.startsWith('{!') && variableStringValue.endsWith('}');
            
            if (isDynamic)
            {
                dynamicInputs.put(variableKey, variableStringValue);
            }
        }
    }

    /** 
     * Adiciona instrução final
    */
    public void then(Finalizer serviceFinalizer)
    {
        Exception error;

        try
        {
            execute();
        }
        catch(Exception e)
        {
            error = e;
        }
        finally
        {
            serviceFinalizer?.execute(this, error);
        }
    }

    /** 
     * Executar os fluxos e as handlers
    */
    public void execute()
    {
        for(FlowInterviewModel flowInterview : handlers.keySet())
        {
            flowInterview.setInputVariables(
                updateDynamicVariables(flowInterview.getInputVariables())
            ).start();

            if (handlers.containsKey(flowInterview) && handlers.get(flowInterview) != null)
            {
                outputs.putAll(handlers.get(flowInterview).handle(flowInterview));
            }
        }
    }

    /** 
     * Atualizar variaveis dinâmicas caso haja alguma
    */
    private Map<String, Object> updateDynamicVariables(Map<String, Object> inputVariables)
    {
        for (String variableKey : inputVariables.keySet())
        {
            if (!dynamicInputs.containsKey(variableKey)) continue;
            
            if (outputs.containsKey(variableKey))
            {
                inputVariables.put(variableKey, outputs.get(variableKey));
            }
        }
        return inputVariables;
    }

    /** 
     * Contrato de handler de variáveis de saída
    */
    public interface OutputHandler
    {
        Map<String, Object> handle(FlowInterviewModel flowInterview);
    }

    /** 
     * Contrato de instrução final para a service
    */
    public interface Finalizer
    {
        void execute(FlowInterviewService execution, Exception error);
    }
}