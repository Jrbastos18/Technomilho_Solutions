<h1>TECHNOMILHO SOLUTIONS - PROJETO DA DISCIPLINA DE BANCO DE DADOS [EM PROGRESSO]</h1>

<h2>Sobre o projeto</h2>
<p>O projeto foi elaborado na disciplina de Banco de Dados do curso de Análise e Desenvolvimento de Sistemas pela UMC.</p>
<p>O projeto trata-se de um sistema web ERP para um agronegócio, uma indústria de milho e seus derivados. Ele foi pensado tanto para o lado do funcionário e gestão da empresa, quanto do lado do cliente.</p>
<p>O projeto de ínicio se trata de um sistema para banco de dados, porém estarei criando um sistema completo web, de front, back e banco de dados. Nele temos os requisitos funcionais, não funcionais, regras de negócio, diagramas dos modelos de entidade-relacionamento tanto conceitual quanto lógico, dicionário de dados, e código SQL (MySQL).</p>

<h2>Índice</h2>
<ol>
  <li><a href="#Conceitual">Diagrama Entidade-Relacionamento (Conceitual)</a></li>
  <li><a href="#Logico">Diagrama Entidade-Relacionamento (Lógico)</a></li>
  <li><a href="#Dicionario">Dicionário de Dados</a></li>
  <li><a href="#Fisico">Modelo Físico - Código SQL (MySQL)</a></li>
    <ul>
      <li><a href="#DDL">DDL - Data Manipulation Language</a></li>
    </ul>
  <li><a href="#Design">Design das Páginas:</a></li>
    <ul>
      <li><a href="#Index">Página Index</a></li>
      <li><a href="#SobreNos">Página Sobre Nós</a></li>
      <li><a href="#LoginFunc">Página de Login do Funcionario</a></li>
      <li><a href="#LoginCliente">Página de Login do Cliente</a></li>
      <li><a href="#FormularioCliente">Página de Formulário de Cadastro do Cliente</a></li>
    </ul>
</ol>

<h2>Diagrama Entidade-Relacionamento (Conceitual)</h2>
<a name="Conceitual"></a>
<img src="https://github.com/Jrbastos18/Technomilho_Solutions/blob/main/img/ModeloConceitual07.png" alt="DER - Diagrama de Entidade-Relacionamento Conceitual">

<h2>Diagrama Entidade-Relacionamento (Lógico)</h2>
<a name="Logico"></a>
<img src="https://github.com/Jrbastos18/Technomilho_Solutions/blob/main/img/ModeloLogico03.png" alt="DER - Diagrama de Entidade-Relacionamento Lógico">

<h2>Dicionário de Dados</h2>
<a name="Dicionario"></a>
<p>*Como o dicionário de dados é extenso, irei colocar o link que direciona para o arquivo .PDF dele.</p>
<a href="https://github.com/Jrbastos18/Technomilho_Solutions/blob/main/doc/DicionarioTechnomilho.pdf">Dicionário de Dados</a>

<h2>Modelo Físico - Código SQL (MySQL)</h2>
<a name="Fisico"></a>
<p>*Como o código está muito extenso, irei separar pelas divisões SQL, com alguns exemplos (prints) e um link direcionando para o código em cada divisão.</p>
<ul>
  <a name="DDL"></a>
  <li><h3><a href="https://github.com/Jrbastos18/Technomilho_Solutions/blob/main/src/sql/DDL_Technomilho.sql" target="_blank" >DDL - Data Definition Language</a></h3></li>
  <img src="https://github.com/Jrbastos18/Technomilho_Solutions/blob/main/img/ddl_technomilho.png" alt="Print do Código DDL - Data Definition Language">
  <br><br>
  <li><h3>DML - Data Manipulation Language</h3></li>
  <li><h3>DQL - Data Query Language</h3></li>
  <li><h3>DTL - Data Transaction Language</h3></li>
</ul>



<h2>Design das Páginas</h2>
<a name="Design"></a>
<ul>
    <li><h3>Página Index</h3></li><br>
    <a name="Index"></a>
    <img src="https://github.com/Jrbastos18/Technomilho_Solutions/blob/main/img/Index.png" alt="Modelo da página web Index">
    <br><br>
    <li><h3>Página Sobre Nós</h3></li><br>
    <a name="SobreNos"></a>
    <img src="https://github.com/Jrbastos18/Technomilho_Solutions/blob/main/img/Sobre%20n%C3%B3s.png" alt="Modelo da página Sobre Nós">
    <br><br>
    <li><h3>Página de Login do Funcionario</h3></li><br>
    <a name="LoginFunc"></a>
    <img src="https://github.com/Jrbastos18/Technomilho_Solutions/blob/main/img/Login-Funcionario.png" alt="Modelo da página de login do funcionário">
    <br><br>
    <li><h3>Página de Login do Cliente</h3></li><br>
    <a name="LoginCliente"></a>
    <img src="https://github.com/Jrbastos18/Technomilho_Solutions/blob/main/img/Login-Cliente.png" alt="Modelo da página de login do cliente">
    <br><br>
    <li><h3>Página de Formulário de Cadastro do Cliente</h3></li>
    <a name="FormularioCliente"></a>
    <img src="https://github.com/Jrbastos18/Technomilho_Solutions/blob/main/img/Formul%C3%A1rio%20de%20Cadastro%20do%20Cliente.png" alt="Modelo da página de formulário de cadastro do cliente">
    
</ul>
