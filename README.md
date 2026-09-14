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
| `city.toml` | Providers (OpenRouter through `opencode`, default model `z-ai/glm-5.3-flash`), rig, API bind |
| `pack.toml` | Pack imports: Gas City core and bd packs plus `pangenome-town` |
| `town.toml` | Town identity, samples served, peers, data paths, exchange log location |
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

## Cost control

Agents run only through OpenRouter. One townsfolk session at most, idle
timeout 20 minutes, GLM 5.3 Flash by default. `gc costs` reports usage.
