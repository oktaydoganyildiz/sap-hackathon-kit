---
tur: tarif
alan: btp
kategori: baglanti
urun_surumu: ""
tarih: 2026-10-09
guven: resmi
gozden_gecir: 2027-04-09
---

# MCP Araç Keşfi: BTP Destination Üzerinden Principal Propagation ile A2A/CAP Ajanı

## Use case
Bir A2A/CAP ajanının, BTP Destination Service'te tanımlı MCP sunucularını başlangıçta (startup) keşfedip, her araç çağrısında çağıran kullanıcının JWT'sini ileterek (principal propagation) yetkili istek atması gerektiğinde kullanılır.

## Varyantlar

### agent-definition.mcpServers + özelleştirilmiş fetch + AsyncLocalStorage JWT taşıma
Adımlar:
1. Agent config'ine MCP sunucusunu destination adıyla tanımla:
```ts
config: {
    mcpServers: [{
        name: "My Tool Server",
        destinationName: "destination-to-mcp-server",
        path: "/mcp",
    }]
}
```
2. `StreamableHTTPClientTransport`'un fetch fonksiyonunu özelleştirerek her çağrıda destination'ı (varsa kullanıcı JWT'si ile) çöz ve auth header'larını ekle:
```ts
const baseFetch = (transportOpts.fetch as typeof globalThis.fetch) ?? globalThis.fetch;
transportOpts.fetch = async (input, init) => {
  const mergedHeaders = new Headers(init?.headers);
  try {
    const userJwt = getCurrentJwt();
    const dest = await getDestination({
      destinationName: serverConfig.destinationName,
      ...(userJwt && { jwt: userJwt }),
    });
    if (dest?.authTokens?.length) {
      for (const token of dest.authTokens) {
        if (!token.error && token.http_header) {
          mergedHeaders.set(token.http_header.key, token.http_header.value);
        }
      }
    }
    if (dest?.headers) {
      for (const [key, value] of Object.entries(dest.headers)) {
        mergedHeaders.set(key, value as string);
      }
    }
  } catch (err) {
    this.LOG.warn(`Destination çözülemedi: ${serverConfig.destinationName}`, err);
  }
  return baseFetch(input, { ...init, headers: mergedHeaders });
};
```
3. Gelen kullanıcı JWT'sini request-scope'ta taşımak için Express middleware + AsyncLocalStorage kullan (global state yerine):
```ts
export function createJwtContextMiddleware(xsuaaService) {
  return function jwtContextMiddleware(req, _res, next) {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith("Bearer ")) { next(); return; }
    const token = authHeader.substring(7);
    // AsyncLocalStorage.run(token, next) ile context'e yaz
  };
}
```
4. Middleware'i A2A JSON-RPC route'una bağla:
```ts
app.use(
  `${agentPath}/a2a/jsonrpc`,
  express.json(),
  jwtMiddleware, // JWT'yi context'e yaz
  jsonRpcHandler({ requestHandler, userBuilder }),
);
```
Ne zaman seçilir: Kullanıcı bazlı yetkilendirme gereken dış araç/servis çağrılarında (ör. backend API'lerine satır/obje seviyesi yetki ile erişim) her zaman — API key/sabit credential ile tüm kullanıcılar adına tek bir teknik kullanıcı kullanmak yerine.
([[kaynaklar/2026-10-09-a2a-agents-sap-btp-cap]])

## Tuzaklar
- JWT'yi global değişkende/singleton'da tutmak paralel isteklerde kullanıcı karışmasına yol açar; mutlaka AsyncLocalStorage (request-scope) kullanılmalı.
- `getDestination` hata verirse (try/catch içinde) tool call credential'sız/varsayılan header'larla devam edebilir — sessiz hata yutma riskine karşı loglama ve gerekiyorsa çağrıyı reddetme eklenmeli.
- Destination'da principal propagation açık değilse JWT iletimi anlamsız kalır; destination konfigürasyonu (Authentication: "PrincipalPropagation" / "OAuth2JWTBearer" vb.) önceden doğrulanmalı.

## İlgili
[[araclar/a2a-cap-agent-sablonu]]
