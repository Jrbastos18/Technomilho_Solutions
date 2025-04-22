-- TECHNOMILHO SOLUTIONS
-- DDL - DATA DEFINITION LANGUAGE - LINGUAGEM DE DEFINIÇÃO DE DADOS
-- CRIANDO BANCO DE DADOS 
CREATE DATABASE technomilho;
USE technomilho;

-- CRIANDO TABELAS
CREATE TABLE cargo(
	codigo INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
	CONSTRAINT pk_cargo_codigo PRIMARY KEY (codigo)
);

CREATE TABLE status_tab(
	codigo INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(20) NOT NULL,
    CONSTRAINT pk_status_codigo PRIMARY KEY (codigo)
);

CREATE TABLE setor(
	codigo INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(30) NOT NULL,
    CONSTRAINT pk_setor_codigo PRIMARY KEY (codigo)
);

CREATE TABLE endereco(
	codigo INT NOT NULL AUTO_INCREMENT,
    cep VARCHAR(9) NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    uf CHAR(2) NOT NULL,
    complemento VARCHAR(50),
    CONSTRAINT pk_endereco_codigo PRIMARY KEY (codigo)
);

CREATE TABLE safra(
	codigo INT NOT NULL AUTO_INCREMENT,
    data_plantio DATE NOT NULL,
    data_colheita DATE NOT NULL,
    observacoes TEXT,
    CONSTRAINT pk_safra_codigo PRIMARY KEY (codigo)
);

CREATE TABLE tipo_produto(
	codigo INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(30) NOT NULL,
    CONSTRAINT pk_tipo_produto_codigo PRIMARY KEY (codigo)
);

CREATE TABLE tipo_orcamento(
	codigo INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(8) NOT NULL,
    CONSTRAINT pk_tipo_orcamento_codigo PRIMARY KEY (codigo)
);

CREATE TABLE funcao(
	codigo INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    CONSTRAINT pk_funcao_codigo PRIMARY KEY (codigo)
);

CREATE TABLE funcionario(
	codigo INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    rg VARCHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(14) NOT NULL,
    email VARCHAR(100) NOT NULL,
    data_admissao DATE NOT NULL,
    salario DECIMAL(10, 2) NOT NULL CHECK (salario > 0),
    fk_status INT NOT NULL,
    fk_endereco INT NOT NULL,
    fk_cargo INT NOT NULL,
    fk_setor INT NOT NULL,
    CONSTRAINT pk_funcionario_codigo PRIMARY KEY (codigo),
    CONSTRAINT fk_funcionario_status FOREIGN KEY (fk_status) REFERENCES status_tab(codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_funcionario_endereco FOREIGN KEY (fk_endereco) REFERENCES endereco(codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_funcionario_cargo FOREIGN KEY (fk_cargo) REFERENCES cargo(codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_funcionario_setor FOREIGN KEY (fk_setor) REFERENCES setor(codigo) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE fornecedor(
	codigo INT NOT NULL AUTO_INCREMENT,
    razao_social VARCHAR(255) NOT NULL,
    nome_fantasia VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) NOT NULL UNIQUE,
    telefone VARCHAR(14) NOT NULL,
    email VARCHAR(100) NOT NULL,
    inscricao_estadual INT NOT NULL UNIQUE CHECK(inscricao_estadual > 0),
    fk_status INT NOT NULL,
    fk_endereco INT NOT NULL,
    CONSTRAINT pk_fornecedor_codigo PRIMARY KEY (codigo),
    CONSTRAINT fk_fornecedor_status FOREIGN KEY (fk_status) REFERENCES status_tab(codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_fornecedor_endereco FOREIGN KEY (fk_endereco) REFERENCES endereco(codigo) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE produto(
	codigo INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    quantidade_total INT NOT NULL CHECK (quantidade_total >= 0),
    valor DECIMAL(10,2) NOT NULL CHECK (valor >= 0),
    descricao TEXT,
    fk_tipo_produto INT NOT NULL,
    CONSTRAINT pk_produto_codigo PRIMARY KEY (codigo),
    CONSTRAINT fk_produto_tipo_produto FOREIGN KEY (fk_tipo_produto) REFERENCES tipo_produto(codigo) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE producao(
	codigo INT NOT NULL AUTO_INCREMENT,
    lote VARCHAR(15) NOT NULL,
    data_fabricacao DATE NOT NULL,
    data_vencimento DATE NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    fk_safra INT NOT NULL,
    fk_produto INT NOT NULL,
    CONSTRAINT pk_producao_codigo PRIMARY KEY (codigo),
    CONSTRAINT fk_producao_safra FOREIGN KEY (fk_safra) REFERENCES safra(codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_producao_produto FOREIGN KEY (fk_produto) REFERENCES produto(codigo) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE cliente(
	codigo INT NOT NULL AUTO_INCREMENT,
    razao_social VARCHAR(255) NOT NULL,
    nome_fantasia VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) NOT NULL UNIQUE,
    telefone VARCHAR(14) NOT NULL,
    email VARCHAR(100) NOT NULL,
    inscricao_estadual INT NOT NULL UNIQUE,
    fk_status INT NOT NULL,
    fk_endereco INT NOT NULL,
    CONSTRAINT pk_cliente_codigo PRIMARY KEY (codigo),
    CONSTRAINT fk_cliente_status FOREIGN KEY (fk_status) REFERENCES status_tab(codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_cliente_endereco FOREIGN KEY (fk_endereco) REFERENCES endereco(codigo) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE orcamento_venda(
	codigo INT NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(30) NOT NULL,
    descricao VARCHAR(150),
    data DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL CHECK(valor_total > 0),
    fk_tipo_orcamento INT NOT NULL CHECK(fk_tipo_orcamento = 1),
    fk_funcionario INT NOT NULL,
    fk_cliente INT NOT NULL,
    fk_status INT NOT NULL,
    CONSTRAINT pk_orcamento_venda_codigo PRIMARY KEY (codigo),
    CONSTRAINT fk_orcamento_tipo_orcamento FOREIGN KEY (fk_tipo_orcamento) REFERENCES tipo_orcamento(codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_orcamento_funcionario FOREIGN KEY (fk_funcionario) REFERENCES funcionario(codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_orcamento_cliente FOREIGN KEY (fk_cliente) REFERENCES cliente(codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_orcamento_status FOREIGN KEY (fk_status) REFERENCES status_tab(codigo) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE detalhes_produto(
	codigo INT NOT NULL AUTO_INCREMENT,
	quantidade INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL CHECK(subtotal > 0),
    fk_orcamento_venda INT NOT NULL,
    fk_produto INT NOT NULL,
    CONSTRAINT pk_detalhes_produto_codigo PRIMARY KEY (codigo),
    CONSTRAINT fk_detalhes_produto_orcamento FOREIGN KEY (fk_orcamento_venda) REFERENCES orcamento_venda(codigo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalhes_produto_produto FOREIGN KEY (fk_produto) REFERENCES produto(codigo) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE orcamento_compra(
	codigo INT NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(30) NOT NULL,
	descricao VARCHAR(150),
    data DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL CHECK(valor_total > 0),
    fk_tipo_orcamento INT NOT NULL CHECK(fk_tipo_orcamento = 2),
    fk_funcionario INT NOT NULL,
    fk_fornecedor INT NOT NULL,
    fk_status INT NOT NULL,
    CONSTRAINT pk_orcamento_compra_codigo PRIMARY KEY (codigo),
    CONSTRAINT fk_orcamento_compra_tipo_orcamento FOREIGN KEY (fk_tipo_orcamento) REFERENCES tipo_orcamento(codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_orcamento_compra_funcionario FOREIGN KEY (fk_funcionario) REFERENCES funcionario(codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_orcamento_compra_fornecedor FOREIGN KEY (fk_fornecedor) REFERENCES fornecedor(codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_orcamento_compra_status FOREIGN KEY (fk_status) REFERENCES status_tab(codigo) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE pedido_venda(
	codigo INT NOT NULL AUTO_INCREMENT,
    fk_orcamento_venda INT NOT NULL,
    data_pedido DATE NOT NULL,
    CONSTRAINT pk_pedido_venda_codigo PRIMARY KEY (codigo),
    CONSTRAINT fk_pedido_venda_orcamento FOREIGN KEY (fk_orcamento_venda) REFERENCES orcamento_venda(codigo) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE pedido_compra(
	codigo INT NOT NULL AUTO_INCREMENT,
    fk_orcamento_compra INT NOT NULL,
    data_pedido DATE NOT NULL,
    CONSTRAINT pk_pedido_compra_codigo PRIMARY KEY (codigo),
    CONSTRAINT fk_pedido_compra_orcamento FOREIGN KEY (fk_orcamento_compra) REFERENCES orcamento_compra(codigo) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE maquinario(
	codigo INT NOT NULL AUTO_INCREMENT,
    modelo VARCHAR(30) NOT NULL,
    marca VARCHAR(30) NOT NULL,
    numero_serie INT NOT NULL UNIQUE,
    numero_patrimonio INT NOT NULL UNIQUE,
    fk_funcao INT NOT NULL,
    fk_setor INT NOT NULL,
    CONSTRAINT pk_maquinario_codigo PRIMARY KEY (codigo),
    CONSTRAINT fk_maquinario_funcao FOREIGN KEY (fk_funcao) REFERENCES funcao(codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_maquinario_setor FOREIGN KEY (fk_setor) REFERENCES setor(codigo) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE login_funcionario(
	codigo INT NOT NULL,
    senha VARCHAR(32) NOT NULL,
    fk_codigo_funcionario INT NOT NULL,
    CONSTRAINT pk_login_funcionario PRIMARY KEY (codigo),
    CONSTRAINT fk_login_funcionario_codigo FOREIGN KEY (fk_codigo_funcionario) REFERENCES funcionario(codigo) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE login_cliente(
	cnpj VARCHAR(14) NOT NULL,
    senha VARCHAR(32) NOT NULL,
    fk_codigo_cliente INT NOT NULL,
    CONSTRAINT pk_login_cliente PRIMARY KEY (cnpj),
    CONSTRAINT fk_login_cliente_codigo FOREIGN KEY (fk_codigo_cliente) REFERENCES cliente(codigo) ON DELETE CASCADE ON UPDATE CASCADE
);