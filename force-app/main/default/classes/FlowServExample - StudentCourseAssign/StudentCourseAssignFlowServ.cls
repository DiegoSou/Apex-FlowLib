/** 
 * @author Diego
 * Essa classe faz parte de um caso de uso exemplo para utilizar a FlowLib
 * Mais informações: https://github.com/DiegoSou/Apex-FlowLib
*/
 
/** 
 * Caso de Uso:
 * &#10;
 * Chamar um fluxo de criação de conta passando o parâmetro de nome da conta, em seguida, 
 * chamar um fluxo de busca de oportunidades baseado no nome da oportunidade, por fim, 
 * chamar um fluxo que associa os dois. 
 * &#10;
 * ```new StudentCourseAssignFlowServ().assignStudentToCourse('Nome Conta', 'Análise');```
*/
public without sharing class StudentCourseAssignFlowServ 
{
    public void assignStudentToCourse(String studentName, String courseName)
    {
        FlowInterviewService.execution()
        .when('Create_new_account_flow', new Map<String, Object>{
            'account_name' => studentName,
            'account_source' => 'Flow Service'
        })
        .registerDynamic('account_id')
        .then(new StudentCourseAssignFlowServ.CreateNewAccFlowFinalizer(courseName));
    }

    /** 
     * Chamada condicional: se o resultado da execução for sucesso e conter o valor de
     * account_id, chamar a próxima entrevista.
    */
    public without sharing class CreateNewAccFlowFinalizer extends FlowInterviewService.DefaultFinalizer
    {
        private String courseName;

        public CreateNewAccFlowFinalizer(String courseName)
        {
            this.courseName = courseName;
        }

        public override void success(FlowInterviewService execution)
        {
            super.success(execution);

            if (execution.outputs.get('account_id') != null)
            {
                execution.ignoreDone(true)
                .when(
                    'Find_opportunities_by_name', 
                    new Map<String, Object>{ 
                        'opportunity_name' => courseName 
                    },
                    new StudentCourseAssignFlowServ.FindOppsByNameHandler()
                )
                .then(new StudentCourseAssignFlowServ.FindOppsByNameFinalizer());
            }
        }
    }

    /** 
     * Obter a primeira oportunidade sem conta associada
     * Caso não sejam encontradas as oportunidades, criar um caso
    */
    public without sharing class FindOppsByNameHandler extends FlowInterviewService.DefaultOutputHandler
    {
        public override Map<String, Object> handle(FlowInterviewModel currentFlowInterview, Map<String, Object> dynamicVariables)
        {
            Map<String, Object> handlerOutputs = new Map<String, Object>();

            Opportunity opp = getFirstOppWithoutAccount((List<Opportunity>) currentFlowInterview.getVariableValue('opportunities_found'));
            
            if (opp != null)
            {
                handlerOutputs.put('opportunity_id', opp.Id);
            }

            if (!handlerOutputs.containsKey('opportunity_id'))
            {
                String searchedOppName = (String) currentFlowInterview.getInputVariables().get('opportunity_name');
                handlerOutputs.put('case_id', createCaseToWaitOpp(searchedOppName).Id);
            }

            return handlerOutputs;
        }

        public Opportunity getFirstOppWithoutAccount(List<Opportunity> oppsFound)
        {
            for (Opportunity opp : oppsFound)
            {
                if (opp.AccountId != null) { continue; }

                return opp;
            }

            return null;
        }

        public Case createCaseToWaitOpp(String searchedOppName)
        {
            Case newCase = new Case(Subject='Student is waiting for a opportunity: ' + searchedOppName);
            // insert newCase;
            
            return newCase;
        }
    }

    /** 
     * Iterar na execução as entrevistas para associar a conta a uma oportunidade ou caso, 
     * dependendo do id que houver no contexto da execução
    */
    public without sharing class FindOppsByNameFinalizer extends FlowInterviewService.DefaultFinalizer
    {
        public override void success(FlowInterviewService execution)
        {
            super.success(execution);

            if (execution.outputs.containsKey('opportunity_id'))
            {
                assignToCourse(execution);
            }

            else if (execution.outputs.containsKey('case_id'))
            {
                assignToCase(execution);
            }
        }

        public void assignToCourse(FlowInterviewService execution)
        {
            execution.ignoreDone(true)
            .when('Assign_student_to_course', new Map<String, Object>{
                'student_id' => execution.outputs.get('account_id'),
                'course_id' => execution.outputs.get('opportunity_id')
            }).then();
        }

        public void assignToCase(FlowInterviewService execution)
        {
            execution.ignoreDone(true)
            .when('Assign_student_to_case', new Map<String, Object>{
                'student_id' => execution.outputs.get('account_id'),
                'case_id' => execution.outputs.get('case_id')
            }).then();
        }
    }
}
