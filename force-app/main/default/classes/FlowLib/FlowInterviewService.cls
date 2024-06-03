/** 
 * @author Diego
 * Essa classe faz parte da FlowLib
 * Mais informações: https://github.com/DiegoSou/Apex-FlowLib
*/

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
     * Obter as entrevistas mapeadas
    */
    public List<FlowInterviewModel> getInterviews()
    {
        return new List<FlowInterviewModel>(this.handlers.keySet());
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
        this.registerDynamic(FlowInterviewService_Helper.instance.listDynamicVariables(flowInterview.getInputVariables()));

        return this;
    }

    /** 
     * Registrar uma variável para ser preenchida dinâmicamente
    */
    public FlowInterviewService registerDynamic(String variableName)
    {
        this.dynamicInputs.put(variableName, null);

        return this;
    }

    public FlowInterviewService registerDynamic(Map<String, Object> dynamicInputs)
    {
        this.dynamicInputs.putAll(dynamicInputs);

        return this;
    }

    /** 
     * Adiciona instrução final
    */
    public void then()
    {
        this.then(new DefaultFinalizer());
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
            Boolean ableToFinalize = !Test.isRunningTest() && serviceFinalizer != null;
            
            if (ableToFinalize) { serviceFinalizer.execute(this, error); }
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

        Map<String, Object> handlerOutput;
        
        if (!Test.isRunningTest()) { handlerOutput = handler.handle(flowInterview, dynamicVariables); }
        if (handlerOutput != null) { outputs.putAll(handlerOutput); }
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
         * Se quiser usar dentro de um override: ```super.handle(currentFlowInterview, dynamicVariables);```
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

    /** 
     * Implementação padrão do contrato de Finalizer
    */
    public virtual class DefaultFinalizer implements Finalizer
    {
        /** 
         * Fazer debug de como ocorreu a execução e executar os métodos de controle  
        */
        public void execute(FlowInterviewService execution, Exception error)
        {
            if (error != null)
            {
                this.error(execution, error);          
                return;
            }

            this.success(execution);
        }

        /** 
         * Chamado quando todas as entrevistas foram executadas com sucesso
         * Se quiser usar dentro de um override: ```super.success(execution);```
        */
        public virtual void success(FlowInterviewService execution)
        {
            System.debug('Finalizer: Flow interviews executed successfully.');
            System.debug('Outputs: ' + execution.outputs);
        }

        /** 
         * Chamado caso tenha acontecido erros durante alguma execução de entrevista ou handler 
         * Se quiser usar dentro de um override: ```super.error(execution, error);```
        */
        public virtual void error(FlowInterviewService execution, Exception error)
        {
            System.debug('Finalizer: An error occured during the execution');
            System.debug('Message: ' + error.getMessage());
            System.debug('Stack trace: \n' + error.getStackTraceString());
        }
    }
}