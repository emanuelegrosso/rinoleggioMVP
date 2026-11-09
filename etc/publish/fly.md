# Deploy su Fly.io (rinoleggioMVP)

App: **`rinoleggiomvp`** → https://rinoleggiomvp.fly.dev

## Un solo database

- File canonico in git: **`src/Rinoleggio.db`** (locale = Fly).
- Nessun volume SQLite, nessuno seed/entrypoint: il Dockerfile fa `COPY Rinoleggio.db` → `/app/Rinoleggio.db`.
- Production: `Data Source=/app/Rinoleggio.db;` in `appsettings.Production.json`.

Aggiornare Fly = committare `src/Rinoleggio.db` (solo il file principale, no wal/shm) + deploy.

## Fly.io + GitHub

| Impostazione | Valore |
|--------------|--------|
| **Root directory** | **`src`** |
| **Dockerfile** | `Dockerfile` (in `src/`) |

Deploy CLI:

```powershell
cd C:\EG\Rinoleggio\MVP\Rinoleggio4\Rinoleggio\src
fly deploy -a rinoleggiomvp
```

```powershell
fly scale count 1 -a rinoleggiomvp
```

## Verifica

```powershell
fly ssh console -a rinoleggiomvp -C "ls -la /app/Rinoleggio.db"
```

~800 KB. Log senza `AbpBackgroundJobs` / `unable to open database file`.

Opzionale: `fly secrets set App__HealthUiCheckUrl=http://127.0.0.1:8080/health-status -a rinoleggiomvp`

## Root repo

`fly.toml` e `Dockerfile` nella root del repo sono legacy (deploy da root non usato). Usare sempre **`src/`**.

## OpenIddict

Se login fallisce, aggiornare redirect in SQLite per `https://rinoleggiomvp.fly.dev`.
