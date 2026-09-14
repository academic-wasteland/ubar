# Ubar (أوبار)

A pangenome town in [The Academic Wasteland](https://github.com/academic-wasteland/research-commons):
a [Gas City](https://github.com/gastownhall/gascity) city that holds the
Saudi Arabian (KSA) samples ksa001 to ksa009 of the JaSaPaGe pangenome
(Kulmanov et al. 2025, *Scientific Data* 12:1316,
[doi:10.1038/s41597-025-05652-y](https://doi.org/10.1038/s41597-025-05652-y))
and answers questions from its peer town [Yamatai](https://github.com/academic-wasteland/yamatai).

All logic lives in the shared pack
[pangenome-town](https://github.com/academic-wasteland/pangenome-town). This
repository is only the city configuration.

## Files

| File | Purpose |
|---|---|
| `city.toml` | Providers (`glm`: OpenRouter GLM 5.3 Flash through `opencode`; `qwen`: local vLLM Qwen3.8 27B on unimatrix01), rig, API bind |
| `pack.toml` | Pack imports: Gas City core and bd packs plus `pangenome-town` |
| `town.toml` | Town identity, samples served, peers, data paths, exchange log location |
| `agents/sam/` | City-scoped resident **Sam** on the lab's local Qwen (vLLM on unimatrix01); chats with humans by mail and session |
| `contract/` | This town's rendered semantic contract (`pangenome-town rcp render-contract`) |
| `scripts/bootstrap.sh` | One-time setup on a fresh checkout |
| `rig/` (ignored) | Working directory of the townsfolk agent |

## Run

Prerequisites: `gc` 1.4.x, `dolt` >= 2.1, `bd`, `tmux`, `vg`, `bcftools`,
`opencode`, the `pangenome-town` CLI (`uv tool install --editable ../pangenome-town`),
`OPENROUTER_API_KEY` in `~/.gc/secrets.env` (with `GC_SUPERVISOR_ENV=OPENROUTER_API_KEY`),
and the JaSaPaGe files in `../data/jasapage/` (`../pangenome-town/scripts/fetch-data.sh`).

```bash
scripts/bootstrap.sh          # registers the rig, runs gc doctor
gc start                      # city under the supervisor (127.0.0.1:8372)
gc town status                # town info + doctor
gc town send --to yamatai --text "How many of your samples carry variants here?" --region GRCh38:chr6:29940000-29950000
pangenome-town messages       # exchange log
```

The envoy service is reachable through the supervisor at
`http://127.0.0.1:8372/v0/city/ubar/svc/envoy/` (loopback only; never expose
the supervisor port without a reverse proxy).

## Talking to the residents

```bash
gc mail send ubar-rig/pangenome-town.townsfolk -s "Question" -m "..." --notify   # the townsfolk agent (GLM)
gc session new sam --alias sam                        # chat with Sam (local Qwen), tmux attach
gc mail send <session-id> -s "Hello" -m "..." --notify        # or mail a running session; replies land in `gc mail inbox`
gc sling ubar-rig/pangenome-town.townsfolk "Summarise the LCT region for KSA samples"
```

Add another resident with `gc agent add --name <name>` (city-scoped; pick
`provider = "glm"` or `"qwen"` in its `agent.toml`), then `gc reload`.

## Research standards

```bash
pangenome-town rcp render-contract                     # after changing the template in the pack
pangenome-town rcp submit --to yamatai --kind variants --region GRCh38:chr6:29940000-29950000
pangenome-town rcp submit --to yamatai --kind compare --region GRCh38:chr2:135800000-135900000   # needs reputation
pangenome-town commons init && pangenome-town commons score
```

Reputation comes from the Wasteland commons (`wl create academic-wasteland/commons
--local-only`, shared by both towns on this workstation); `[rcp]` in `town.toml`
sets the threshold. The pack README explains the contract and the pipeline.

## Cost control

Agents run only through OpenRouter (GLM 5.3 Flash) or the lab's own vLLM
(Qwen, no per-token cost); never a Claude subscription. One townsfolk session
at most, idle timeout 20 minutes. `gc costs` reports usage. `VLLM_API_KEY`
joins `OPENROUTER_API_KEY` in `~/.gc/secrets.env`, opted in at install time
with `GC_SUPERVISOR_ENV=VLLM_API_KEY gc supervisor install`.
