/** 
 * Custom Iterator para iterar sobre uma lista de FlowInterviewModel
*/
public class FlowInterviewModel_Iterator implements Iterator<FlowInterviewModel>
{
    /** 
     * Lista de fluxos
    */
    private List<FlowInterviewModel> flowInterviews;

    /** 
     * Index atual a ser percorrido
    */
    private Integer currentIndex;

    /**
     * Construir iterator a partir de uma coleção List
    */
    public FlowInterviewModel_Iterator(List<FlowInterviewModel> flowInterviews)
    {
        this.flowInterviews = flowInterviews;
        this.currentIndex = 0;
    }
    
    /**
     * Construir iterator a partir de uma coleção Set
    */
    public FlowInterviewModel_Iterator(Set<FlowInterviewModel> flowInterviews)
    {
        this.flowInterviews = new List<FlowInterviewModel>(flowInterviews);
        this.currentIndex = 0;
    }
  
    /** 
     * Verificar se existe um próximo elemento na lista
    */
    public Boolean hasNext()
    { 
        return currentIndex < flowInterviews.size();
    }    
  
    /** 
     * Obter o elemento a ser percorrido e incrementar o index atual
    */
    public FlowInterviewModel next()
    {
        if(hasNext())
        {
            return flowInterviews[currentIndex++];
        } 
        else 
        {
            throw new NoSuchElementException('Iterator has no more elements.');
        }
    }

    /** 
     * Obter o elemento a ser percorrido sem incrementar o index atual
    */
    public FlowInterviewModel nextWithoutChange()
    {
        if(hasNext())
        {
            return flowInterviews[currentIndex];   
        }

        return null;
    }
}