-- TECHNOMILHO SOLUTIONS
-- 3. CRIANDO BANCO DE DADOS 
CREATE DATABASE technomilho;
USE technomilho;

-- 3. CRIANDO TABELAS
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

-- 4. INSERINDO DADOS NAS TABELAS
INSERT INTO cargo (nome)
VALUES ('Administrador'), ('Recrutador'), ('Gerente'), ('Vendedor'), ('Auxiliar de compras'), ('Desenvolvedor Full-stack'), ('Líder de Produção'), ('Operador de Máquinas'), ('Motorista'), ('Líder de Logística'), ('Diretor de Vendas'), ('Diretor de Marketing'), ('Diretor Comercial'), ('Adm de Banco de Dados'), ('Auxiliar de Produção'), ('Ajudante Operacional'), ('Técnico de Segurança');

INSERT INTO status_tab (nome)
VALUES ('ativo'), ('inativo'), ('aprovado'), ('reprovado'), ('cancelado'), ('aguardando');

INSERT INTO setor (nome)
VALUES ('Administração'), ('Diretoria'), ('Vendas'), ('Compras'), ('Recursos Humanos'), ('Financeiro'), ('Produção'), ('Logística'), ('Tecnologia da Informação'), ('Agrícola'), ('Marketing'), ('Operacional'), ('Segurança'), ('Almoxarifado'), ('Limpeza');

INSERT INTO endereco (cep, logradouro, numero, bairro, cidade, uf, complemento)
VALUES ('01001-000', 'Praça da Sé', '100', 'Sé', 'São Paulo', 'SP', 'Próximo à Catedral da Sé'),
('02011-001', 'Rua Voluntários da Pátria', '500', 'Santana', 'São Paulo', 'SP', 'Edifício Empresarial'),
('41750-310', 'Avenida Tancredo Neves', '1234', 'Caminho das Árvores', 'Salvador', 'BA', 'Ed. Empresarial Salvador'),
('40420-630', 'Rua Direita de Santo Antônio', '88', 'Santo Antônio Além do Carmo', 'Salvador', 'BA', 'Ao lado do Mercado Cultural'),
('82530-040', 'Rua Augusto Stresser', '222', 'Juvevê', 'Curitiba', 'PR', 'Apartamento 303'),
('80060-060', 'Avenida Cândido de Abreu', '700', 'Centro Cívico', 'Curitiba', 'PR', NULL),
('30130-010', 'Avenida Afonso Pena', '1122', 'Centro', 'Belo Horizonte', 'MG', 'Próximo à Praça Sete'),
('30260-000', 'Rua Grão Mogol', '250', 'Sion', 'Belo Horizonte', 'MG', NULL),
('20010-000', 'Rua Primeiro de Março', '500', 'Centro', 'Rio de Janeiro', 'RJ', 'Próximo ao Paço Imperial'),
('22041-001', 'Rua Barata Ribeiro', '300', 'Copacabana', 'Rio de Janeiro', 'RJ', NULL),
('02140-020', 'Avenida Guilherme Cotching', '1200', 'Vila Maria', 'São Paulo', 'SP', 'Próximo ao Shopping Vila Maria'),
('41940-450', 'Rua Oswaldo Cruz', '150', 'Rio Vermelho', 'Salvador', 'BA', 'Condomínio Vista Mar'),
('08675-400', 'Avenida Armando de Salles Oliveira', '350', 'Centro', 'Suzano', 'SP', 'Próximo à Estação Suzano'),
('08710-150', 'Rua Doutor Deodato Wertheimer', '450', 'Centro', 'Mogi das Cruzes', 'SP', 'Edifício Empresarial Monte Líbano'),
('08572-000', 'Estrada de Santa Isabel', '1200', 'Vila Virgínia', 'Itaquaquecetuba', 'SP', 'Em frente ao Shopping Itaquá Garden'),
('08550-060', 'Avenida Getúlio Vargas', '200', 'Centro', 'Poá', 'SP', 'Próximo ao Fórum de Poá'),
('09020-230', 'Rua das Figueiras', '150', 'Jardim', 'Santo André', 'SP', 'Próximo ao Shopping ABC'),
('09520-010', 'Rua Almirante Tamandaré', '200', 'Santa Paula', 'São Caetano do Sul', 'SP', 'Edifício Empresarial Paula'),
('09720-130', 'Avenida Kennedy', '300', 'Jardim do Mar', 'São Bernardo do Campo', 'SP', 'Ao lado do Paço Municipal'),
('08570-000', 'Avenida Brasil', '400', 'Centro', 'Ferraz de Vasconcelos', 'SP', 'Próximo à Estação Ferraz'),
('08674-010', 'Rua Baruel', '50', 'Centro', 'Suzano', 'SP', 'Próximo à Igreja Matriz'),
('08730-000', 'Avenida Vereador Narciso Yague Guimarães', '600', 'Centro', 'Mogi das Cruzes', 'SP', 'Próximo ao Hospital Luzia de Pinho Melo'),
('07600-000', 'Rua Antonio de Oliveira', '100', 'Centro', 'Franco da Rocha', 'SP', 'Próximo à Prefeitura'),
('07700-000', 'Avenida São João', '150', 'Centro', 'Cajamar', 'SP', NULL),
('13290-000', 'Rua João Pessoa', '350', 'Centro', 'Valinhos', 'SP', 'Ao lado do Teatro Municipal'),
('13300-000', 'Avenida Dom Pedro II', '250', 'Centro', 'Itu', 'SP', NULL),
('13400-000', 'Rua Bernardino de Campos', '800', 'Centro', 'Piracicaba', 'SP', 'Próximo ao Rio Piracicaba'),
('13560-000', 'Avenida São Carlos', '500', 'Centro', 'São Carlos', 'SP', NULL),
('12900-000', 'Rua José Benedito da Silva', '400', 'Centro', 'Bragança Paulista', 'SP', 'Próximo à Feira Livre'),
('12300-000', 'Rua Marechal Deodoro', '300', 'Centro', 'Jacareí', 'SP', 'Próximo ao Mercado Municipal'),
('12200-000', 'Avenida São José', '700', 'Centro', 'São José dos Campos', 'SP', 'Próximo ao Parque Vicentina Aranha'),
('12400-000', 'Avenida Doutor Nelson Freire', '900', 'Centro', 'Pindamonhangaba', 'SP', NULL),
('12500-000', 'Rua Barão do Rio Branco', '200', 'Centro', 'Taubaté', 'SP', 'Próximo ao Museu Mazzaropi'),
('14000-000', 'Avenida 9 de Julho', '600', 'Centro', 'Jundiaí', 'SP', 'Próximo ao Jundiaí Shopping'),
('15000-000', 'Rua Brigadeiro Tobias', '750', 'Centro', 'Sorocaba', 'SP', 'Ao lado da Praça Central'),
('16000-000', 'Avenida Waldemar Alves', '400', 'Jardim Paulista', 'Araras', 'SP', NULL),
('13201-123', 'Rua das Flores', '123', 'Centro', 'Jundiaí', 'SP', 'Próximo à estação de trem'),
('13309-456', 'Avenida Brasil', '456', 'Jardim América', 'Itu', 'SP', 'Em frente ao parque central'),
('13402-789', 'Rua do Comércio', '789', 'Centro', 'Piracicaba', 'SP', 'Próximo ao shopping Piracicaba'),
('13501-101', 'Rua Santa Clara', '101', 'Vila Nova', 'Rio Claro', 'SP', NULL),
('13602-202', 'Avenida Paulista', '202', 'Centro', 'Limeira', 'SP', 'Ao lado do terminal rodoviário'),
('13703-303', 'Rua XV de Novembro', '303', 'Jardim Europa', 'Araras', 'SP', 'Em frente ao hospital municipal'),
('13804-404', 'Avenida Marginal', '404', 'Vila Industrial', 'Mogi Guaçu', 'SP', NULL),
('13905-505', 'Rua João Pessoa', '505', 'Centro', 'Amparo', 'SP', 'Próximo ao teatro municipal'),
('14006-606', 'Avenida Independência', '606', 'Jardim São Luiz', 'Ribeirão Preto', 'SP', 'Ao lado da universidade federal'),
('14107-707', 'Rua das Palmeiras', '707', 'Centro', 'Sertãozinho', 'SP', 'Perto da estação de ônibus');

INSERT INTO safra (data_plantio, data_colheita, observacoes)
VALUES ('2024-01-15', '2024-05-10', 'Safra realizada em condições climáticas favoráveis, alta produtividade.'),
('2024-02-01', '2024-06-05', 'Chuva excessiva durante o período de desenvolvimento.'),
('2024-03-20', '2024-07-25', 'Uso de sementes híbridas, bom controle de pragas.'),
('2024-04-10', '2024-08-15', 'Problemas com estiagem, safra reduzida.'),
('2024-05-05', '2024-09-10', 'Experiência com novos fertilizantes, bons resultados.'),
('2024-06-01', '2024-10-05', 'Pragas controladas com sucesso, qualidade do grão elevada.'),
('2024-07-20', '2024-11-15', 'Rotação de culturas realizada com milho na área anterior.'),
('2024-08-10', '2024-12-05', 'Previsão de colheita em dia ensolarado, maquinário novo utilizado.'),
('2024-09-15', '2025-01-20', 'Técnicas de irrigação avançadas implementadas.'),
('2024-10-01', '2025-02-25', 'Safra experimental com variedade resistente ao calor.');

INSERT INTO tipo_produto (nome)
VALUES ('Faricíneo'), ('Amido'), ('Cereal'), ('Flocos'), ('Grão'), ('Salgadinho'), ('Óleo'), ('Pipoca'), ('Canjica'), ('Ração'), ('Semente');

INSERT INTO tipo_orcamento (nome)
VALUES ('Venda'), ('Compra');

INSERT INTO funcao (nome)
VALUES ('Moagem de Grãos'),
('Separação de Impurezas'),
('Extrusão de Massas'),
('Estufagem de Pipoca'),
('Mistura de Ingredientes'),
('Envase de Produtos'),
('Rotulagem Automática'),
('Secagem de Flocos'),
('Embalagem de Snacks'),
('Preparo de Solo'),
('Plantio Automatizado'),
('Pulverização de Insumos'),
('Irrigação Controlada'),
('Colheita Mecanizada');

INSERT INTO funcionario (nome, cpf, rg, data_nascimento, telefone, email, data_admissao, salario, fk_status, fk_endereco, fk_cargo, fk_setor)
VALUES ('Zenalvo Bastos Pinto Junior', '36512367823', 'SP165498711', '1997-12-03', '(11)91090-3322', 'zenalvo@technomilho.com', CURDATE(), 12000.00, 1, 13, 3, 1),
('Aline da Silva Lima', '32165497872', 'SP78372895', '1983-09-22', '(11)98492-3452', 'alin@technomilho.com', CURDATE(), 9000.00, 1, 15, 1, 1),
('Erika Martiniano de Oliveira', '74895724534', 'SP93748251', '1983-12-23', '(11)98425-1357', 'erika@technomilho.com', CURDATE(), 9000.00, 1, 14, 1, 1),
('Lucas Nascimento Duque', '92345123450', 'SP9352124', '2001-03-15', '(11)92345-6541', 'lucas@technomilho.com', CURDATE(), 12000.00, 1, 16, 1, 1),
('Ana Maria Souza', '12345678901', 'MG12345678', '1990-02-15', '(11)91234-5678', 'ana.souza@technomilho.com', CURDATE(), 4500.00, 1, 1, 7, 7),
('Carlos Alberto Lima', '98765432100', 'SP98765432', '1985-07-10', '(11)98765-4321', 'carlos.lima@technomilho.com', CURDATE(), 3800.00, 1, 2, 8, 7),
('Fernanda Oliveira', '11223344556', 'RJ11223344', '1992-05-25', '(21)99887-6655', 'fernanda.oliveira@technomilho.com', CURDATE(), 5000.00, 1, 3, 1, 1),
('Roberto Silva', '55667783990', 'BA55667788', '1988-03-18', '(71)99654-1234', 'roberto.silva@technomilho.com', CURDATE(), 6200.00, 1, 4, 3, 3),
('Juliana Mendes', '22334455667', 'SP22334455', '1995-08-30', '(11)91234-5566', 'juliana.mendes@technomilho.com', CURDATE(), 4000.00, 1, 5, 5, 4),
('Marcelo Santos', '33445566778', 'PR33445566', '1980-12-12', '(41)99876-5432', 'marcelo.santos@technomilho.com', CURDATE(), 7000.00, 1, 6, 10, 8),
('Camila Rodrigues', '44556677889', 'MG44556677', '1998-06-15', '(31)98765-1234', 'camila.rodrigues@technomilho.com', CURDATE(), 3600.00, 1, 7, 12, 7),
('João Pedro Souza', '55667788990', 'RJ55667788', '1991-11-22', '(21)98765-4321', 'joao.souza@technomilho.com', CURDATE(), 4100.00, 1, 8, 9, 9),
('Patrícia Almeida', '66778899001', 'BA66778899', '1993-09-17', '(71)99788-6655', 'patricia.almeida@technomilho.com', CURDATE(), 3200.00, 1, 9, 12, 10),
('Ricardo Costa', '77889900112', 'SP77889900', '1987-04-01', '(11)91234-8899', 'ricardo.costa@technomilho.com', CURDATE(), 3800.00, 1, 10, 2, 5);

INSERT INTO fornecedor (razao_social, nome_fantasia, cnpj, telefone, email, inscricao_estadual, fk_status, fk_endereco)
VALUES ('AgroInsumos Brasil Ltda.', 'AgroInsumos', '12.111.222/0001-10', '(11)94567-1234', 'contato@agroinsumos.com', 101234567, 1, 21),
('TecnoMáquinas Agroindustriais S/A', 'TecnoMáquinas', '13.222.333/0001-20', '(11)99876-5432', 'suporte@tecnomaquinas.com', 102345678, 1, 22),
('Peças & Soluções Mecânicas Ltda.', 'Peças & Soluções', '14.333.444/0001-30', '(21)91234-5566', 'vendas@pecasesolucoes.com', 103456789, 1, 23),
('Fertilizantes do Campo Ltda.', 'FertCampo', '15.444.555/0001-40', '(71)98765-4321', 'comercial@fertcampo.com', 104567890, 1, 24),
('EquipAgro Maquinários Agrícolas S/A', 'EquipAgro', '16.555.666/0001-50', '(41)99887-6655', 'info@equipagro.com', 105678901, 1, 25),
('RuralTratores Comércio de Máquinas Ltda.', 'RuralTratores', '17.666.777/0001-60', '(31)99654-7890', 'suporte@ruraltratores.com', 106789012, 1, 26),
('NutriSolo Fertilizantes Orgânicos Ltda.', 'NutriSolo', '18.777.888/0001-70', '(31)98765-4321', 'atendimento@nutrisolo.com', 107890123, 1, 17),
('AgriTech Ferramentas Agrícolas Ltda.', 'AgriTech', '19.888.999/0001-80', '(11)91234-6677', 'contato@agritech.com', 108901234, 1, 18),
('PowerPecas Máquinas e Ferramentas Ltda.', 'PowerPecas', '20.999.000/0001-90', '(71)99788-5544', 'suporte@powerpecas.com', 109012345, 1, 19),
('GrãoFert Soluções em Insumos S/A', 'GrãoFert', '21.000.111/0001-00', '(11)94567-1234', 'info@graofert.com', 110123456, 1, 20);

INSERT INTO cliente (razao_social, nome_fantasia, cnpj, telefone, email, inscricao_estadual, fk_status, fk_endereco)
VALUES ('Supermercado Central Ltda', 'Super Central', '12.345.678/0001-01', '(11)3003-1234', 'contato@supercentral.com', 100001, 1, 31),
('Atacado União LTDA', 'Atacado União', '23.456.789/0001-02', '(11)4004-5678', 'vendas@atacadouniao.com', 100002, 1, 32),
('Padaria Pão Quente ME', 'Pão Quente', '34.567.890/0001-03', '(11)98765-4321', 'atendimento@paoquente.com', 100003, 1, 33),
('Restaurante Sabor Caseiro LTDA', 'Sabor Caseiro', '45.678.901/0001-04', '(11)98989-1111', 'contato@saborcaseiro.com', 100004, 1, 34),
('Lanchonete Fast Food LTDA', 'Fast Food', '56.789.012/0001-05', '(11)92222-3333', 'vendas@fastfood.com', 100005, 1, 35),
('Empório Natural ME', 'Empório Natural', '67.890.123/0001-06', '(11)95555-4444', 'sac@emporionatural.com', 100006, 1, 36),
('Distribuidora ABC Ltda', 'Distribuidora ABC', '78.901.234/0001-07', '(11)94444-5555', 'compras@distribuidoraabc.com', 100007, 1, 37),
('Mercado Popular LTDA', 'Mercado Popular', '89.012.345/0001-08', '(11)96666-6666', 'contato@mercadopopular.com', 100008, 1, 38),
('Casa de Rações Bicho Feliz', 'Bicho Feliz', '90.123.456/0001-09', '(11)93333-7777', 'vendas@bichofeliz.com', 100009, 1, 39),
('Comércio de Bebidas Águia LTDA', 'Bebidas Águia', '01.234.567/0001-10', '(11)97777-8888', 'atendimento@bebidasaguia.com', 100010, 1, 40);

INSERT INTO produto (nome, quantidade_total, valor, descricao, fk_tipo_produto)
VALUES ('PipoocaTech Premium', 100, 12.90, 'Selecionado com rigor, ele oferece grãos uniformes que garantem maior rendimento e explosões perfeitas, resultando em pipocas mais crocantes e volumosas. Ideal para quem busca uma experiência gourmet, seja em casa ou no comércio, o PipoocaTech Premium é sinônimo de sabor, leveza e tradição.', 8),
('Farinácea Plus', 200, 8.50, 'Farinha de milho refinada, ideal para o preparo de bolos, biscoitos e pratos tradicionais. Produto de alta qualidade com textura fina.', 1),
('Amido de Milho Premium', 150, 7.30, 'Amido de milho puro, perfeito para engrossar molhos, sopas e sobremesas com textura suave e consistência ideal.', 2),
('Cereal Mix Integral', 120, 10.90, 'Mistura nutritiva de flocos de milho e cereais integrais, ideal para um café da manhã equilibrado e cheio de energia.', 3),
('Floco Mais Milho', 180, 9.20, 'Flocos de milho pré-cozidos, perfeitos para cuscuz e receitas rápidas e nutritivas.', 4),
('Grãos Gourmet', 300, 11.50, 'Grãos de milho selecionados para preparo de pratos tradicionais, com alta durabilidade e sabor incomparável.', 5),
('Salgadinho Crunch', 250, 3.99, 'Salgadinhos de milho crocantes e saborosos, disponíveis nos sabores queijo, churrasco e cebola.', 6),
('Óleo de Milho Premium', 100, 14.50, 'Óleo de milho extraído com processos modernos, garantindo um produto leve, saudável e ideal para culinária diária.', 7),
('Canjica Doce', 90, 6.80, 'Grãos de canjica branca selecionados, ideais para receitas doces e tradicionais, com cozimento rápido e uniforme.', 9),
('Ração NutriPet', 200, 18.70, 'Ração à base de milho para aves e suínos, formulada para oferecer nutrientes essenciais e melhorar o desempenho dos animais.', 10);

INSERT INTO producao (lote, data_fabricacao, data_vencimento, quantidade, fk_safra, fk_produto)
VALUES ('LT20231101', '2023-11-01', '2024-11-01', 500, 1, 1), 
('LT20231215', '2023-12-15', '2025-12-15', 400, 2, 2), 
('LT20240110', '2024-01-10', '2025-01-10', 600, 3, 3), 
('LT20240205', '2024-02-05', '2026-02-05', 700, 4, 4), 
('LT20240320', '2024-03-20', '2025-03-20', 350, 5, 5), 
('LT20240412', '2024-04-12', '2026-04-12', 450, 6, 6), 
('LT20240508', '2024-05-08', '2025-05-08', 550, 7, 7), 
('LT20240625', '2024-06-25', '2026-06-25', 300, 8, 8), 
('LT20240715', '2024-07-15', '2025-07-15', 250, 9, 9), 
('LT20240830', '2024-08-30', '2025-08-30', 400, 10, 10);

INSERT INTO orcamento_venda (titulo, descricao, data, valor_total, fk_tipo_orcamento, fk_funcionario, fk_cliente, fk_status)
VALUES ('Venda 001', 'Orçamento para fornecimento mensal', '2024-11-15', 1500.00, 1, 8, 1, 4),
('Venda 002', 'Pedido de cereais diversos', '2024-11-16', 3200.00, 1, 8, 2, 3),
('Venda 003', 'Fornecimento de milho pipoca premium', '2024-11-17', 4500.00, 1, 8, 3, 6),
('Venda 004', 'Proposta para amidos alimentícios', '2024-11-18', 2200.00, 1, 8, 4, 3),
('Venda 005', 'Orçamento de óleo de milho refinado', '2024-11-19', 1800.00, 1, 8, 5, 6),
('Venda 006', 'Oferta de ração animal a granel', '2024-11-20', 5000.00, 1, 8, 6, 4),
('Venda 007', 'Proposta de fornecimento de flocos de milho', '2024-11-21', 2700.00, 1, 8, 7, 3),
('Venda 008', 'Pacote para canjica premium', '2024-11-22', 3300.00, 1, 8, 8, 6),
('Venda 009', 'Fornecimento contínuo de salgadinhos', '2024-11-23', 4800.00, 1, 8, 9, 3),
('Venda 010', 'Orçamento anual para grãos selecionados', '2024-11-24', 5500.00, 1, 8, 10, 4),
('Venda 011', 'Oferta de cereais integrais', '2024-11-25', 2000.00, 1, 8, 1, 6),
('Venda 012', 'Proposta de sementes especiais', '2024-11-26', 1200.00, 1, 8, 2, 3),
('Venda 013', 'Orçamento de milho pipoca premium', '2024-11-27', 3600.00, 1, 8, 3, 4),
('Venda 014', 'Venda de faricíneos especiais', '2024-11-28', 4100.00, 1, 8, 4, 3),
('Venda 015', 'Proposta para fornecimento de ração', '2024-11-29', 2500.00, 1, 8, 5, 6),
('Venda 016', 'Oferta de amido de milho refinado', '2024-11-30', 2900.00, 1, 8, 6, 4),
('Venda 017', 'Orçamento de óleo de milho premium', '2024-12-01', 3700.00, 1, 8, 7, 3),
('Venda 018', 'Proposta para entrega semanal de pipocas', '2024-12-02', 6100.00, 1, 8, 8, 6),
('Venda 019', 'Fornecimento de flocos crocantes', '2024-12-03', 4400.00, 1, 8, 9, 3),
('Venda 020', 'Venda de milho para pipoca gourmet', '2024-12-04', 5200.00, 1, 8, 10, 4);

INSERT INTO detalhes_produto (quantidade, subtotal, fk_orcamento_venda, fk_produto)
VALUES (150, 1500.00, 1, 3), 
(400, 3200.00, 2, 2), 
(250, 4500.00, 3, 8), 
(300, 3300.00, 4, 7), 
(120, 2160.00, 5, 10), 
(500, 5000.00, 6, 3),
(350, 2700.00, 7, 4), 
(200, 3300.00, 8, 7), 
(500, 4800.00, 9, 6),
(600, 5500.00, 10, 1), 
(250, 2000.00, 11, 2), 
(150, 1200.00, 12, 9), 
(300, 3600.00, 13, 8), 
(400, 4100.00, 14, 5), 
(200, 2500.00, 15, 3),
(200, 3000.00, 11, 7), 
(350, 2450.00, 12, 4), 
(500, 4800.00, 13, 6), 
(400, 4100.00, 14, 5), 
(100, 1500.00, 15, 9);

INSERT INTO orcamento_compra (titulo, descricao, data, valor_total, fk_tipo_orcamento, fk_funcionario, fk_fornecedor, fk_status)
VALUES ('Compra de Sementes', 'Aquisição de sementes selecionadas para plantio', '2024-11-20', 5000.00, 2, 9, 1, 6),
('Compra de Amidos', 'Pedido de amido de trigo para produção de salgadinhos', '2024-11-19', 7500.00, 2, 9, 2, 3), 
('Compra de Ração', 'Ração suplementar para alimentação de animais', '2024-11-18', 6200.00, 2, 9, 3, 4), 
('Acessórios para Maquinário', 'Peças e acessórios para manutenção de maquinário agrícola', '2024-11-17', 8900.00, 2, 9, 4, 3), 
('Óleo Refinado', 'Aquisição de óleo vegetal refinado para embalagens industriais', '2024-11-16', 5500.00, 2, 9, 5, 6), 
('Farinha de Trigo', 'Compra de farinha de trigo para linhas de produção específicas', '2024-11-15', 4300.00, 2, 9, 6, 3),
('Manutenção Agrícola', 'Serviço e peças para tratores e máquinas', '2024-11-14', 10200.00, 2, 9, 7, 4), 
('Embalagens para Produtos', 'Aquisição de sacos e caixas para embalagem', '2024-11-13', 3800.00, 2, 9, 8, 6),
('Cereais Diversos', 'Compra de cereais como trigo e aveia para produtos mistos', '2024-11-12', 9600.00, 2, 9, 9, 3), 
('Produtos Químicos', 'Aquisição de fertilizantes e defensivos agrícolas', '2024-11-11', 7200.00, 2, 9, 10, 4);

INSERT INTO pedido_venda (fk_orcamento_venda, data_pedido)
VALUES (2, CURDATE()), (4, CURDATE()), (7, CURDATE()), (9, CURDATE()), (12, CURDATE()), (14, CURDATE()), (17, CURDATE()), (19, CURDATE());

INSERT INTO pedido_compra (fk_orcamento_compra, data_pedido)
VALUES (1, CURDATE()), (4, CURDATE()), (6, CURDATE()), (9, CURDATE());

INSERT INTO maquinario (modelo, marca, numero_serie, numero_patrimonio, fk_funcao, fk_setor)
VALUES ('GrãoMaster 1000', 'AgroMach', 123456789, 101, 1, 11),  
('Purificador X', 'CleanTech', 987654321, 102, 2, 11),  
('Extrusor Pro', 'FoodPro', 112233445, 103, 3, 7), 
('EstufaMax 500', 'PopMaker', 667788990, 104, 4, 7), 
('Misturador Plus', 'MixPro', 334455667, 105, 5, 7),  
('EnvaseAutomático 3000', 'PackFast', 223344556, 106, 6, 7), 
('Rotuladora Quick', 'AutoLabel', 554433221, 107, 7, 7), 
('SecadorFloco 400', 'DryMaster', 998877665, 108, 8, 7), 
('EmbalagemSnack 5000', 'PackTech', 111223344, 109, 9, 7), 
('TratorTurbo 700', 'FarmEquip', 777888999, 110, 10, 11); 

INSERT INTO login_funcionario (codigo, senha, fk_codigo_funcionario)
VALUES (553372, 'Xf3#gK2kT5@9', 1),
(854227, 'P@ssw0rd$567', 2),
(720193, '8z#r1R%2f@3', 3),
(324651, 'Qw4erT!6oP7', 4),
(599831, '8Y#n8vO9t7', 5),
(430219, '3T@1hG&9aP5', 6),
(212315, 'R$4d9Xw3p2', 7),
(676938, 'D#4j5sP8k7', 8),
(963781, 'Z1v5pK3oL@8', 9),
(142390, 'M2@k9T1zF8', 10),
(845014, '8Y#4oP7sD2', 11),
(654239, 'T@7g1pR9v2', 12),
(731208, '9L#oP4r3t8', 13),
(395417, 'R$5t6gO8p9', 14);

INSERT INTO login_cliente (cnpj, senha, fk_codigo_cliente)
VALUES ('12345678000101', 'S3gur4@123@Central!', 1),
('23456789000102', 'At4c@d0_Un1@0_2024$', 2),
('34567890000103', 'P@oQuente!22#2024', 3),
('45678901000104', 'S@b0rC@se1r0_!2024', 4),
('56789012000105', 'F@stF00d_2024!@', 5),
('67890123000106', 'Emp0r10!N@tur@l_2024', 6),
('78901234000107', 'D1str1buid0r@ABC@2024!', 7),
('89012345000108', 'M3rc@d0P0pul@r!@2024', 8),
('90123456000109', 'B1ch0F3l1z_R@c@o2024!', 9),
('12345670000110', 'B3b1d@s@gu14!_2024!@', 10);

-- 5. CRIANDO FUNÇÕES DE INSERT, UPDATE E DELETE PARA CADA TABELA

-- TABELA CARGO
DELIMITER //
CREATE PROCEDURE inserirCargo (IN nome_cargo VARCHAR(50))
BEGIN
	IF ((SELECT COUNT(*) FROM cargo WHERE nome LIKE BINARY nome_cargo) > 0) THEN
		SELECT "Cargo já registrado!";
	ELSE
		INSERT INTO cargo(nome)
		VALUES (nome_cargo);
		SELECT "Cargo registrado com sucesso!";
	END IF;
END //
DELIMITER ;

CALL inserirCargo('Tech Leader');
CALL inserirCargo('Assistente Administrativo');

DELIMITER //
CREATE PROCEDURE deletarCargo (IN nome_cargo VARCHAR(50))
BEGIN
	IF ((SELECT COUNT(*) FROM cargo WHERE nome LIKE BINARY nome_cargo) > 0) THEN
		DELETE FROM cargo
		WHERE nome LIKE BINARY nome_cargo;
	ELSE
		SELECT "Cargo não existe na base de dados!";
	END IF;
END //
DELIMITER ;

CALL deletarCargo('Assistente Administrativo');
CALL deletarCargo('AssiS'); -- TESTE DE ERRO

DELIMITER //
CREATE PROCEDURE atualizarCargo (IN cod INT, IN nome_cargo VARCHAR(50))
BEGIN
	IF ((SELECT COUNT(*) FROM cargo WHERE codigo = cod) > 0) THEN
		UPDATE cargo 
        SET nome = nome_cargo 
        WHERE cod = codigo;
        SELECT "Cargo atualizado com sucesso!";
	ELSE
		SELECT "Cargo não existe na base de dados!";
	END IF;
END //
DELIMITER ;

CALL atualizarCargo(20, 'Tech Leader Senior');

-- TABELA STATUS E TABELA TIPO_ORCAMENTO NÃO TERÁ OUTRAS INSERÇÕES, ATUALIZAÇÕES OU DELEÇÕES

-- TABELA SETOR
DELIMITER //
CREATE PROCEDURE inserirSetor (IN nome_setor VARCHAR(30))
BEGIN
	IF ((SELECT COUNT(*) FROM setor WHERE nome LIKE BINARY nome_setor) > 0) THEN
		SELECT "Setor já está registrado!";
    ELSE
		INSERT INTO setor (nome)
        VALUES (nome_setor);
        SELECT "Setor cadastrado com sucesso";
	END IF; 
END //
DELIMITER ;

CALL inserirSetor('Limpeza'); -- TESTE DE ERRO
CALL inserirSetor('Trituração');

DELIMITER //
CREATE PROCEDURE deletarSetor (IN nome_setor VARCHAR(30))
BEGIN
	IF ((SELECT COUNT(*) FROM setor WHERE nome LIKE BINARY nome_setor) > 0) THEN
		DELETE FROM setor
		WHERE nome LIKE BINARY nome_setor;
	ELSE
		SELECT "Setor não existe na base de dados!";
	END IF;
END //
DELIMITER ;

CALL deletarSetor('Trituração');

DELIMITER //
CREATE PROCEDURE atualizarSetor (IN cod INT, IN nome_setor VARCHAR(30))
BEGIN
	IF ((SELECT COUNT(*) FROM setor WHERE nome LIKE BINARY nome_setor OR codigo = cod) > 0) THEN
		UPDATE setor
        SET nome = nome_setor
        WHERE codigo = cod;
        SELECT "Setor atualizado com sucesso!";
	ELSE
		SELECT "Setor não existe na base de dados!";
	END IF;
END //
DELIMITER ;

CALL atualizarSetor(15, 'Limpeza Geral');

SELECT * FROM setor;

-- TABELA ENDEREÇO (NÃO PODE SER DELETADO - RN)
DELIMITER //
CREATE PROCEDURE inserirEndereco (IN cep_n VARCHAR(9), 
	IN logradouro_n VARCHAR(150), 
	IN numero_n VARCHAR(20), 
    IN bairro_n VARCHAR(50),
    IN cidade_n VARCHAR(50),
    IN uf_n CHAR(2),
    IN complemento_n VARCHAR(50))
BEGIN
	IF ((SELECT COUNT(*) FROM endereco WHERE cep = cep_n AND numero = numero_n) > 0) THEN
		SELECT "Endereço já está registado!";
	ELSE
		INSERT INTO endereco (cep, logradouro, numero, bairro, cidade, uf, complemento)
        VALUES (cep_n, logradouro_n, numero_n, bairro_n, cidade_n, uf_n, complemento_n);
        SELECT "Endereço registado com sucesso!";
    END IF;
END //
DELIMITER ;

CALL inserirEndereco ('01001-000', 'Praça da Sé', '100', 'Sé', 'São Paulo', 'SP', 'Próximo à Catedral da Sé');
CALL inserirEndereco ('01001-010', 'Praça aleatória', '101', 'Sé', 'São Paulo', 'SP', 'Próximo à Catedral da Sé');

DELIMITER //
CREATE PROCEDURE atualizarEndereco (
	IN cod INT, 
	IN cep_n VARCHAR(9), 
	IN logradouro_n VARCHAR(150), 
	IN numero_n VARCHAR(20), 
    IN bairro_n VARCHAR(50),
    IN cidade_n VARCHAR(50),
    IN uf_n CHAR(2),
    IN complemento_n VARCHAR(50)
)
BEGIN
	IF ((SELECT COUNT(*) FROM endereco WHERE codigo = cod) > 0) THEN
		UPDATE endereco
        SET cep = cep_n, logradouro = logradouro_n, numero = numero_n, bairro = bairro_n, cidade = cidade_n, uf = uf_n, complemento = complemento_n
        WHERE codigo = cod;
	ELSE 
		SELECT "Não existe endereco cadastrado!";
    END IF;
END //
DELIMITER ;

CALL atualizarEndereco(47, '01001-011', 'Praça da Catedral', '101', 'Sé', 'São Paulo', 'SP', 'Próximo à Catedral da Sé');

-- TABELA SAFRA - NÃO PODERÁ SER DELETADO (RN)
DELIMITER //
CREATE PROCEDURE inserirSafra (IN obs TEXT)
BEGIN
	INSERT INTO safra (data_plantio, data_colheita, observacoes)
    VALUES (CURDATE(), DATE_ADD(CURDATE(), INTERVAL 90 DAY), obs);
END //
DELIMITER ;

CALL inserirSafra(NULL); -- TESTE INSERÇÃO

DELIMITER //
CREATE PROCEDURE atualizarSafra (
	IN cod INT,
    IN dt_plantio DATE,
    IN dt_colheita DATE,
    IN obs TEXT
)
BEGIN
	IF ((SELECT COUNT(*) FROM safra WHERE codigo = cod) > 0) THEN
		UPDATE safra
        SET data_plantio = dt_plantio, data_colheita = dt_colheita, observacoes = obs
        WHERE codigo = cod;
        SELECT "Safra atualizada com sucesso!";
    ELSE
		SELECT "Safra não existe na base de dados!";
	END IF;
END //
DELIMITER ;

CALL atualizarSafra(11, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 90 DAY), 'Plantio de teste, para adaptação do solo.');

-- TABELA TIPO_PRODUTO
DELIMITER //
CREATE PROCEDURE inserirTipoProduto (
	IN nome_tipo VARCHAR(30)
)
BEGIN
	IF ((SELECT COUNT(*) FROM tipo_produto WHERE nome LIKE BINARY nome_tipo) > 0) THEN
		SELECT "Tipo de produto já cadastrado!";
	ELSE
		INSERT INTO tipo_produto (nome)
        VALUES (nome_tipo);
        SELECT "Tipo de produto cadastrado com sucesso!";
    END IF;
END //
DELIMITER ;

CALL inserirTipoProduto('Canjica'); -- TESTE DE ERRO
CALL inserirTipoProduto('Etanol');

DELIMITER //
CREATE PROCEDURE atualizarTipoProduto (
	IN cod INT,
    IN nome_tipo VARCHAR(30)
)
BEGIN
	IF ((SELECT COUNT(*) FROM tipo_produto WHERE codigo = cod) > 0) THEN
		UPDATE tipo_produto
        SET nome = nome_tipo
        WHERE codigo = cod;
        SELECT "Tipo de produto atualizado com sucesso!";
	ELSE 
		SELECT "Tipo de produto não existe na base de dados!";
    END IF;
END //
DELIMITER ;

CALL atualizarTipoProduto(6, 'Salgadinhos');
CALL atualizarTipoProduto(33, 'Salgadinhos'); -- TESTE DE ERRO

DELIMITER //
CREATE PROCEDURE deletarTipoProduto (IN cod INT)
BEGIN
	IF ((SELECT COUNT(*) FROM tipo_produto WHERE codigo = cod) > 0) THEN
		DELETE FROM tipo_produto
        WHERE codigo = cod;
        SELECT "Tipo de produto deletado com sucesso!";
	ELSE 
		SELECT "Tipo de produto não existe na base de dados!";
    END IF;
END // 
DELIMITER ;

CALL deletarTipoProduto(12); -- ETANOL

-- TABELA FUNÇÃO
DELIMITER //
CREATE PROCEDURE inserirFuncao (IN nome_funcao VARCHAR(50))
BEGIN
	IF ((SELECT COUNT(*) FROM funcao WHERE nome LIKE BINARY nome_funcao) > 0) THEN
		SELECT "Função já está registrado na base de dados!";
	ELSE
		INSERT INTO funcao (nome)
        VALUES (nome_funcao);
        SELECT "Função registrada com sucesso!";
	END IF;
END //
DELIMITER ;

CALL inserirFuncao('Triturador de grãos');
CALL inserirFuncao('Preparo de Solo'); -- TESTE DE ERRO

DELIMITER //
CREATE PROCEDURE atualizarFuncao (
	IN cod INT,
    IN nome_funcao VARCHAR(50)
)
BEGIN
	IF ((SELECT COUNT(*) FROM funcao WHERE codigo = cod) > 0) THEN
		UPDATE funcao
        SET nome = nome_funcao
        WHERE codigo = cod;
        SELECT "Função atualizada com sucesso!";
	ELSE
		SELECT "Função não existe na base de dados!";
	END IF;
END //
DELIMITER ;

CALL atualizarFuncao(16, 'Moedor');

DELIMITER //
CREATE PROCEDURE deletarFuncao (IN cod INT)
BEGIN
	IF ((SELECT COUNT(*) FROM funcao WHERE codigo = cod) > 0) THEN
		DELETE FROM funcao
        WHERE codigo = cod;
        SELECT "Função deletada com sucesso!";
	ELSE
		SELECT "Função não existe na base de dados!";
	END IF;
END //
DELIMITER ;

CALL deletarFuncao(16);

-- TABELA FUNCIONARIO
DELIMITER //
CREATE PROCEDURE inserirFuncionario (
	IN nome_n VARCHAR(80),
    IN cpf_n VARCHAR(11),
    IN rg_n VARCHAR(11),
    IN data_nascimento_n DATE,
    IN telefone_n VARCHAR(14),
    IN email_n VARCHAR(100),
    IN salario_n DECIMAL(6, 2),
    IN fk_status_n INT,
    IN fk_endereco_n INT,
    IN fk_cargo_n INT,
    IN fk_setor_n INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM funcionario WHERE cpf LIKE BINARY cpf_n) > 0) THEN
		SELECT "Funcionário já cadastrado!";
	ELSE 
		INSERT INTO funcionario (nome, cpf, rg, data_nascimento, telefone, email, data_admissao, salario, fk_status, fk_endereco, fk_cargo, fk_setor)
        VALUES (nome_n, cpf_n, rg_n, data_nascimento_n, telefone_n, email_n, CURDATE(), salario_n, fk_status_n, fk_endereco_n, fk_cargo_n, fk_setor_n);
        SELECT "Funcionário cadastrado com sucesso!";
	END IF;
END //
DELIMITER ;

CALL inserirFuncionario('Zenalvo Bastos Pinto Junior', '36512367823', 'SP165498711', '1997-12-03', '(11)91090-3322', 'zenalvo@technomilho.com', 12000.00, 1, 13, 3, 1); -- TESTE DE ERRO
CALL inserirFuncionario('Terigi Augusto Scardovelli', '98765465412', 'SP126734512', '1978-10-23', '(11)98767-3452', 'terigi@technomilho.com', 15000.00, 1, 43, 3, 1); 

DELIMITER //
CREATE PROCEDURE atualizarFuncionario (
	IN cod INT,
	IN nome_n VARCHAR(80),
    IN cpf_n VARCHAR(11),
    IN rg_n VARCHAR(11),
    IN data_nascimento_n DATE,
    IN telefone_n VARCHAR(14),
    IN email_n VARCHAR(100),
    IN salario_n DECIMAL(6, 2),
    IN fk_status_n INT,
    IN fk_endereco_n INT,
    IN fk_cargo_n INT,
    IN fk_setor_n INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM funcionario WHERE codigo = cod) > 0) THEN
		UPDATE funcionario
		SET nome = nome_n, cpf = cpf_n, rg = rg_n, data_nascimento = data_nascimento_n, telefone = telefone_n, email = email_n, salario = salario_n, fk_status = fk_status_n, fk_endereco = fk_endereco_n, fk_cargo = fk_cargo_n, fk_setor = fk_setor_n
		WHERE codigo = cod;
		SELECT "Funcionário atualizado com sucesso!";
	ELSE
		SELECT "Funcionário não está registrado!";
	END IF;
END //
DELIMITER ;

CALL atualizarFuncionario(15, 'Terigi Augusto Scardovelli', '98765465412', 'SP126734512', '1978-10-23', '(11)98767-3452', 'terigi@technomilho.com', 15000.00, 2, 42, 3, 1); 

DELIMITER //
CREATE PROCEDURE deletarFuncionario (
	IN cod INT -- MUDAR DEPOIS PARA CPF
)
BEGIN
	IF ((SELECT COUNT(*) FROM funcionario WHERE codigo = cod AND fk_status = 2) > 0) THEN
		SELECT "Funcionário já não faz mais parte dos nossos colaboradores!";
	ELSE 
		IF ((SELECT COUNT(*) FROM funcionario WHERE codigo = cod) > 0) THEN
			UPDATE funcionario
            SET fk_status = 2
            WHERE codigo = cod;
			SELECT "Funcionário deletado com sucesso!";
		ELSE
			SELECT "Funcionário não está registrado!";
		END IF;
	END IF;
END //
DELIMITER ;

CALL deletarFuncionario(12);

-- TABELA FORNECEDOR
DELIMITER //
CREATE PROCEDURE inserirFornecedor (
	IN razao_social_n VARCHAR(255),
    IN nome_fantasia_n VARCHAR(255),
    IN cnpj_n VARCHAR(18),
    IN telefone_n VARCHAR(14),
    IN email_n VARCHAR(100),
    IN inscricao_estadual_n INT,
    IN fk_status_n INT,
    IN fk_endereco_n INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM fornecedor WHERE cnpj LIKE BINARY cnpj_n) > 0) THEN
		SELECT "Fornecedor já está registrado na base de dados!";
	ELSE
		INSERT INTO fornecedor (razao_social, nome_fantasia, cnpj, telefone, email, inscricao_estadual, fk_status, fk_endereco)
        VALUES (razao_social_n, nome_fantasia_n, cnpj_n, telefone_n, email_n, inscricao_estadual_n, fk_status_n, fk_endereco_n);
        SELECT "Fornecedor registrado com sucesso!";
    END IF;
END //
DELIMITER ;

CALL inserirFornecedor('Junior Design e Marketing ME', 'JB Designer', '21.123.121/0001-10', '(11)91019-2345', 'contato@jbdesigner.com', 112323456, 1, 41);

DELIMITER //
CREATE PROCEDURE atualizarFornecedor (
	IN cod INT,
	IN razao_social_n VARCHAR(255),
    IN nome_fantasia_n VARCHAR(255),
    IN cnpj_n VARCHAR(18),
    IN telefone_n VARCHAR(14),
    IN email_n VARCHAR(100),
    IN inscricao_estadual_n INT,
    IN fk_status_n INT,
    IN fk_endereco_n INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM fornecedor WHERE codigo = cod) > 0) THEN
		UPDATE fornecedor
		SET razao_social = razao_social_n, nome_fantasia = nome_fantasia_n, cnpj = cnpj_n, telefone = telefone_n, email = email_n, inscricao_estadual = inscricao_estadual_n, fk_status = fk_status_n, fk_endereco = fk_endereco_n
		WHERE codigo = cod;
		SELECT "Fornecedor atualizado com sucesso!";
	ELSE 
		SELECT "Fornecedor não registrado na base de dados!";
    END IF;
END //
DELIMITER ;

CALL atualizarFornecedor(11, 'Junior Marketing e Design ME', 'JB Designer', '21.123.121/0001-10', '(11)91019-2345', 'contato@jbdesigner.com', 112323456, 2, 41);

DELIMITER //
CREATE PROCEDURE deletarFornecedor (
    IN cod INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM fornecedor WHERE codigo = cod AND fk_status = 2) > 0) THEN
		SELECT "Fornecedor não faz mais parte dos nossos fornecedores!";
	ELSE
		IF ((SELECT COUNT(*) FROM fornecedor WHERE codigo = cod) > 0) THEN
			UPDATE fornecedor
			SET fk_status = 2
            WHERE codigo = cod;
			SELECT "Fornecedor deletado com sucesso!";
		ELSE 
			SELECT "Fornecedor não registrado na base de dados!";
		END IF;
    END IF;
END //
DELIMITER ;

CALL deletarFornecedor(10);

-- TABELA CLIENTE
DELIMITER //
CREATE PROCEDURE inserirCliente (
	IN razao_social_n VARCHAR(255),
    IN nome_fantasia_n VARCHAR(255),
    IN cnpj_n VARCHAR(18),
    IN telefone_n VARCHAR(14),
    IN email_n VARCHAR(100),
    IN inscricao_estadual_n INT,
    IN fk_status_n INT,
    IN fk_endereco_n INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM cliente WHERE cnpj LIKE BINARY cnpj_n) > 0) THEN
		SELECT "Cliente já está registrado na base de dados!";
	ELSE
		INSERT INTO cliente (razao_social, nome_fantasia, cnpj, telefone, email, inscricao_estadual, fk_status, fk_endereco)
        VALUES (razao_social_n, nome_fantasia_n, cnpj_n, telefone_n, email_n, inscricao_estadual_n, fk_status_n, fk_endereco_n);
        SELECT "Cliente registrado com sucesso!";
    END IF;
END //
DELIMITER ;

CALL inserirCliente('Comércio de Rações LTDA', 'Mundo das Rações', '01.234.347/0001-10', '(11)97983-8445', 'atendimento@mundodasracoes.com', 123010, 1, 39);

DELIMITER //
CREATE PROCEDURE atualizarCliente (
	IN cod INT,
	IN razao_social_n VARCHAR(255),
    IN nome_fantasia_n VARCHAR(255),
    IN cnpj_n VARCHAR(18),
    IN telefone_n VARCHAR(14),
    IN email_n VARCHAR(100),
    IN inscricao_estadual_n INT,
    IN fk_status_n INT,
    IN fk_endereco_n INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM cliente WHERE codigo = cod AND fk_status = 2) > 0) THEN
		SELECT "O cliente não faz mais parte dos nossos clientes!";
	ELSE
		IF ((SELECT COUNT(*) FROM cliente WHERE codigo = cod) > 0) THEN
			UPDATE cliente
			SET razao_social = razao_social_n, nome_fantasia = nome_fantasia_n, cnpj = cnpj_n, telefone = telefone_n, email = email_n, inscricao_estadual = inscricao_estadual_n, fk_status = fk_status_n, fk_endereco = fk_endereco_n
            WHERE codigo = cod;
			SELECT "Cliente atualizado com sucesso!";
		ELSE 
			SELECT "Cliente não registrado na base de dados!";
		END IF;
    END IF;
END //
DELIMITER ;

CALL atualizarCliente(11, 'Mundo de Rações LTDA', 'Mundo das Rações', '01.234.347/0001-10', '(11)97983-8445', 'atendimento@mundodasracoes.com', 123010, 2, 39);

DELIMITER //
CREATE PROCEDURE deletarCliente (
    IN cod INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM cliente WHERE codigo = cod AND fk_status = 2) > 0) THEN
		SELECT "O cliente não faz mais parte dos nossos clientes!";
	ELSE
		IF ((SELECT COUNT(*) FROM cliente WHERE codigo = cod) > 0) THEN
			UPDATE cliente
			SET fk_status = 2
            WHERE codigo = cod;
			SELECT "Cliente deletado com sucesso!";
		ELSE 
			SELECT "Cliente não registrado na base de dados!";
		END IF;
    END IF;
END //
DELIMITER ;

CALL deletarCliente(10);

-- TABELA PRODUTO
DELIMITER //
CREATE PROCEDURE inserirProduto (
	IN nome_n VARCHAR(50),
    IN quantidade_total_n INT,
    IN valor_n DECIMAL(6, 2),
    IN descricao_n TEXT,
    IN fk_tipo_produto_n INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM produto WHERE nome LIKE BINARY nome_n) > 0) THEN
		SELECT "Produto já está registrado na base de dados!";
	ELSE
		INSERT INTO produto (nome, quantidade_total, valor, descricao, fk_tipo_produto)
        VALUES (nome_n, quantidade_total_n, valor_n, descricao_n, fk_tipo_produto_n);
        SELECT "Produto registrado com sucesso!";
    END IF;
END //
DELIMITER ;

CALL inserirProduto ('Cereal Xtreme Rings Chocolate', 200, 19.90, 'Cereal de milho sabor chocolate no formato de anéis', 3);

DELIMITER //
CREATE PROCEDURE atualizarProduto (
	IN cod INT,
	IN nome_n VARCHAR(50),
    IN quantidade_total_n INT,
    IN valor_n DECIMAL(6, 2),
    IN descricao_n TEXT,
    IN fk_tipo_produto_n INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM produto WHERE codigo = cod) > 0) THEN
		UPDATE produto
        SET nome = nome_n, quantidade_total = quantidade_total_n, valor = valor_n, descricao = descricao_n, fk_tipo_produto = fk_tipo_produto_n
        WHERE codigo = cod;
        SELECT "Produto atualizado com sucesso!";
	ELSE 
		SELECT "Produto não está registrado na base de dados!";
	END IF;
END //
DELIMITER ;

CALL atualizarProduto (11, 'Cereal Extreme Rings Chocolate', 200, 15.90, 'Cereal de milho sabor chocolate no formato de anéis', 3);

DELIMITER //
CREATE PROCEDURE deletarProduto (
	IN cod INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM produto WHERE codigo = cod) > 0) THEN
		DELETE FROM produto
        WHERE codigo = cod;
        SELECT "Produto deletado com sucesso!";
	ELSE 
		SELECT "Produto não está registrado na base de dados!";
	END IF;
END //
DELIMITER ;

CALL deletarProduto(11);

-- TABELA PRODUÇÃO (NÃO PODE SER DELETADO - RN)
DELIMITER //
CREATE PROCEDURE inserirProducao (
	IN lote_n VARCHAR(15),
    IN data_fabricacao_n DATE,
    IN validade INT,
    IN quantidade_n INT,
    IN fk_safra_n INT, 
    IN fk_produto_n INT
)
BEGIN
	INSERT INTO producao (lote, data_fabricacao, data_vencimento, quantidade, fk_safra, fk_produto)
    VALUES (lote_n, data_fabricacao_n, DATE_ADD(data_fabricacao_n, INTERVAL validade DAY), quantidade_n, fk_safra_n, fk_produto_n);
    SELECT "Produção registrado com sucesso!";
END //
DELIMITER ;

CALL inserirProducao ('LT20241126', CURDATE(), 90, 150, 3, 4);

DELIMITER //
CREATE PROCEDURE atualizarProducao (
	IN cod INT,
	IN lote_n VARCHAR(15),
    IN data_fabricacao_n DATE,
    IN validade INT,
    IN quantidade_n INT,
    IN fk_safra_n INT, 
    IN fk_produto_n INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM producao WHERE codigo = cod) > 0) THEN
		UPDATE producao
		SET lote = lote_n, data_fabricacao = data_fabricacao_n, data_vencimento = DATE_ADD(data_fabricacao_n, INTERVAL validade DAY), quantidade = quantidade_n, fk_safra = fk_safra_n, fk_produto = fk_produto_n
        WHERE codigo = cod;
		SELECT "Produção atualizada com sucesso!";
	ELSE
		SELECT "Produção não encontrado na base de dados!";
	END IF;
END //
DELIMITER ;

CALL atualizarProducao (21, 'LT20241129', '2024-11-29', 100, 150, 3, 4);

-- TABELA ORCAMENTO_VENDA
DELIMITER //
CREATE PROCEDURE inserirOrcamentoVenda (
	IN titulo_n VARCHAR(30),
    IN descricao_n VARCHAR(150),
    IN valor_total_n DECIMAL (10, 2),
    IN fk_funcionario_n INT,
    IN fk_cliente_n INT,
    IN fk_status_n INT
)
BEGIN
	IF (((SELECT COUNT(*) FROM cliente WHERE codigo = fk_cliente_n AND fk_status = 1) > 0) AND ((SELECT COUNT(*) FROM funcionario WHERE codigo = fk_funcionario_n AND fk_status = 1 AND fk_setor = 3) > 0)) THEN
		INSERT INTO orcamento_venda (titulo, descricao, data, valor_total, fk_tipo_orcamento, fk_funcionario, fk_cliente, fk_status)
		VALUES (titulo_n, descricao_n, CURDATE(), valor_total_n, 1, fk_funcionario_n, fk_cliente_n, fk_status_n);
		SELECT "Orçamento de venda efetuado com sucesso!";
	ELSE 
		IF (!((SELECT COUNT(*) FROM cliente WHERE codigo = fk_cliente_n) > 0) OR ((SELECT COUNT(*) FROM cliente WHERE codigo = fk_cliente_n AND fk_status = 2) > 0)) THEN
			SELECT "Cliente não encontrado!";
        END IF;
        IF (!((SELECT COUNT(*) FROM funcionario WHERE codigo = fk_funcionario_n) > 0) OR ((SELECT COUNT(*) FROM funcionario WHERE codigo = fk_funcionario_n AND fk_status = 2) > 0)) THEN
			SELECT "Funcionário não encontrado!";
        END IF;
	END IF;
END //
DELIMITER ;

CALL inserirOrcamentoVenda('VENDA 021', NULL, 20000.00, 8, 2, 6);

DELIMITER //
CREATE PROCEDURE atualizarOrcamentoVenda (
	IN cod INT,
	IN titulo_n VARCHAR(30),
    IN descricao_n VARCHAR(150),
    IN valor_total_n DECIMAL (10, 2),
    IN fk_status_n INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM orcamento_venda WHERE codigo = cod) > 0) THEN
		UPDATE orcamento_venda
		SET titulo = titulo_n, descricao = descricao_n, valor_total = valor_total_n, fk_status = fk_status_n
		WHERE codigo = cod;
		SELECT "Orçamento de venda atualizado com sucesso!";
	ELSE 
		SELECT "Orçamento de venda não encontrado!";
    END IF;
END //
DELIMITER ;

CALL atualizarOrcamentoVenda(21, 'VENDA 021', 'Venda de cereais, amido e farinhas', 1500.00, 6);
CALL atualizarOrcamentoVenda(111, 'VENDA 021', 'Venda de cereais, amido e farinhas', 1500.00, 6); -- TESTE DE ERRO

DELIMITER //
CREATE PROCEDURE deletarOrcamentoVenda (IN cod INT)
BEGIN
	IF ((SELECT COUNT(*) FROM orcamento_venda WHERE codigo = cod) > 0) THEN
		UPDATE orcamento_venda
        SET fk_status = 5 -- STATUS CANCELADO
        WHERE codigo = cod;
        SELECT "Orçamento de venda deletado com sucesso!";
	ELSE
		SELECT "Orçamento de venda não encontrado!";
	END IF;
END //
DELIMITER ;

CALL deletarOrcamentoVenda(20);

-- TABELA DETALHES PRODUTO
DELIMITER //
CREATE PROCEDURE inserirDetalhesProduto (
	IN quantidade_n INT,
    IN fk_orcamento_venda_n INT,
    IN fk_produto_n INT
)
BEGIN
	IF (((SELECT COUNT(*) FROM orcamento_venda WHERE codigo = fk_orcamento_venda_n AND fk_status <> 5) > 0) AND ((SELECT COUNT(*) FROM produto WHERE codigo = fk_produto_n) > 0)) THEN
		INSERT INTO detalhes_produto (quantidade, subtotal, fk_orcamento_venda, fk_produto)
        VALUES (quantidade_n, quantidade_n * (SELECT valor FROM produto WHERE codigo = fk_produto_n), fk_orcamento_venda_n, fk_produto_n);
        SELECT "Detalhes do produto inserido no orçamento de venda com sucesso!";
	ELSE
		IF (!((SELECT COUNT(*) FROM orcamento_venda WHERE codigo = fk_orcamento_venda_n AND fk_status <> 5) > 0)) THEN
			SELECT "Orçamento de venda não encontrando!";
        END IF;
        IF (!((SELECT COUNT(*) FROM produto WHERE codigo = fk_produto_n) > 0)) THEN
			SELECT "Produto não encontrado!";
        END IF;
    END IF;
END //
DELIMITER ;

CALL inserirDetalhesProduto (10, 21, 2);
CALL inserirDetalhesProduto (10, 20, 2); -- TESTE DE ERRO
CALL inserirDetalhesProduto (10, 21, 110); -- TESTE DE ERRO

DELIMITER //
CREATE PROCEDURE atualizarDetalhesProduto (
	IN cod INT,
	IN quantidade_n INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM detalhes_produto WHERE codigo = cod) > 0) THEN
		UPDATE detalhes_produto
        SET quantidade = quantidade_n, subtotal = quantidade_n * (SELECT P.valor FROM produto AS P, detalhes_produto AS DT WHERE P.codigo = DT.fk_produto AND DT.codigo = cod)
        WHERE codigo = cod;
        SELECT "Detalhes de produto atualizados com sucesso!";
	ELSE
		SELECT "Detalhes de produto não encontrado!";
	END IF;
END //
DELIMITER ;

CALL atualizarDetalhesProduto(21, 100);

DELIMITER //
CREATE PROCEDURE deletarDetalhesProduto (IN cod INT)
BEGIN
	IF ((SELECT COUNT(*) FROM detalhes_produto WHERE codigo = cod) > 0) THEN
		DELETE FROM detalhes_produto
        WHERE codigo = cod;
        SELECT "Detalhes de produto excluído com sucesso!";
	ELSE
		SELECT "Detalhes de produto não encontrado!";
	END IF;
END //
DELIMITER ;

CALL deletarDetalhesProduto(21);

-- TABELA ORCAMENTO_COMPRA
DELIMITER //
CREATE PROCEDURE inserirOrcamentoCompra (
	IN titulo_n VARCHAR(30),
	IN descricao_n VARCHAR(150),
    IN valor_total_n DECIMAL(10,2),
    IN fk_funcionario_n INT,
    IN fk_fornecedor_n INT,
    IN fk_status_n INT
)
BEGIN
	IF (((SELECT COUNT(*) FROM fornecedor WHERE codigo = fk_fornecedor_n AND fk_status = 1) > 0) AND ((SELECT COUNT(*) FROM funcionario WHERE codigo = fk_funcionario_n AND fk_status = 1 AND fk_setor = 4) > 0)) THEN
		INSERT INTO orcamento_compra (titulo, descricao, data, valor_total, fk_tipo_orcamento, fk_funcionario, fk_fornecedor, fk_status)
		VALUES (titulo_n, descricao_n, CURDATE(), valor_total_n, 2, fk_funcionario_n, fk_fornecedor_n, fk_status_n);
		SELECT "Orçamento de compra efetuado com sucesso!";
	ELSE 
		IF (!((SELECT COUNT(*) FROM fornecedor WHERE codigo = fk_fornecedor_n) > 0) OR ((SELECT COUNT(*) FROM fornecedor WHERE codigo = fk_fornecedor_n AND fk_status = 2) > 0)) THEN
			SELECT "Fornecedor não encontrado!";
        END IF;
        IF (!((SELECT COUNT(*) FROM funcionario WHERE codigo = fk_funcionario_n) > 0) OR ((SELECT COUNT(*) FROM funcionario WHERE codigo = fk_funcionario_n AND fk_status = 2) > 0)) THEN
			SELECT "Funcionário não encontrado!";
        END IF;
	END IF;
END //
DELIMITER ;

CALL inserirOrcamentoCompra('Compra de trator', 'Pedido de compra de trator para plantio automático', 520000.00, 9, 9, 6);
CALL inserirOrcamentoCompra('Compra de trator', 'Pedido de compra de trator para plantio automático', 520000.00, 15, 9, 6); -- TESTE DE ERRO
CALL inserirOrcamentoCompra('Compra de trator', 'Pedido de compra de trator para plantio automático', 520000.00, 9, 11, 6); -- TESTE DE ERRO

DELIMITER //
CREATE PROCEDURE atualizarOrcamentoCompra (
	IN cod INT,
    IN titulo_n VARCHAR(30),
    IN descricao_n VARCHAR(150),
    IN valor_total_n DECIMAL (10, 2),
    IN fk_status_n INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM orcamento_compra WHERE codigo = cod) > 0) THEN
		UPDATE orcamento_compra
        SET titulo = titulo_n, descricao = descricao_n, valor_total = valor_total_n, fk_status = fk_status_n
        WHERE codigo = cod;
        SELECT "Orçamento de venda atualizado com sucesso!";
    ELSE
		SELECT "Orçamento de venda não encontrado!";
    END IF;
END ///
DELIMITER ;

CALL atualizarOrcamentoCompra(11, 'Compra de Tratores', 'Pedido de compra de novos tratores', 680000.00, 3);

DELIMITER //
CREATE PROCEDURE deletarOrcamentoCompra(IN cod INT)
BEGIN
	IF ((SELECT COUNT(*) FROM orcamento_compra WHERE codigo = cod) > 0) THEN
		UPDATE orcamento_compra
        SET fk_status = 5 -- STATUS CANCELADO
        WHERE codigo = cod;
        SELECT "Orçamento de compra deletado com sucesso!";
	ELSE
		SELECT "Orçamento de compra não encontrado!";
	END IF;
END //
DELIMITER ;

CALL deletarOrcamentoCompra(10);

-- AS TABELAS PEDIDO_VENDA E PEDIDO_COMPRA SÓ VAI RECBER INSERÇÃO QUANDO OS ORÇAMENTOS TIVEREM STATUS "APROVADO", NÃO PODERÁ TER ATUALIZAÇÃO OU DELEÇÃO (RN)

-- TABELA MAQUINARIO
DELIMITER //
CREATE PROCEDURE inserirMaquinario (
	IN modelo_n VARCHAR(30),
    IN marca_n VARCHAR(30),
    IN numero_serie_n INT,
    IN numero_patrimonio_n INT, 
    IN fk_funcao_n INT, 
    IN fk_setor_n INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM maquinario WHERE numero_serie = numero_serie_n) > 0) THEN
		SELECT "Maquinario com esse numero de série já cadastrado!";
	ELSE 
		IF ((SELECT COUNT(*) FROM maquinario WHERE numero_patrimonio = numero_patrimonio_n) > 0) THEN
			SELECT "Maquinario com esse numero de patrimônio já cadastrado!";
		ELSE 
			INSERT INTO maquinario (modelo, marca, numero_serie, numero_patrimonio, fk_funcao, fk_setor)
            VALUES (modelo_n, marca_n, numero_serie_n, numero_patrimonio_n, fk_funcao_n, fk_setor_n);
            SELECT "Maquinario cadastrado com sucesso!";
        END IF;
    END IF;
END //
DELIMITER ;

CALL inserirMaquinario('Trator Ultra Farm 2025', 'FarmEquip', 777888899, 111, 11, 10);
CALL inserirMaquinario('Trator Ultra Farm 2025', 'FarmEquip', 777888999, 111, 11, 10); -- TESTE DE ERRO
CALL inserirMaquinario('Trator Ultra Farm 2025', 'FarmEquip', 777888299, 110, 11, 10); -- TESTE DE ERRO

DELIMITER //
CREATE PROCEDURE atualizarMaquinario (
	IN cod INT,
	IN modelo_n VARCHAR(30),
    IN marca_n VARCHAR(30),
    IN fk_funcao_n INT, 
    IN fk_setor_n INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM maquinario WHERE codigo = cod) > 0) THEN
		UPDATE maquinario
		SET modelo = modelo_n, marca = marca_n, fk_funcao = fk_funcao_n, fk_setor = fk_setor_n
		WHERE codigo = cod;
		SELECT "Maquinario atualizado com sucesso!";
	ELSE 
		SELECT "Maquinario não encontrado!";
	END IF;
END //
DELIMITER ;

CALL atualizarMaquinario(11, 'Trator Turbo Ultra Farm 2025', 'FarmEquip', 10, 11);

DELIMITER //
CREATE PROCEDURE deletarMaquinario (IN cod INT)
BEGIN
	IF ((SELECT COUNT(*) FROM maquinario WHERE codigo = cod) > 0) THEN
		DELETE FROM maquinario
        WHERE codigo = cod;
        SELECT "Maquinario deletado com sucesso!";
	ELSE
		SELECT "Maquinario não encontrado!";
    END IF;
END //
DELIMITER ;

CALL deletarMaquinario(11);

-- TABELAS LOGIN_FUNCIONARIO E LOGIN_CLIENTE SERÃO INSERIDOS AUTOMATICAMENTE ASSIM QUE FOR CADASTRADO UM FUNCIONARIO OU CLIENTE E SERÃO EXCLUÍDOS AUTOMATICAMENTE QUANDO HOUVER UMA EXCLUSÃO (LÓGICA) DOS MESMOS (RN)
-- TABELA LOGIN_FUNCIONARIO
DELIMITER //
CREATE PROCEDURE atualizarLoginFuncionario (
	IN cod INT,
    IN nova_senha VARCHAR(32)
)
BEGIN
	IF ((SELECT COUNT(*) FROM login_funcionario WHERE codigo = cod) > 0) THEN
		IF ((SELECT COUNT(*) FROM login_funcionario WHERE senha LIKE BINARY nova_senha AND codigo = cod) > 0) THEN
			SELECT "Não é possível inserir a mesma senha!";
		ELSE
			UPDATE login_funcionario
			SET senha = nova_senha
            WHERE codigo = cod;
            SELECT "Senha atualizada com sucesso!";
        END IF;
    ELSE
		SELECT "Usuário não encontrado!";
    END IF;
END //
DELIMITER ;

CALL atualizarLoginFuncionario(963781, 'Z1v5pK3oL@8'); -- TESTE DE ERRO
CALL atualizarLoginFuncionario(923233781, 'Z1v5pK3oL8'); -- TESTE DE ERRO
CALL atualizarLoginFuncionario(963781, 'Z1v5pK3oL@932'); 

-- TABELA LOGIN_CLIENTE
DELIMITER //
CREATE PROCEDURE atualizarLoginCliente (
	IN cnpj_n VARCHAR(14),
    IN nova_senha VARCHAR(32)
)
BEGIN
	IF ((SELECT COUNT(*) FROM login_cliente WHERE cnpj LIKE BINARY cnpj_n) > 0) THEN
		IF ((SELECT COUNT(*) FROM login_cliente WHERE senha LIKE BINARY nova_senha AND cnpj LIKE BINARY cnpj_n) > 0) THEN
			SELECT "Não é possível inserir a mesma senha!";
		ELSE
			UPDATE login_cliente
			SET senha = nova_senha
            WHERE cnpj LIKE BINARY cnpj_n;
            SELECT "Senha atualizada com sucesso!";
        END IF;
    ELSE
		SELECT "Usuário não encontrado!";
    END IF;
END //
DELIMITER ;

CALL atualizarLoginCliente('90123456000109', 'B1ch0F3l1z_R@c@o2024!'); -- TESTE DE ERRO
CALL atualizarLoginCliente('12123456000987', 'B1ch0F3l1z_R@c@o2024!'); -- TESTE DE ERRO
CALL atualizarLoginCliente('90123456000109', 'B1ch0F3l1z_R@c@o2024!2');

-- 4. GERANDO 4 VIEWS PARA RELATÓRIOS GERENCIAIS

-- VIEW 1 - MOSTRAR TODOS OS NOMES DE FUNCIONARIOS, CARGOS, SETORES, DATA DE ADMISSÃO, TELEFONE E EMAIL
CREATE VIEW listaFuncionarios AS
SELECT F.nome AS Funcionario, C.nome AS Cargo, S.nome AS Setor, F.telefone AS Telefone, F.email AS Email, F.data_admissao AS Data_Admissao
FROM funcionario AS F, cargo AS C, setor AS S
WHERE F.fk_cargo = C.codigo AND F.fk_setor = S.codigo;

SELECT * FROM listaFuncionarios;

-- VIEW 2 - MOSTRAR TODOS OS NOMES FANTASIA DOS CLIENTES, CNPJ, QUANTIDADE DE COMPRAS APROVADAS E VALOR TOTAL DE TODAS AS COMPRAS FEITAS
CREATE OR REPLACE VIEW relatorio_cliente_compras AS
SELECT C.nome_fantasia AS Nome_Fantasia, C.cnpj AS CNPJ, (SELECT COUNT(codigo) FROM orcamento_venda WHERE C.codigo = fk_cliente AND fk_status = 3) AS Quantidade_Compras, (SELECT SUM(valor_total) FROM orcamento_venda WHERE C.codigo = fk_cliente AND fk_status = 3) AS Valor_Vendas
FROM cliente AS C
ORDER BY Quantidade_Compras DESC;

SELECT * FROM relatorio_cliente_compras;

-- VIEW 3 - LISTAR TODOS OS PRODUTOS COM QUANTIDADE MAIOR QUE 0, MOSTRAR SEUS RESPECTIVOS TIPOS, DATA DA SAFRA, LOTE, DATA DA PRODUÇÃO, DATA DE VALIDADE, QUANTIDADE E VALOR
CREATE VIEW listaProdutos AS
SELECT PTO.nome AS Produto, TP.nome AS Tipo, S.data_colheita AS Data_Safra, PD.lote AS Lote, PD.data_fabricacao AS Data_Fabricacao, PD.data_vencimento AS Data_vencimento, PTO.quantidade_total AS Estoque, PTO.valor AS Preço
FROM produto AS PTO, tipo_produto AS TP, safra AS S, producao AS PD
WHERE PTO.fk_tipo_produto = TP.codigo AND PD.fk_safra = S.codigo AND PD.fk_produto = PTO.codigo;

SELECT * FROM listaProdutos;

-- VIEW 4 - CONSULTA DE ORCAMENTOS DE COMPRAS COM TITULO, DESCRICAO, DATA, VALOR_TOTAL, NOME DO FUNCIONARIO QUE SOLICITOU, NOME FANTASIA DO FORNECEDOR E APENAS O QUE O STATUS FOR DIFERENTE DE "CANCELADO
CREATE VIEW listaOrcamentosCompra AS
SELECT OC.titulo AS Titulo, OC.descricao AS Descricao, OC.valor_total AS Valor_total, FUNC.nome AS Funcionario, FN.nome_fantasia AS Fornecedor, S.nome AS Status_Orcamento
FROM orcamento_compra AS OC, funcionario AS FUNC, fornecedor AS FN, status_tab AS S
WHERE OC.fk_funcionario = FUNC.codigo AND OC.fk_fornecedor = FN.codigo AND OC.fk_status = S.codigo AND S.nome NOT LIKE 'Cancelado';

-- 7. CRIANDO 3 ÍNDICES: RAZÃO SOCIAL E NOME FANTASIA DO CLIENTE, NOME DO FUNCIONARIO E NOMES DOS PRODUTOS
CREATE INDEX idx_nome_fantasia_cliente
ON cliente (razao_social, nome_fantasia);

CREATE INDEX idx_nome_funcionario
ON funcionario (nome);

CREATE INDEX ix_nome_produtos
ON produto (nome);

-- 8. INSERINDO TRANSACTION NA PROCEDURE "inserirOrcamentoVenda" PARA ATENDER À REGRA DE NEGÓCIO RN-006 - PRODUTO SÓ ENTRA EM ORÇAMENTO SE A QUANTIDADE NO ESTOQUE FOR MAIOR QUE 0
DROP PROCEDURE IF EXISTS inserirDetalhesProduto;
DELIMITER //
CREATE PROCEDURE inserirDetalhesProduto (
	IN quantidade_n INT,
    IN fk_orcamento_venda_n INT,
    IN fk_produto_n INT
)
BEGIN
	START TRANSACTION;
		IF (((SELECT COUNT(*) FROM orcamento_venda WHERE codigo = fk_orcamento_venda_n AND fk_status <> 5) > 0) AND ((SELECT COUNT(*) FROM produto WHERE codigo = fk_produto_n) > 0)) THEN
			IF ((SELECT COUNT(*) FROM produto WHERE codigo = fk_produto_n AND quantidade_total > 0) > 0) THEN
				INSERT INTO detalhes_produto (quantidade, subtotal, fk_orcamento_venda, fk_produto)
				VALUES (quantidade_n, quantidade_n * (SELECT valor FROM produto WHERE codigo = fk_produto_n), fk_orcamento_venda_n, fk_produto_n);
				SELECT "Detalhes do produto inserido no orçamento de venda com sucesso!";
                COMMIT;
			ELSE
				SELECT "Produto sem estoque!";
                ROLLBACK;
            END IF;
		ELSE
			IF (!((SELECT COUNT(*) FROM orcamento_venda WHERE codigo = fk_orcamento_venda_n AND fk_status <> 5) > 0)) THEN
				SELECT "Orçamento de venda não encontrando!";
                ROLLBACK;
			END IF;
			IF (!((SELECT COUNT(*) FROM produto WHERE codigo = fk_produto_n) > 0)) THEN
				SELECT "Produto não encontrado!";
                ROLLBACK;
			END IF;
		END IF;
END //
DELIMITER ;

CALL atualizarProduto (10, 'Ração NutriPet', 0, 18.70, 'Ração à base de milho para aves e suínos, formulada para oferecer nutrientes essenciais e melhorar o desempenho dos animais.', 10);
CALL inserirDetalhesProduto (10, 21, 10);

-- TRIGGER QUE ATENDE A REGRA DE NEGÓCIO RN-001 - ATUALIZAÇÃO AUTOMÁTICA DE ESTOQUE
DELIMITER //
CREATE TRIGGER atualizaEstoqueProducao AFTER INSERT ON producao
FOR EACH ROW
BEGIN
    UPDATE produto
    SET quantidade_total = quantidade_total + NEW.quantidade
    WHERE codigo = NEW.fk_produto;
END //
DELIMITER ;