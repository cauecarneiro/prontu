# DailyScheduleCanvas — Especificação Conceitual de Design
## Aplicativo de Agendamento para Profissionais de Saúde

**Versão:** 1.0  
**Data:** Abril 2026  
**Escopo:** ContentList + TimeLine — Comportamentos, Interações e Limites

---

## Visão Geral

A DailyScheduleView é o coração operacional do aplicativo. É a tela que o profissional de saúde abre dezenas de vezes ao dia — antes de cada sessão, entre atendimentos, ao fim do turno. Toda decisão de composição desse canvas parte de uma premissa única: o usuário está sempre em contexto de tempo real, entre um compromisso e outro, com atenção dividida.

O canvas não é um documento de consulta. É um espaço temporal vivo.

Essa distinção determina tudo: a estrutura do espaço renderizado, os elementos que habitam esse espaço, como eles se comportam passivamente ao longo do tempo, e como o app posiciona o usuário dentro desse espaço no momento em que ele abre a tela.

---

## Arquitetura do Canvas

### Working Window — O Espaço Renderizado

O canvas não renderiza as 24 horas do dia. Renderiza uma **janela de trabalho ativa**, calculada dinamicamente a partir dos compromissos do dia e do momento atual.

A Working Window tem quatro regras de composição:

- **Limite superior:** o início do primeiro compromisso do dia, recuado em 60 minutos de padding. Se o horário atual for anterior a esse limite, o limite superior recua para acomodar o horário atual com o mesmo padding.
- **Limite inferior:** o fim do último compromisso do dia, avançado em 60 minutos de padding. Se o horário atual ultrapassar esse limite — por exemplo, o profissional abre o app após o último atendimento — o limite inferior expande para acomodar o horário atual.
- **Dia sem compromissos:** a Working Window é centrada no horário atual, exibindo uma janela fixa de referência (por exemplo, 4 horas ao redor do momento presente), garantindo que a CurrentTimeNeedle sempre tenha um canvas para habitar.
- **Invariante absoluto:** o horário atual (`currentTime`) está sempre dentro dos limites renderizados. Sem exceções.

Essa abordagem resolve o problema fundamental do canvas estático de 24 horas: a maior parte do scroll seria espaço morto sem contexto temporal relevante. A Working Window garante que cada pixel de altura do canvas carrega informação útil.

### Escala Vertical

A proporção entre tempo e espaço no eixo vertical define a leitura de duração e proximidade. Uma escala muito comprimida torna cards de longa duração indistinguíveis de cards curtos; uma escala muito expandida força scroll excessivo para ver o dia completo.

A escala deve ser **fixa e consistente** em todo o canvas — não adaptativa por card. A consistência é o que permite ao usuário desenvolver intuição espacial sobre o dia: um card de 30 minutos sempre ocupa metade do espaço de um card de 60 minutos. Essa proporcionalidade é a gramática visual do canvas.

O valor específico da escala (pontos por minuto) é uma decisão de implementação, mas deve ser testado para que uma jornada típica de 8 horas caiba em 2 a 3 telas de scroll — suficiente para exigir navegação, mas não tanto que o dia pareça interminável.

---

## Elementos de Composição

O canvas é composto por quatro camadas de elementos, cada uma com uma função distinta e não intercambiável.

### 1. Anchor TimeMarks

As Anchor TimeMarks são marcas de hora cheia distribuídas ao longo do canvas dentro da Working Window. Sua função é fornecer **ritmo métrico ao espaço** — pontos de referência fixos que permitem ao usuário localizar qualquer posição no canvas sem depender exclusivamente dos cards.

**Comportamento:**
- Aparecem a cada hora cheia dentro dos limites da Working Window.
- São elementos visuais passivos: linha horizontal leve e label de hora à esquerda.
- Não reagem a eventos, não mudam de estado, não interagem com cards.
- Quando uma hora cheia coincide com o início ou fim de um ScheduleCard, a TimeMark não é suprimida — ela coexiste com o card, ancorada na mesma posição vertical.

**Limites:**
- Não aparecem fora da Working Window, mesmo que o usuário faça scroll além dos limites (o canvas não renderiza além deles).
- A hora da CurrentTimeNeedle não ganha um Anchor TimeMark especial — a diferenciação do momento atual é responsabilidade exclusiva da Needle, evitando redundância visual.

**Por quê:** Sem Anchor TimeMarks, um gap de 3 horas entre dois cards é visualmente indistinguível de um gap de 30 minutos — apenas maior. As marks transformam o espaço em tempo legível. O usuário não precisa calcular: ele vê.

### 2. ScheduleCards

Os ScheduleCards são os blocos de conteúdo do canvas. Cada card representa um compromisso agendado ou um bloqueio de horário. São o único elemento do canvas com conteúdo editável e interativo.

**Composição visual:**
- Posição vertical determinada pelo horário de início do compromisso.
- Altura proporcional à duração — a proporcionalidade é inegociável para preservar a gramática visual do canvas.
- Contêm: horário de início, duração, nome do paciente/cliente, e uma linha de informação secundária (tipo de atendimento, observação rápida, ou indicador de recurso adicional).
- Bloqueios de horário (compromissos pessoais, pausas) têm tratamento visual diferenciado — fundo neutro, ícone de cadeado — mas seguem as mesmas regras de posição e altura.

**Estados visuais:**
- **Padrão:** card em estado neutro, compromisso futuro ou passado sem atividade corrente.
- **Ativo:** card que está sendo atravessado pela CurrentTimeNeedle no momento presente. Recebe tratamento visual elevado — borda de destaque, possível indicador de progresso interno, label de status visível.
- **Passado:** card cujo horário de fim já foi ultrapassado pela Needle. Pode receber tratamento visual atenuado (opacidade reduzida ou saturação rebaixada) para sinalizar que pertence ao histórico do dia, não ao futuro.

**Limites:**
- Um card nunca é truncado visualmente por uma Anchor TimeMark — as marks passam por baixo dos cards na hierarquia de camadas.
- Cards sobrepostos (conflito de horário, se existirem) não são tratados no canvas — conflitos são responsabilidade da lógica de agendamento, não do canvas de visualização.

**Por quê:** A proporcionalidade de altura é o que permite ao profissional, com um olhar rápido, avaliar a densidade e a respiração do seu dia. Um bloco grande significa uma sessão longa. Um espaço branco entre dois cards significa tempo livre. O canvas comunica isso sem palavras.

### 3. CurrentTimeNeedle

A CurrentTimeNeedle é o elemento que transforma o canvas de estático para vivo. É uma linha horizontal que percorre o canvas verticalmente, posicionada em tempo real na coordenada correspondente ao momento atual dentro da Working Window.

**Comportamento:**
- Posicionada em `currentTime` com base na escala vertical do canvas.
- Atualizada periodicamente (intervalo de atualização da ordem de minutos, não de segundos) — a progressão da Needle numa escala de horas é imperceptível a olho nu em intervalos curtos; atualizações muito frequentes consomem recursos sem benefício perceptível.
- Permanece visível durante todo o scroll do canvas — ela não é fixa na viewport, mas está ancorada no canvas. O usuário pode rolar para cima e para baixo e a Needle permanece na sua posição temporal correta.
- Composta por: uma linha horizontal de espessura fina, um indicador circular (dot) ancorado na margem do canal de TimeMarks, e opcionalmente um label de hora atual integrado ao dot.

**Relação com os ScheduleCards:**
- A Needle se posiciona na frente dos cards na hierarquia de camadas — ela os cruza visualmente quando está dentro de um.
- Quando a Needle está dentro de um ScheduleCard, esse card entra no estado **Ativo** (descrito acima). A Needle é o gatilho passivo dessa transição de estado.
- Quando a Needle está em espaço livre entre cards, o canvas exibe o gap como tempo disponível — sem estado especial.

**Limites:**
- A Needle nunca aparece fora dos limites da Working Window. A regra de que `currentTime` está sempre dentro da Working Window é o que garante isso — são contratos dependentes.
- Se o dia não tem compromissos, a Needle existe normalmente no canvas centrado no horário atual.
- A Needle não exibe contagem regressiva, não anima em direção ao próximo card, e não tem comportamento preditivo — ela é um indicador de presente, não de futuro. A função de proximidade é comunicada pela posição espacial relativa entre a Needle e o próximo card, não por um elemento adicional.

**Por quê:** A Needle resolve um problema cognitivo real. Sem ela, o usuário abre o canvas e vê uma lista de cards sem saber onde está. Com ela, a primeira informação que o olho processa é "estou aqui, o próximo compromisso está lá". A distância espacial entre a Needle e o próximo card comunica urgência de forma imediata, sem texto, sem notificação, sem cálculo.

---

## Funcionalidades Passivas

Funcionalidades passivas são comportamentos que o app executa automaticamente, sem ação explícita do usuário. Na DailyScheduleView, duas funcionalidades passivas formam a camada de inteligência contextual do canvas.

### Canvas Focus Management — Auto-Scroll Contextual

Ao abrir a DailyScheduleView, o app executa um posicionamento automático da viewport. O usuário não começa no topo do canvas (que seria o início da Working Window, potencialmente horas antes do momento atual) — ele começa exatamente onde a atenção deve estar.

**Comportamento:**

O scroll automático posiciona a viewport de acordo com o estado do dia:

- **Caso padrão — próximo compromisso no futuro:** a viewport é posicionada para que a CurrentTimeNeedle e o próximo ScheduleCard estejam visíveis simultaneamente. A Needle ocupa o terço superior da viewport; o próximo card está abaixo dela, visível ou parcialmente visível. O usuário vê simultaneamente "onde está o tempo agora" e "o que vem a seguir".

- **Caso ativo — Needle dentro de um card:** o app detecta que há uma sessão em andamento. A viewport é posicionada para que o card ativo esteja centralizado ou no terço superior, com a Needle visivelmente dentro dele. O usuário vê o estado atual da sessão imediatamente.

- **Caso tardio — Needle após todos os cards:** o dia de compromissos encerrou. A viewport posiciona a Needle visível no terço inferior, com o último card passado visível acima. O canvas comunica que o dia de atendimentos terminou.

- **Caso vazio — dia sem compromissos:** a viewport é posicionada para que a Needle esteja centralizada verticalmente, com contexto temporal visível acima e abaixo.

**Animação do scroll:**
O posicionamento automático usa uma animação suave, não um salto instantâneo. Isso preserva a orientação espacial do usuário — ele percebe que se moveu dentro de um espaço contínuo, não que foi teleportado para uma posição arbitrária.

**Limites:**
- O auto-scroll ocorre **apenas na abertura da tela**. Navegação manual posterior (troca de dia, retorno à aba) pode reacionar o comportamento, mas scroll manual do usuário dentro da tela não é interrompido ou corrigido pelo app.
- O auto-scroll não é uma âncora persistente — o usuário tem liberdade total de navegar pelo canvas após o posicionamento inicial.
- Em dias com muitos compromissos próximos uns dos outros, o posicionamento prioriza o estado mais urgente: um card ativo tem prioridade sobre o próximo card futuro.

**Por quê:** O auto-scroll resolve o problema de entrada sem restringir a liberdade de exploração. O profissional de saúde abre o app entre pacientes, com 2 minutos de atenção disponível. Começar exatamente onde a atenção precisa estar — sem scroll manual, sem leitura de contexto — é a diferença entre uma ferramenta que cabe na rotina e uma que exige adaptação.

### LiveStatus — Transição de Estado em Tempo Real

O LiveStatus é o comportamento passivo que mantém o canvas atualizado enquanto o app está em uso. Não é uma funcionalidade de notificação — é a manifestação visual do tempo passando dentro da tela.

**Comportamento:**

- A CurrentTimeNeedle se move ao longo do canvas conforme o tempo avança.
- Quando a Needle alcança o horário de início de um ScheduleCard, esse card transita automaticamente para o estado **Ativo** — sem interação do usuário.
- Quando a Needle ultrapassa o horário de fim de um ScheduleCard, esse card transita para o estado **Passado** — novamente, de forma automática.
- A Working Window se expande passivamente se o usuário mantiver o app aberto além do limite inferior original (por exemplo, numa sessão que atrasou o encerramento do dia).

**Limites:**
- As transições de estado dos cards são visuais, não funcionais — o LiveStatus não cria notificações, não envia alertas, não bloqueia interações. É exclusivamente uma camada de feedback visual passivo.
- O LiveStatus opera apenas com o app em primeiro plano. Background updates de posição da Needle são desnecessários — o Canvas Focus Management recalibra a posição ao retornar ao app.
- Não há animação de transição da Needle de posição para posição entre atualizações — ela simplesmente aparece na nova posição. Animações de "movimento" em intervalos de minutos seriam artificiais e potencialmente perturbadoras durante o uso.

**Por quê:** O LiveStatus fecha o contrato do canvas como espaço temporal vivo. Um canvas que não responde à passagem do tempo enquanto o usuário o olha quebra a metáfora — o "agora" estaria congelado. O profissional que deixa o app aberto durante uma sessão e olha para a tela deve ver a Needle avançar, o card se identificar como ativo, o tempo passando. Esse feedback passivo reduz a carga cognitiva: o app sabe que horas são, o profissional não precisa verificar.

---

## Sistema de Camadas — Hierarquia Visual

Os quatro elementos do canvas se organizam em camadas com precedência definida:

| Camada | Elemento | Posição na Hierarquia | Função |
|---|---|---|---|
| Base | Fundo do canvas + Working Window | Inferior | Espaço renderizado |
| Métrica | Anchor TimeMarks | Acima do fundo | Ritmo temporal |
| Conteúdo | ScheduleCards | Acima das TimeMarks | Compromissos e bloqueios |
| Cursor | CurrentTimeNeedle | Acima dos cards | Indicador de presente |
| Interface | Overlays, tooltips, ações contextuais | Superior | Interação do usuário |

A Needle estar acima dos cards é uma decisão deliberada: ela deve ser sempre legível, nunca obscurecida por um card, mesmo quando o cruza. Sua visibilidade é invariante — é o elemento mais importante do canvas em termos de informação de estado.

---

## Coerência do Sistema

Os quatro elementos — Working Window, Anchor TimeMarks, ScheduleCards, e CurrentTimeNeedle — não são features independentes. São partes de um sistema com contratos explícitos entre si:

- A **Working Window** garante que a Needle sempre tem espaço para existir e que as TimeMarks sempre têm contexto para fazer sentido.
- As **Anchor TimeMarks** tornam a proporcionalidade dos cards legível e o espaço entre a Needle e o próximo card interpretável em horas e minutos.
- Os **ScheduleCards** são o conteúdo que justifica a existência do canvas — tudo mais existe para contextualizar e iluminar esses cards.
- A **CurrentTimeNeedle** é o elemento que transforma a relação entre os outros três de estática para dinâmica — é ela que diz ao usuário onde, dentro desse sistema, o presente se localiza.
- O **Canvas Focus Management** e o **LiveStatus** são as camadas de inteligência que entregam esse sistema ao usuário já calibrado para o momento atual, sem esforço de orientação.

Remover qualquer um desses elementos degrada o sistema de forma não-linear. A Needle sem Working Window dinamicamente calculada pode sair dos limites do canvas. As TimeMarks sem proporcionalidade de cards perdem significado. Os cards sem Needle são uma lista, não um canvas temporal. O Canvas Focus Management sem Needle não tem um alvo de posicionamento preciso.

O sistema funciona como um todo ou não funciona completamente.

---

## Princípios Orientadores

**Orientação sem esforço.** O usuário nunca deve precisar calcular onde está no tempo. A posição relativa entre Needle, cards e TimeMarks comunica isso visualmente e instantaneamente.

**Passividade como virtude.** As funcionalidades passivas (auto-scroll, LiveStatus, transições de estado) operam sem solicitar atenção. Elas existem para reduzir carga cognitiva, não para criar novos pontos de interação.

**Proporção como linguagem.** A escala vertical consistente é a gramática do canvas. Quebrar a proporcionalidade para "caber" algum elemento é sempre o sinal de que o problema está sendo resolvido no lugar errado.

**O canvas é um espaço, não uma lista.** Listas têm items. Espaços têm posições. A DailyScheduleView é um espaço onde o tempo tem coordenadas e o usuário tem uma localização. Essa distinção deve guiar toda decisão de composição, interação e estado.

