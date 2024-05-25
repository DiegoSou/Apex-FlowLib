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
     * Configuração para ignorar fluxos que já foram executados
    */
    private Boolean ignoreDone;

    public FlowInterviewService ignoreDone(Boolean v) { this.ignoreDone = v; return this; }

    /** 
     * Inicializar uma execução de fluxos
    */
    public static FlowInterviewService execution()
    {
        FlowInterviewService service = new FlowInterviewService();
        service.handlers = new Map<FlowInterviewModel, OutputHandler>();
        service.dynamicInputs = new Map<String, Object>();
        service.outputs = new Map<String, Object>();
        service.ignoreDone = false;
        
        return service;
    }

    /** 
     * Mapear handler para um fluxo
    */
    public FlowInterviewService when(String flowName)
    {
        return this.when(flowName, null, new DefaultOutputHandler());
    }

    public FlowInterviewService when(String flowName, Object inputVariables)
    {
        return this.when(flowName, inputVariables, new DefaultOutputHandler());
    }

    public FlowInterviewService when(String flowName, Object inputVariables, OutputHandler handler)
    {
        FlowInterviewModel flowInterview = new FlowInterviewModel(flowName, inputVariables);
        
        this.handlers.put(flowInterview, handler);
        this.dynamicInputs.putAll(
            FlowInterviewService_Helper.instance.listDynamicVariables(flowInterview.getInputVariables())
        );

        return this;
    }

    /** 
     * Adiciona instrução final
    */
    public void then()
    {
        this.then(null);
    }

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
    private void execute()
    {
        FlowInterviewModel_Iterator executionFlows = new FlowInterviewModel_Iterator(handlers.keySet());

        while (executionFlows.hasNext())
        {
            FlowInterviewModel currentFlowInterview = executionFlows.next();          
            
            if (currentFlowInterview.hasDone() && this.ignoreDone) 
            {
                continue;
            }
            
            OutputHandler currentHandler = handlers.get(currentFlowInterview);
            
            executeFlowInterview(currentFlowInterview);
            executeOutputHandler(currentFlowInterview, currentHandler, this.dynamicInputs);
        }
    }

    /** 
     * Executar um fluxo
    */
    private void executeFlowInterview(FlowInterviewModel flowInterview)
    {
        flowInterview.getInputVariables().putAll(
            FlowInterviewService_Helper.instance.replaceDynamicVariables(flowInterview.getInputVariables(), this.outputs)
        );

        flowInterview.start();
    }

    /** 
     * Executar uma handler
    */
    private void executeOutputHandler(FlowInterviewModel flowInterview, OutputHandler handler, Map<String, Object> dynamicVariables)
    {
        if (handler == null) { return; }

        Map<String, Object> handlerOutput = handler.handle(flowInterview, dynamicVariables);
        
        if (handlerOutput != null)
        {
            outputs.putAll(handlerOutput);
        }
    }

    /** 
     * Contrato de handler de variáveis de saída
    */
    public interface OutputHandler
    {
        Map<String, Object> handle(FlowInterviewModel currentFlowInterview, Map<String, Object> dynamicVariables);
    }

    /** 
     * Contrato de instrução final para a service
    */
    public interface Finalizer
    {
        void execute(FlowInterviewService execution, Exception error);
    }

    /** 
     * Implementação padrão do contrato de Handler
    */
    public virtual class DefaultOutputHandler implements OutputHandler
    {
        /** 
         * Manipular output baseado nos inputs dinâmicos da execução
         * Se quiser usar dentro de um override: 
         * 
         * super.handle(currentFlowInterview, dynamicVariables);
        */
        public virtual Map<String, Object> handle(FlowInterviewModel currentFlowInterview, Map<String, Object> dynamicVariables)
        {
            Map<String, Object> output = new Map<String, Object>();

            for (String variableName : dynamicVariables.keySet())
            {
                if (currentFlowInterview.getVariableValue(variableName) != null) 
                {
                    output.put(variableName, currentFlowInterview.getVariableValue(variableName));
                }
            }

            return output;
        }
    } 
}