# Tesla Fleet API — registratie van Homing

Overzicht van wat in elke stap van het Tesla developer-portal formulier
("Fleet API-toepassing aanmaken", developer.tesla.com) ingevuld moet
worden voor de Homing-app. Bij her-registratie of rotatie van
credentials kun je dit als referentie gebruiken.

## 1. Registratie

| Veld | Waarde |
|---|---|
| Registratietype | **Alleen voor mij** (persoonlijk account) |

## 2. Gegevens applicatie

| Veld | Waarde |
|---|---|
| Naam applicatie | `Homing` |
| Beschrijving applicatie (≤150) | `Persoonlijke macOS menubar-app die toont hoe lang het nog duurt voordat mijn Tesla thuis is.` |
| Gebruiksdoel (≤1000) | zie [Gebruiksdoel-tekst](#gebruiksdoel-tekst) hieronder |

### Gebruiksdoel-tekst

```
Persoonlijk, niet-commercieel gebruik. Eén gebruiker, één voertuig (mijn eigen auto).

Homing draait als macOS menubar-applicatie en toont real-time status:
- Tijdens een rit: ETA naar huis of andere bestemming.
- Bij stilstand: of deuren, ramen, kofferbak of frunk openstaan, plus laadstatus.

Data-flow: het voertuig pusht Fleet Telemetry naar een eigen Cloudflare Worker, die het via Server-Sent Events doorstuurt naar de Mac-app. Er worden geen periodieke vehicle_data-calls gedaan; alleen één call wanneer de gebruiker handmatig op een refresh-knop klikt. GET /vehicles wordt gebruikt voor liveness-detectie (asleep/online/offline) zonder de auto te wekken.

Geen distributie via App Store, geen delen van data met derden, geen analytics. Code blijft persoonlijk.
```

## 3. Client-gegevens

| Veld | Waarde |
|---|---|
| Type OAuth Grant | **Autorisatiecode en Machine-to-Machine** |
| Toegestane oorsprongs-URL(s) | `https://homing.mvberkum.workers.dev` |
| Toegestane doorlink-URI(s) | `homing://oauth/callback` |
| Toegestane retour-URL(s) (optioneel) | *leeg laten* |

Notitie: pure machine-to-machine kan niet — de app gebruikt
`ASWebAuthenticationSession` (authorization code flow). De "+ M2M"
component hebben we nodig voor partner-app-token en het pushen van de
telemetry-config.

Fallback voor doorlink-URI als Tesla het custom scheme afwijst:
`https://homing.mvberkum.workers.dev/oauth/callback` met de Worker als
bridge die `Location: homing://oauth/callback?...` redirect.

## 4. API en toepassingsgebieden

Alleen de minimale scopes — Tesla wijst te brede scope-sets af of
vertraagt approval.

| Scope | Aan/uit | Reden |
|---|---|---|
| Profielinformatie | ❌ | Niet nodig (contact/profielfoto) |
| Voertuiginformatie | ✅ | `GET /vehicles`, `GET /vehicle_data`, telemetry-config |
| Voertuiglocatie | ✅ | Telemetry-velden `Location`, `RouteLatitude/Longitude`, `RouteDestination` |
| Voertuigcommando's | ❌ | Read-only app, geen lock/unlock/HVAC |
| Oplaadbeheer voertuig | ❌ | Geen laad-controle; SOC valt onder Voertuiginformatie |
| Informatie Energy-producten | ❌ | Geen Powerwall/zonnepanelen |
| Commando's Energy-producten | ❌ | Idem |

Bij OAuth-call (Fase 2B) wordt apart de `offline_access` scope-parameter
meegegeven voor refresh tokens. Niet in dit formulier.

## 5. Factureringsgegevens (optioneel)

**Overslaan en indienen.**

Met Fleet Telemetry push (gratis aan Tesla-kant) en geen periodieke
`vehicle_data`-calls blijven we ruim binnen de free tier. Geen kaart op
het account betekent dat Tesla bij overschrijding access *suspendt* in
plaats van stilletjes door te factureren — dit is de bedoelde safety
net (zie `BILLING_LIMIT=0` in `README.md`).

## Public-key host (vereiste, los van het formulier)

Tesla pingt het opgegeven domein op
`https://homing.mvberkum.workers.dev/.well-known/appspecific/com.tesla.3p.public-key.pem`.
Dit bestand moet bestaan **voordat** je het formulier indient, anders
kan submissie stilletjes falen of word je later geblokkeerd bij
`partner_token`.

Aanmaken in Fase 2A: Cloudflare Worker (of Pages) host dit pad. Lokaal
key-paar genereren met:

```bash
openssl ecparam -name prime256v1 -genkey -noout -out tesla-private.pem
openssl ec -in tesla-private.pem -pubout -out tesla-public.pem
```

`tesla-public.pem` deployen naar de Worker; `tesla-private.pem` blijft
**lokaal en niet in git** — alleen nodig voor command-signing als we
ooit `vehicle_cmds` zouden gebruiken (= niet, dus de private key kan
weggegooid worden zodra registratie compleet is).

## Bekend probleem: `*.workers.dev`-domein

Tesla *kan* `*.workers.dev` afwijzen omdat het Cloudflare's domein is
en jij geen registrar-eigenaar bent. Symptomen:

- Formulier reset naar stap 1 zonder duidelijke foutmelding na
  "Versturen".
- Submissie lukt, maar `partner_token`-call later faalt met
  `invalid_redirect_uri` of `domain_not_verified`.

Workaround: registreer een goedkoop domein bij Cloudflare Registrar
(~€10/jr) en gebruik `https://homing.<jouwdomein>` overal in plaats
van `homing.mvberkum.workers.dev`. Update dan zowel:

- Stap 3 → Toegestane oorsprongs-URL
- Public-key host pad

## Na succesvolle indiening

Tesla toont **Client ID** en **Client Secret**. Direct opslaan in
1Password / Bitwarden — de secret kan achteraf alleen geroteerd
worden, niet meer ingezien.

Beide worden via Settings in de Homing-app ingevoerd (Fase 2B) en
opgeslagen in macOS Keychain (`kSecAttrAccessibleAfterFirstUnlock`).
