# Teacher Helper

Um programa para Android e iOS, desenvolvido em Flutter e que ajuda professores durante as aulas.

## Contexto

Durante a pandemia, muitos professores tiveram que buscar mais familiaridade com os recursos digitais. Além disso, as redes sociais propiciaram o contato entre os docentes, aumentando a troca de experiências pedagócias e a troca de objetos pedagógicos. 

Todo professor, antes de uma aula, deveria ter o seu *Plano de Aula*. Um plano de aula bem feito, eleva a qualidade de qualquer aula. Nesse contexto de professores mais familiarizados com os recursos digitais, muitos professores têm buscado por atividades e planos de aula desenvolvidos por colegas professores.

A nossa proposta principal, é criar um aplicativo onde professores podem fazer o gerenciamento de suas turmas e criar, pesquisar e compartilhar planos de aulas. 

# Backlog (Recursos que o Teacher Helper deve ter)

- Turmas: Um sistema para cadastrar as turmas, horários e locais que o professor irá atuar;
- Calendário: Calendário com os horários de aula do professor, eventos escolares e a possibilidade de vincular um plano de aula a uma data e turma específica;
    - Calendário (extra): Integrar ao Google Calendar.
- Busca: Um sistema de pesquisa onde o professor pode encontrar planos de aula criados por outros professores;
    - Busca por disciplinas (Física, Química etc);
    - Busca por objetivos pedagógicos (Leis de Newton, Equação do Segundo Grau etc);
    - Busca por tipo de metodologias (Peer Instruction, Sala de Aula Invertida etc);
- Planos de Aula: Um sistema onde o professor pode criar seu plano de aula, atribuir a uma data e turma, torná-lo público para outros professores;
    - Guia de como criar um plano de aula;
    - Duração da aula calculado automáticamente;
    - Compartilhamento: Deixar público para outros usuários e compartilhar com colega para editar ou só visualizar/copiar;
    - Gerenciador de objetivos de aprendizagem: Você cria uma lista de objetivos que podem ser aproveitados em outros planos;
    - Campos da turma podem ser puxados automaticamente das suas turmas;
    - Os planos de aula públicos podem receber comentários de outros professores. Assim, podem discutir e melhorar seus planos de aulas.
    - Gerar um DOCX com o plano pronto.

- Atividades e Recursos extras: É comum que dentro do plano de aula haja atividades especiais que exijam mais detalhamentos e recursos (textos, vídeos etc), aqui o professor irá registrar essas atividades e recursos.

- Play: Um sistema de cronômetro que mostra para o professor cada momento de sua aula e um cronômetro para que ele possa se orientar.

## Primeira Entrega

- Página Inicial;
- Turmas; 
    - Visualizar Lista de Turmas;
    - Criar e Editar as Turmas;
- Calendário;

Vídeo com o resultado da primeira entrega está no [YouTube](https://www.youtube.com/watch?v=N5IGxV1wZVE).

## Segunda Entrega
- Planos de Aula;
    - Visualizar Lista de Planos de Aulas;
    - Criar, Duplicar e Editar os Planos de Aula;
    - Gerar um Docx com o plano de aula;
- Buscar Planos de Aulas de outros usuários;
- Play - Um cronômetro para as atividades de um plano;

Vídeo com o resultado da segunda entrega está no [YouTube](https://youtu.be/O0XgPGKAkVc).



# Resultado do que foi entregue

- Turmas: Um sistema para cadastrar as turmas, horários e locais que o professor irá atuar;
- Calendário: Calendário com os horários de aula do professor, eventos escolares e a possibilidade de vincular um plano de aula a uma data e turma específica;
    - ~~Calendário (extra): Integrar ao Google Calendar~~.
- Busca: Um sistema de pesquisa onde o professor pode encontrar planos de aula criados por outros professores;
    - Busca por disciplinas (Física, Química etc);
    - ~~Busca por objetivos pedagógicos (Leis de Newton, Equação do Segundo Grau etc)~~;
    - ~~Busca por tipo de metodologias (Peer Instruction, Sala de Aula Invertida etc)~~;
- Planos de Aula: Um sistema onde o professor pode criar seu plano de aula, atribuir a uma data e turma, torná-lo público para outros professores;
    - ~~Guia de como criar um plano de aula;~~
    - Duração da aula calculado automáticamente;
    - Compartilhamento: Deixar público para outros usuários e compartilhar com colega para editar ou só visualizar/copiar;
    - ~~Gerenciador de objetivos de aprendizagem: Você cria uma lista de objetivos que podem ser aproveitados em outros planos~~;
    - ~~Campos da turma podem ser puxados automaticamente das suas turmas;~~
    - ~~Os planos de aula públicos podem receber comentários de outros professores. Assim, podem discutir e melhorar seus planos de aulas;~~
    - Gerar um DOCX com o plano pronto.

- ~~Atividades e Recursos extras: É comum que dentro do plano de aula haja atividades especiais que exijam mais detalhamentos e recursos (textos, vídeos etc), aqui o professor irá registrar essas atividades e recursos.~~

- Play: Um sistema de cronômetro que mostra para o professor cada momento de sua aula e um cronômetro para que ele possa se orientar.




# Metodologia de Desenvolvimento

O programa vai utilizar uma arquitetura MVC (Model-View-Controller).

Estamos usando o princípio do [algoritmo guloso](https://pt.wikipedia.org/wiki/Algoritmo_guloso) para desenvolvimento do aplicativo. A cada ciclo de densenvolvimento, cada membro fica responsável por fazer uma tela do programa (definida de acordo com afinidade, dificuldade e nível do desenvolvedor). Entendemos por tela o processo de desenvolver a View (tela propriamente dita), a model das entidades apresentadas na view e o controller para as entidades que demandam armazenamento. Ao final de cada ciclo, a equipe se reune para criar os adaptadores quando uma tela precisar se comunicar com outra tela.

O tempo, separação e tarefas dos membros da equipe não permite que utilizemos nada que envolva metodologia Ágil ou mesmo o Scrum.





# Desenvolvedores
- Daniel Girardi (git:@danielfsc)
- Pedro Assumpção Xavier
- Thomas Repsold Pessoa