# Tasks: {titulo}

> Spec: [spec.md](./spec.md) · Issue: PROJ-XXXX

## Plano de execução

### Fases

> Com **≥ 5 tasks**, fases são obrigatórias. Execute com `/sdd-06-execute` informando a fase (ex.: `Fase 1`).

| Fase | Tasks | Depende de | Paralelo? | Modo execução |
|------|-------|------------|-----------|---------------|
| 1 | T01, T02 | — | sim | `parallel-execution` ou `/sdd-06-execute` sequencial |
| 2 | T03 | Fase 1 | — | `/sdd-06-execute` |

> **Paralelo? = sim** só se as colunas **Onde** forem disjuntas (sem overlap de arquivos).

### Feature flag

| Propriedade | Default | Task |
|-------------|---------|------|
| `{flag}.enabled` | `false` | T0X |

Ou: **N/A** — {justificativa}. Padrão de flags: ver [`AGENTS.md`](../../AGENTS.md).

### Impactos (resumo)

| Mudança | Intencional | Risco não intencional |
|---------|-------------|----------------------|
| | | |

### Grafo de dependências

```
T01 ──┬──> T03
T02 ──┘
```

---

## T01: {título}

| Campo | Valor |
|-------|-------|
| **Entregável** | O que existe ao final (arquivo, endpoint, teste) |
| **Onde** | Paths exatos (ex.: `src/.../FooService.<ext>`) |
| **Depende de** | — / T0X |
| **Bloqueia** | T0Y |
| **Paralelo com** | T02 (∥) — só se **Onde** disjunto |
| **Requisitos** | RF/US da spec |

### Context pack

> Executor sem histórico do chat deve conseguir implementar só com esta seção + Steps.

- **Spec:** [spec.md](./spec.md) §2 goal …, US-…
- **Restrições:** {copiar bullets relevantes de §2 + AGENTS.md se aplicável}
- **Padrão do repo:** {ex.: camada de entrada delega ao serviço; imitar `ExemploExistente`}
- **Arquivos vizinhos:** {1–2 exemplos existentes}
- **Não fazer:** {non-goals + fora do escopo desta task}

### O que será feito

- ...

### Steps

> Plano executável — steps de **2–10 min**. Sem TBD, "adicionar validação" ou "similar à T02" sem repetir código.

- [ ] **Step 1: Escrever teste que falha** (`tdd: true` ou N/A integração)

```
// trecho completo do teste — caminho exato do arquivo
```

- [ ] **Step 2: Rodar teste — confirmar FAIL**

```
# comando de teste único do projeto (ver AGENTS.md — Gate de qualidade)
```

Esperado: FAILURE — {motivo}

- [ ] **Step 3: Implementação mínima**

```
// trecho completo de produção — caminho exato do arquivo
```

- [ ] **Step 4: Rodar teste — confirmar PASS**

```
# comando de teste do projeto (ver AGENTS.md)
```

Esperado: SUCCESS, 0 falhas

- [ ] **Step 5: Gate iterativo da task**

Rodar lint/compile + testes + build (`AGENTS.md`); registrar em `executions.md` via skill `verification`.

### Definição de pronto (DoD)

- [ ] Steps concluídos
- [ ] Código + testes
- [ ] Gate iterativo verde (skill `verification` em `executions.md`)
- [ ] `/sdd-07-task-review` aprovado (Estágio 1 + Estágio 2)
- [ ] Sem shadow code (tudo rastreável na spec)
- [ ] Docs (passo 09) se impacto em API/contrato público

### Notas de execução

<!-- Preenchido em executions.md -->

---

## T02: ...

<!-- Repetir bloco por task -->
