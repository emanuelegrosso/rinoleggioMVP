# Deploy su Fly.io (rinoleggioMVP)

App: **`rinoleggiomvp`** → https://rinoleggiomvp.fly.dev

## Sorgente deploy (obbligatorio: root repo)

Build e `fly.toml` devono partire dalla **root** del repository (cartella con `Dockerfile`, `Rinoleggio.db`, `fly.toml`).

Su Fly.io → app **rinoleggiomvp** → **Settings** → collegamento GitHub:

| Impostazione | Valore |
|--------------|--------|
| **Root directory** | `.` (vuoto o root del repo, **non** `src`) |
| **Dockerfile** | `Dockerfile` (alla root) |

Deploy da CLI (equivalente):

```powershell
cd C:\EG\Rinoleggio\MVP\Rinoleggio4\Rinoleggio
fly deploy -a rinoleggiomvp
```

> `src/fly.toml` non va usato per il deploy: era solo per contesti `src/` senza seed DB. Usare il `fly.toml` in root.

SQLite su volume **`rinoleggio_data`** → `/data`. L’entrypoint copia il seed da `/app/seed/Rinoleggio.db` se il file sul volume manca o è vuoto.

## Setup volume (una tantum)

```powershell
fly scale count 1 -a rinoleggiomvp
fly volumes create rinoleggio_data --region ams --size 1 -a rinoleggiomvp
fly secrets set App__SelfUrl="https://rinoleggiomvp.fly.dev" AuthServer__Authority="https://rinoleggiomvp.fly.dev" -a rinoleggiomvp
```

## DB vuoto sul volume (0 byte)

Dopo un deploy da `src/` senza seed, cancellare e ridistribuire immagine root:

```powershell
fly ssh console -a rinoleggiomvp -C "rm -f /data/Rinoleggio.db /data/Rinoleggio.db-wal /data/Rinoleggio.db-shm"
fly deploy -a rinoleggiomvp
```

## Verifica

```powershell
fly ssh console -a rinoleggiomvp -C "ls -la /app/seed/Rinoleggio.db"
fly ssh console -a rinoleggiomvp -C "ls -la /data/Rinoleggio.db"
```

Entrambi ~800 KB. Health check interno (opzionale): secret `App__HealthUiCheckUrl=http://127.0.0.1:8080/health-status`.

## OpenIddict

Se login/redirect falliscono, aggiornare gli URL in `OpenIddictApplications` per `https://rinoleggiomvp.fly.dev`.
