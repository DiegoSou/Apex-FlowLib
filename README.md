# Instalar
<a href="https://githubsfdeploy.herokuapp.com?owner=DiegoSou&repo=Apex-FlowLib&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

---

# Documentação

Apex-FlowLib é um conjunto de classes que auxiliam a chamada de Fluxos (Salesforce Flows) por meio de código Apex.

A classe principal se chama `FlowInterviewService`. Ela iniciará as <b>execuções</b> compostas por uma ou mais entrevistas de fluxo.

> Nota: A versão da entrevista de fluxo executada é por padrão a mais recente (mesmo inativa), por isso é recomendado apagar versões recentes que não são utilizadas ou duplicar a versão que será utilizada na execução, tornando-a a mais recente.

<details>
  <summary>FlowInterviewService</summary>
  
  ## FlowInterviewService

  > Classe que irá compor as execuções de uma ou mais entrevistas de fluxo, mapeando variáveis de input/output/dinâmicas

  <details>
    <summary>Métodos</summary>
    <h2>Métodos</h2>
    <ul>
      <li><b>execution()</b></li>
      <p>Inicializar uma execução de fluxos</p>
<pre><code>FlowInterviewService registerAccountUseCase = FlowInterviewService.execution();
</code></pre>
      <p></p>
      <li><b>ignoreDone(Boolean v)</b></li>
      <p>Configuração para ignorar fluxos que já foram executados</p>
<pre><code>registerAccountUseCase.ignoreDone(true);
</code></pre>
      <p></p>
      <li><b>when(String flowName)</b></li>
      <p>Mapear handler para um fluxo. *Parâmetros opcionais: inputVariables, handler</p>
<pre><code>registerAccountUseCase.when('Create_New_Account_Flow', new Map&lt;String, Object&gt; {
  'accountName' => 'Test Account'
}, new MyCustomHandler());
</code></pre>
      <p></p>
      <li><b>then()</b></li>
      <p>Adiciona instrução final. *Parâmetros opcionais: serviceFinalizer</p>
<pre><code>registerAccountUseCase.then(new MyCustomFinalizer());
</code></pre>
    </ul>
  </details>

  <br>

  <details>
    <summary>Interface: OutputHandler</summary>
    <h2>FlowInterviewService.OutputHandler</h2>
    <blockquote cite="http://developer.mozilla.org">
      <p>Contrato de handler de variáveis de saída</p>
    </blockquote>
    <ul>
      <li><b>handle(FlowInterviewModel currentFlowInterview, Map&lt;String, Object&gt; dynamicVariables)</b></li>
    </ul>
  </details>

  <br>

  <details>
    <summary>Interface: Finalizer</summary>
    <h2>FlowInterviewService.Finalizer</h2>
    <blockquote cite="http://developer.mozilla.org">
      <p>Contrato de instrução final para a service</p>
    </blockquote>
    <ul>
      <li><b>execute(FlowInterviewService execution, Exception error)</b></li> 
    </ul>
  </details>

  <br>

  <details>
    <summary>Classe: DefaultOutputHandler</summary>
    <h2>FlowInterviewService.DefaultOutputHandler</h2>
    <blockquote cite="http://developer.mozilla.org">
      <p>Implementação padrão do contrato de Handler</p>
    </blockquote>
    <details>
      <summary>Métodos</summary>
      <h2>Métodos</h2>
      <ul>
        <li><b>handle(FlowInterviewModel currentFlowInterview, Map&lt;String, Object&gt; dynamicVariables)</b></li>
        <p>Manipular output baseado nos inputs dinâmicos da execução.</p>
<pre><code>/** Utilizado por padrão */
</code></pre>
      </ul>
    </details>
  </details>
</details>

---

## Exemplos

```java
FlowInterviewService.execution().ignoreDone(true)
.when('Criar_conta_aluno', new Map<String, Object> {
  'student_name' => 'Student Name',
  'student_cpf' => 'Student CPF'
})
/** 
 * Output variables:
 *  student_id
*/
.when('Buscar_curso_disponivel', new Map<String, Object> {
  'course_option_1' => 'Option 1',
  'course_option_2' => 'Option 2'
})
/** 
 * Output variables:
 *  available_course_id
*/
.when('Associar_aluno_ao_curso', new Map<String, Object>{
  'accountRecordId' => '{! student_id }',
  'opportunityRecordId' => '{! available_course_id }'
})
/** 
 * Input variables:
 *  accountRecordId = student_id (student_id is added as dynamic variable to be filled by the context)
 *  opportunityRecordId = available_course_id (available_course_id is added as dynamic variable to be filled by the context)
 * 
 * Output variables:
 *  operation_result
*/
.then();
/**
 * Optionally choose a class that implements the FlowInterviewService.Finalizer to handle execution result/error:
 *   .then(new MyCustomFinalizer());
*/
```