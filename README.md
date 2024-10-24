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

![codigo1](./imagensReadMe/img1.png) Imagem 1. <br>

![codigo1](./imagensReadMe/img2.png) Imagem 2. <br>

![codigo1](./imagensReadMe/img3.png) Imagem 3. <br>
![codigo1](./imagensReadMe/img4.png) Imagem 4. <br>

