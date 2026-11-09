# LEGACY (build context = repo root). Prefer src/Dockerfile with Fly root directory = src.

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
ARG OPENIDDICT_CERTIFICATE_PASSPHRASE=5df40b5d-7941-4720-b8b7-12580278f056

COPY . .

RUN dotnet dev-certs https -v -ep src/Rinoleggio.Web/openiddict.pfx -p "$OPENIDDICT_CERTIFICATE_PASSPHRASE"

RUN dotnet publish src/Rinoleggio.Web/Rinoleggio.Web.csproj \
    --configuration Release \
    --output /app/publish \
    /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
COPY src/Rinoleggio.db /app/Rinoleggio.db

ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production
EXPOSE 8080

ENTRYPOINT ["dotnet", "Rinoleggio.Web.dll"]
