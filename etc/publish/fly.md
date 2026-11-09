# Deploy su Fly.io (rinoleggioMVP)

App prevista: **`rinoleggiomvp`** → `https://rinoleggiomvp.fly.dev`

SQLite persiste su volume **`rinoleggio_data`** montato in `/data`. Al primo avvio, se `/data/Rinoleggio.db` non esiste, l’entrypoint copia il seed dall’immagine (`Rinoleggio.db` in repo).

## Primo setup (una tantum)

```powershell
cd C:\EG\Rinoleggio\MVP\Rinoleggio4\Rinoleggio
fly apps create rinoleggiomvp
fly volumes create rinoleggio_data --region ams --size 1 -a rinoleggiomvp
fly secrets set App__SelfUrl="https://rinoleggiomvp.fly.dev" AuthServer__Authority="https://rinoleggiomvp.fly.dev" -a rinoleggiomvp
fly deploy -a rinoleggiomvp
```

Se un deploy precedente ha lasciato un DB vuoto sul volume:

```powershell
fly ssh console -a rinoleggiomvp -C "rm -f /data/Rinoleggio.db"
fly apps restart rinoleggiomvp
```

## Verifica

```powershell
fly ssh console -a rinoleggiomvp -C "ls -la /data/Rinoleggio.db"
fly logs -a rinoleggiomvp
```

Il file dovrebbe essere ~800 KB. Nei log non deve comparire `no such table: AbpBackgroundJobs`.

## OpenIddict

Se login/redirect falliscono, aggiornare gli URL client nel SQLite (`OpenIddictApplications`) per puntare a `https://rinoleggiomvp.fly.dev` (vedi script SQL di esempio nel vecchio repo o eseguire aggiornamento via DbMigrator/SQL su volume).
