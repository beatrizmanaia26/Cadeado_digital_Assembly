# Projeto de cadeado digital em Assembly

## Introdução: 
O projeto, desenvolvido em Assembly com execução no EdSim51DI, consiste em um cadeado digital, que, a princípio está bloqueado, aparecendo “_ _ _ _ Bloqueado“ no display LCD. Então, o usuário deve acertar a senha de fábrica, que tem 4 dígitos, a digitando no KeyPad para desbloquear o cadeado. Caso o usuário erre a senha e pressione  “#”  no KeyPad para enviá-la, aparece uma mensagem de “XXXX senha incorreta”.

Ao passo que o usuário digita a senha correta e a envia, o motor do EdSim51DI gira no sentido anti-horário, simbolizando a abertura do cadeado, e aparece no display LCD um menu com duas opções: “1” corresponde à mudança da senha para outra que contenha 4 dígitos, e “2” para sair do programa. Caso a opção escolhida seja “2”, o motor gira o sentido horário, simbolizando o trancamento do cadeado. Assim que o motor para de girar, aparece um “tchau =)”, todavia, se o usuário clicar em “1” no Keypad, aparece no display LCD um espaço para ele digitar a “nova senha” de 4 dígitos e, somente após enviá-la, essa nova senha sobrescreve a senha de fábrica no espaço de memória do EdSim51DI, em seguida, aparece uma mensagem de “senha salva”, após isso, o menu é exibido novamente, até que a pessoa escolha “sair”.

## Desenvolvimento:
**Aqui está uma explicação sobre a organização do código e o que cada parte dele é responsável por fazer.**

Nesse trecho inicial do código ocorre a definição de nomes simbólicos para pinos específicos, e informa onde é o início do código do programa.

![codigo1](./imagensReadMe/c1.png)

Nesta parte, inserimos os valores que estão após o “#” nos endereços da memória de dados do EdSim51DI especificados antes do “H”. Assim, dos endereços 30h ao 33h estarão os valores “1111”, que correspondem a senha considerada “de fábrica”, ou seja, é essa senha que o usuário deve digitar para desbloquear o cadeado. 

Já nos endereços do 40H ao 4BH foram inseridos os valores do KeyPad, que serão utilizados para comparar com o que o usuário digitou e validar o que ele pressionou no teclado.

![codigo1](./imagensReadMe/c2.png)

Aqui criamos “labels” referentes a todos os textos que desejamos escrever no display LCD durante o projeto.

![codigo1](./imagensReadMe/c3.png)

### função MAIN: **É onde realizamos todo o projeto do cadeado de fato, toda a parte de interação como usuário e comparação do que ele digitou com o que está guardado na memória é feita aqui.**

Assim que o código entra nessa função, seu começo é responsável por organizar o que acontece:

-Em primeiro lugar chama a função lcd_init para inicializar o display LCD, tornando possível a escrita nele; <br>
-Chama a função TELA_INICIAL para escrever no display LCD a primeira tela do projeto; <br>
-Adiciona no contador A o valor específico para que a escrita no display para que o texto fique centralizado; <br>
-Chama a função posicionaCursor para que, a senha digitada pelo usuário ocupe a posição guardada no registrador A, afinal o posicionaCursor utiliza esse acumulador. Dessa forma, o número digitado aparecerá no lugar dos “_ _ _ _” no display LCD;

![codigo1](./imagensReadMe/c_main1.png)

**Essa parte do código serve para escrever a senha digitada pelo usuário na memória, a partir do endereço 60H, escrevendo apenas 4 valores na memória e no display**

-Coloco o endereço 60h no registrador R1, pois esse é onde começamos a guardar a senha digitada pelo usuário antes dele apertar o enter (#); <br>
-Movemos 4 para o registrador 3, essa linha de código funciona como um loop de 4 repetições para que peguemos todos os 4 valores digitados pelo usuário; <br>

###  função ESPERA_VE_PRESSIONADO: é responsável por esperar até que o usuário clique em alguma tecla e guarde esse valor no registrador R0, também realiza contas para que o valor que aparece no display seja exatamente o que ele pressionou 

-Entra na função ESPERA_VE_PRESSIONADO <br>
-Chama a função leituraTeclado, para ler o que o usuário pressionou no KeyPad e armazenar no  endereço 60, afinal no display está a tela inicial, induzindo o usuário a digitar uma senha de 4 dígitos que deverá ser lida por essa linha;
-JNB faz com que só saia desse “loop” da função ESPERA_VE_PRESSIONADO: até a linha do JNB quando o usuário clicar em alguma tecla;
-(do “ESPERA_VE_PRESSIONADO: até o MOV A, @R0 fazemos a movimentação de valores para guardar o valor referente a tecla que o usuário clicou. Inicialmente, o valor que a pessoa clicou está em R0 então passamos desse registrador para A e de A para esse registrador, para que, no final, o acumulador tenha o valor que precisamos para prosseguir);
-(no trecho do MOV R7, A até  MOV A, R7, prosseguimos o código realizando contas para que, ao final desse trecho, o acumulador contenha exatamente o valor que a pessoa clicou no teclado);
-Chamamos a função sendCharacter para que ela envie ao display o valor que a pessoa digitou no teclado, calculado nas contas acima;
-É importante limpar o F0 para não dar problema, afinal, nessa parte do código  ele está sendo usado para verificar se alguma tecla foi pressionada;
-Por fim, utilizamos o DJNZ para fechar a lógica do loop mencionado acima, ele decrementa a quantidade de iterações, fazendo com que o bloco de código responsável por pegar o valor que o usuário digitou no teclado e fazer com que ele apareça no display ocorra para os 4 dígitos da senha;

![codigo1](./imagensReadMe/c_main2.png)

###  função  ESPERA_VE_PRESSIONADO_ENTER:  espera o usuário digitar # para somente prosseguir o código após essa tecla ser clicada

-Movemos o valor referente ao enter (#) para o R3; <br>
-Criamos a função ESPERA_VE_PRESSIONADO_ENTER: (até o DJNZ) para que o código fique esperando e só continue a executar as instruções após o usuário clicar no “#”; <br>
-Essa função, em primeiro lugar, limpa o acumulador A, afinal utilizaremos ele novamente; <br>
-chamamos leituraTeclado para ver se o usuário pressionou alguma tecla; <br>
-Assim como a função “ESPERA_VE_PRESSIONADO”, a função “ESPERA_VE_PRESSIONADO_ENTER”, desde seu nome até o JNB fica esperando o usuário digitar algo e só vai para o código abaixo do da linha que está o JNB quando a pessoa clicar em alguma tecla; <br>
-No trecho de MOV A, #40H até MOV A, @R0 ocorre a mesma movimentação de valores que mencionei na descrição da função ESPERA_VE_PRESSIONADO, fazendo com que, no final o valor pressionado esteja no A;
-Limpamos o F0; <br>
-Comparamos para ver se a tecla pressionada pelo usuário é a tecla referente ao #, se não for, a Instrução CJNE faz  com que volte a função ESPERA_VE_PRESSIONADO_ENTER, só saindo dela e prosseguindo o código quando usuário clicar no #; <br>

![codigo1](./imagensReadMe/c_main3.png)

Ao passo que o usuário clicou no #, ocorre a verificação da senha 

### Função COMPARA: é responsável por validar se a senha que ele digitou é a mesma senha que está guardada nos endereços a partir do 30H

-Movemos o valor 4 para o R3 para fazer um loop de 4 repetições; <br>
-Movemos para R0 o valor 30H pois é nesse endereço que está armazenada a senha padrão que desejamos comparar com o que o usuário digitou previamente;  <br>
-Movemos para o R1 o valor 60H pois é a partir desse endereço que armazenamos os 4 dígitos da senha que o usuário pressionou no KeyPad;  <br>
-Entra na função compara;  <br>
-Movemos para o acumulador A  o endereço do valor guardado no R0;  <br>
-Movemos para 70h o endereço do valor guardado no R1;  <br>
-Usamos o CJNE para comparar os valores que estão no A (início da senha padrão) com os valores que estão no 70H, caso seja diferente ele vai para a função ERRADO;  <br>
-Caso os valores sejam iguais o código incrementa R1;  <br>
-E incrementa R0,para prosseguir verificando a senha;  <br>
-Decrementa R3 e vai para a função compara para verificar os valores das senhas nos outros endereços de RO e R1; <br>

![codigo1](./imagensReadMe/c_main4.png)

Caso toda a senha digitada pelo usuário esteja correta, fazemos o motor girar e entramos na função MENU:

### função MENU: é responsável mostrar ao usuário suas opções de ação e executar essas opções




![codigo1](./imagensReadMe/c_main5.png)
 

**No final do código tem todas as funções que chamamos durante o projeto. As primeiras funções são relacionadas as telas do display, ou seja, chamamos elas quando desejamos escrever no display após algo acontecer.**

### função TELA_SENHASALVA: 

-Chama a função responsável por limpar o display, ou seja, apagar tudo que está escrito nele; <br>
-Posiciona o cursor no lugar onde desejamos escrever a label que chamaremos; <br>
-Chama a função responsável por posicionar o cursor na posição desejada, mencionada acima; <br>
-Move a label #SENHASALVA para o registrador DPTR para escrevê-la no display; <br>
-Chama a função responsável por escrever a string da label #SENHASALVA; <br>
-Limpa o display e retornamos; <br>

![codigo1](./imagensReadMe/c5.png)

### funções de tela “TELA_MUDARSENHA”, “TELA_INICIAL”, “TELA_ERRO”: 

seguem a mesma lógica da função “TELA_SENHASALVA”, só muda a quantidade de texto que desejamos escrever no display

![codigo1](./imagensReadMe/c6.png)

### função TELA_MENU: **tem a mesma lógica que as demais telas, porém nela há um código responsável por esperar para saber se o motor já fez uma rotação completa no sentido anti-horário, rotação essa que ocorre quando a pessoa acerta a senha, antes de aparecer o menu no display LCD.**

Após limpar o display, o código verifica se houve uma rotação completa para, somente após isso, aparecer o menu no display. O código que verifica a rotação também é responsável por finalizá-la caso ela já tenha sido realizada em uma volta.

![codigo1](./imagensReadMe/c7.png)

### função leituraTeclado: **é responsável por fazer uma varredura matricial, ela escaneia as linhas do KeyPad para identificar qual tecla foi pressionada.**

![codigo1](./imagensReadMe/c8.png)

### função finish: e finish2: **são somente um retorno**

![codigo1](./imagensReadMe/c9_1.png) ![codigo1](./imagensReadMe/c9_2.png)

### função colScan: faz a varredura das colunas de um teclado matricial para detectar se alguma tecla foi pressionada.

![codigo1](./imagensReadMe/c10_1.png)

### função escreveStringROM: escreve no display, a partir da posição alocada em A nas funções de tela, o texto desejado, letra por letra. 

![codigo1](./imagensReadMe/c10_2.png)

### função lcd_init: é responsável por inicializar o display LCD. Ela é necessária para que possamos escrever no display LCD 

![codigo1](./imagensReadMe/c11.png)
![codigo1](./imagensReadMe/c12.png)

### função sendCharacter: envia um caractere de 8 bits para um display LCD, ela é necessária para enviar cada um dos caracteres das palavras que desejamos escrever no display 

![codigo1](./imagensReadMe/c13.png)

### função clearDisplay: é responsável por limpar o display LCD por completo, ou seja, limpar todas as portas que ele usa.

![codigo1](./imagensReadMe/c14.png)

### função delay: é responsável por atrasar a execução, ela faz isso ao criar um loop com 50 iterações 

![codigo1](./imagensReadMe/c15.png)

## Funcionamento:
Para que o código dos commits funcione, é preciso utilizar o simulador de microcontrolador  8051 EdSim51DI (link para download fornecido na secção de referências). <br>
Após colar o código dos commits no EdSim51DI, configure o “Update Freq.” para 100 (como mostra a imagem 1), com essa frequência, o código roda em uma velocidade agradável. <br>
Ademais, dentro do EdSim51DI, utilizamos as ferramentas: Display LCD (imagem 2), motor (imagem 3) e KeyPad (imagem 4). <br>

![codigo1](./imagensReadMe/img1.png) <br> Imagem 1. 

![codigo1](./imagensReadMe/img2.png) <br> Imagem 2. 

![codigo1](./imagensReadMe/img3.png) <br> Imagem 3.
![codigo1](./imagensReadMe/img4.png) <br> Imagem 4. 

## Referências:

-Download do EdSim51DI: https://edsim51.com/ <br>
-Materiais de referência para o projeto foram fornecidos durante as aulas de arquitetura de computadores no Centro Universitário FEI. <br>

## Conclusão:

Em síntese, desenvolver o projeto no EdSim51DI e utilizar ferramentas como: keyPad, para captar a opção que o usuário escolheu do menu, bem como a senha de fábrica e a nova senha; Display LCD, para mostra-lo suas opções e resultado de suas ações, como senha correta/incorreta e senha salva; e o motor, para simular a abertura e o fechamento do cadeado, foi muito agregador e interessante para trazer uma melhor experiência ao usuário. Fez com que conseguíssemos desenvolver melhor nossos conhecimentos em Assembly, assim como desenvolver nossa capacidade de organizar e documentar um código durante sua realização. 
O único desafio encontrado foi solucionar um problema que, no display LCD aparecia muito texto randômico. Isso acontecia devido ao fato de termos salvo muitos textos ao ponto deles ocuparem o espaço em que a main está alocada. <br>

## Fluxograma:


## Simulação: 
  [Assistir vídeo sobre o projeto](https://www.youtube.com/watch?v=8Y3Y5MJiHyA&t=4s)

