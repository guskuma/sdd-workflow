# plan_depth

Ler e seguir **antes** de escrever Steps. Registrar no topo de `tasks.md` / §5 quando o formato completo se aplica (`feat`, `refactor`, `perf`, `fix` com mais de 1 arquivo).

| Campo | Valor |
|-------|-------|
| **plan_depth** | `snippets` \| `contracts` |
| **Critério** | {regra disparada — ver árvore} |
| **Override do dev?** | não \| sim (pedido explícito) |

## Árvore (primeira que casar vence)

1. **Override do dev** — se o dev pediu `snippets` ou `contracts` → usar esse valor; anotar “override do dev”.
2. **`contracts`** se **qualquer** um for verdadeiro após o Mapa de arquivos / spec:
   - **Maioria criar:** paths com Ação `criar` ≥ 50% do mapa **ou** ≥ **8** paths `criar`;
   - **Sistema / subsistema novo:** Escopo da entrega ou goals descrevem bootstrap de sistema/serviço novo **e** existe (ou será criado) `design.md`;
   - **Fase só de scaffold:** a fase corrente é bootstrap/skeleton/scaffolding sem fatia vertical de negócio ainda.
3. Caso contrário → **`snippets`** (default).

## Mix por fase ou task

- Greenfield típico: **Fase 1** `contracts` (scaffold + Interfaces + 1 thin slice com teste completo); fases seguintes de fatia vertical → **`snippets`**.
- Override por task: campo **Profundidade** na tabela da task (vence o default **só** naquela task).
- Fase mista: declarar `plan_depth` da fase na tabela de Fases ou no Critério.

## O que cada modo exige nos Steps

| Modo | Step de código / produção | Step de verificação | Ainda obrigatório |
|------|---------------------------|---------------------|-------------------|
| **`snippets`** | Snippet **completo** (corpo) | Comando + output esperado (FAIL/PASS) | Interfaces; paths exatos; bite-size |
| **`contracts`** | Assinaturas / esqueleto alinhado a **Produces** + regras em bullets. Corpo completo **só** se couber em 2–5 min. | Teste **completo** que trava o comportamento **ou** comando de scaffold com output esperado | Interfaces ricas; Mapa; Constraints; bite-size |

**Thin slice:** a task do primeiro caminho feliz de negócio tem teste completo. Se a implementação mínima couber em 2–5 min, o Step traz o corpo. Senão, a única prosa permitida é a frase abaixo.

## Frase permitida em `contracts`

Quando o corpo não cabe em 2–5 min, o Step de produção usa **esta frase e nenhuma outra**, com os três campos preenchidos (valor real, não `{...}`):

`Corpo mínimo que faça o teste {caminho-do-teste} falhar na asserção "{texto}" e depois passar, respeitando Produces {assinaturas}.`

Proibido no lugar dela: “implementar o módulo”, “implementar FooService”, “adicionar validação”, “similar à T0X”, TBD, TODO.

## Ambíguo

Mapa no limiar (45–55% criar) ou escopo híbrido → **perguntar ao dev** uma vez: "`plan_depth`: snippets ou contracts?" Não assumir.
