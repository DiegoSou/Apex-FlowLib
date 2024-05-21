@SuppressWarnings('PMD')

public without sharing virtual class FlowInterviewModel 
{
    public class FlowInterviewModelException extends Exception{}

    //
    // Attributes
    //

    @TestVisible
    private Flow.Interview record;

    @TestVisible
    private String flowName;

    @TestVisible
    private Map<String, Object> inputVariables;

    @TestVisible
    private Boolean done = false;

    //
    // Constructors
    //

    public FlowInterviewModel() {}

    public FlowInterviewModel(String flowName, Object inputVariables)
    {
        this
        .setFlowName(flowName)
        .setInputVariables(inputVariables)
        .setRecord(getFlowName(), getInputVariables());
    }

    //
    // Gets
    //

    @TestVisible
    private Flow.Interview getRecord()
    {
        return this.record;
    }

    public String getFlowName()
    {
        return this.flowName;
    }

    public Map<String, Object> getInputVariables()
    {
        return this.inputVariables;
    }

    public Boolean hasDone()
    {
        return this.done;
    }

    //
    // Sets
    //

    @TestVisible
    private FlowInterviewModel setRecord(String flowName, Map<String, Object> inputVariables)
    {
        if (!Test.isRunningTest()) { this.record = Flow.Interview.createInterview(flowName, inputVariables); }
        return this;
    }

    public FlowInterviewModel setFlowName(String flowName)
    {
        if (flowName == null) { throw new FlowInterviewModelException('O parâmetro "flowName" não pode ser nulo.'); }

        this.flowName = flowName;
        return this;
    }

    public FlowInterviewModel setInputVariables(Object inputVariables)
    {
        if (inputVariables instanceOf Map<String, Object>)
        {
            this.inputVariables = (Map<String, Object>) inputVariables;
        }
        else if (inputVariables != null)
        {
            this.inputVariables = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(inputVariables));
        }
        else
        {
            this.inputVariables = new Map<String, Object>();
        }

        return this;
    }

    //
    // Equals
    //

    public Boolean equals(Object obj)
    {
        if (obj instanceOf FlowInterviewModel)
        {
            FlowInterviewModel modelObj = (FlowInterviewModel) obj;
            
            if (
                modelObj.getFlowName() == this.getFlowName() && 
                modelObj.getInputVariables().equals(this.getInputVariables())
            )
            {
                return true;
            }
        }

        return false;
    }

    //
    // Methods
    //

    public FlowInterviewModel start()
    {
        if (this.getFlowName() == null) { throw new FlowInterviewModelException('O atributo "flowName" não foi definido.'); }
        if (this.record == null) 
        {
            this.setRecord(this.getFlowName(), this.getInputVariables());
        }

        if (!Test.isRunningTest()) { this.getRecord().start(); }

        this.done = true;
        return this;
    }

    public Object getVariableValue(String variableName)
    {
        return this.getRecord()?.getVariableValue(variableName);
    }
}