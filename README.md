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

### função MAIN:###
**É onde realizamos todo o projeto do cadeado de fato, toda a parte de interação como usuário e comparação do que ele digitou com o que está guardado na memória é feita aqui.**

Assim que o código entra nessa função, seu começo é responsável por organizar o que acontece:

-em primeiro lugar chama a função lcd_init para inicializar o display LCD, tornando possível a escrita nele
-chama a função TELA_INICIAL para escrever no display LCD a primeira tela do projeto 
-adiciona no contador A o valor específico para que a escrita no display para que o texto fique centralizado
-chama a função posicionaCursor para que, a senha digitada pelo usuário ocupe a posição guardada no registrador A, afinal o posicionaCursor utiliza esse acumulador. Dessa forma, o número digitado aparecerá no lugar dos “_ _ _ _” no display LCD
