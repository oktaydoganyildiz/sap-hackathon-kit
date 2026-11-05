---
tur: arac
alan: ai
urun_surumu: ""
tarih: 2026-10-19
guven: topluluk
gozden_gecir: 2027-04-19
---

# sap-abap-mcp (Ciltress, SSO fork)

## Ne yapar
MCP server ile AI agent'lara ADT (ABAP Development Tools) protokolü ve SAP Gateway JSON-RPC üzerinden SAP ABAP sistemine programatik erişim sağlar. Şifre kullanmadan üç oturum açma yöntemi sunar: SPNEGO/Kerberos SSO, X.509 istemci sertifikası, OAuth 2.0 bearer token (parola son çare olarak kalır, kullanıldığında yanlış deneme SU01 kullanıcı kilidini tetikler ve sunucu bu yüzden tekrar denemez). ADT'nin kendisinin yapamadığı bir şeyi ekler: RFC-enabled function module çağırma (SAP Gateway JSON-RPC 2.0 üzerinden), tek LUW içinde batch RFC çağrıları dahil (ör. bir update BAPI'siyle BAPI_TRANSACTION_COMMIT'in aynı LUW'da gitmesi garantisi). 128 araç: object CRUD, kaynak düzenleme, lock, transport, activation, syntax check, code completion, ABAP Unit, ATC, DDIC, abapGit, refactoring, trace, debugger, RFC çağrıları. Profil mekanizması (`ABAP_MCP_PROFILE`: core/analyst/rfc/dev/all) context/token maliyetini küçük/yerel modellerde azaltır; sunucu başlarken sisteme hangi tool'ları destekleyip desteklemediğini sorar ve eksik olanları (ör. DEV'de abapGit plugin yoksa) listeden otomatik çıkarır (gate). Streamable HTTP transport ile çok kullanıcılı container'da her bağlantı kendi OAuth bearer token'ıyla kendi SAP oturumunu açar — paylaşılan teknik kullanıcı yoktur, her oturumun kendi lock'u ve audit trail'i vardır.

## Bende durumu
Envanterde doğrudan karşılığı yok; ancak `araclar/sap-abap-mcp.md` sayfasında anlatılan `@coaspe/sap-abap-mcp` (ADT HTTP tabanlı, 120 araç, transport yönetimi/RAP generator/abapGit/debugger/kalite kapısı odaklı) farklı bir projedir — bu araç (Ciltress fork, mario-andreschak'ın `mcp-abap-abap-adt-api` projesinden türetilmiş) kimlik doğrulamaya (Kerberos/X.509/OAuth2, parolasız) ve RFC/JSON-RPC batch çağrılarına odaklanır. Envanterdeki `sap-abap` (sap-skills plugin, skill tabanlı) bunun alternatifi değil, tamamen farklı bir yaklaşım (MCP server değil). Sonuç: **kurulu olanın alternatifi: sap-abap-mcp (@coaspe, [[araclar/sap-abap-mcp]])** — ikisi de ABAP MCP server ama farklı güçlü yanları var; biri transport/RAP/kalite kapısına, bu biri kurumsal kimlik doğrulama (SSO) ve RFC çağrılarına odaklı.

## Agentic BI'a katkısı
BDC/BW4/Datasphere projelerinde S/4 tarafındaki ABAP geliştirmeyi (CDS view, extractor sınıfı, RFC/BAPI) agent'ın kurumsal SSO kimliğiyle (Kerberos) veya servis sertifikasıyla güvenli biçimde otomatikleştirmesini sağlar — hiçbir şifre saklanmadan veya iletilmeden. RFC batch çağrıları (`callFunctionsViaJsonRpc`) ile bir BAPI ve `BAPI_TRANSACTION_COMMIT`'in aynı LUW'da gitmesi garanti edilir; bu, veri işleme/transformation akışlarında agent'ın güvenilir biçimde BAPI çağırarak veri yazmasını mümkün kılar. Profil ve gate mekanizması, agentic BI zincirinde küçük/yerel modellerle çalışırken tool listesi context maliyetini düşürür (ör. `core` profili 9 tool / ~2.700 token'a karşı `all` 129 tool / ~17.800 token).

## Kurulum
```bash
git clone --recurse-submodules https://github.com/Ciltress/sap-abap-mcp.git && cd sap-abap-mcp && npm install && npm run build
```

## Dikkat
- Lisans: MIT. Son push: 2026-10-14 (aktif, ancak yıldız sayısı düşük — 3 — erken aşama topluluk projesi, resmi SAP desteği yok).
- `.env` dosyasına asla şifre commit edilmemeli; üç parolasız moddan (Kerberos/X.509/OAuth2) biri tercih edilmeli, parola yalnız son çare olarak kullanılmalı.
- Kerberos modu Windows'ta `curl.exe --negotiate` kullanır (Schannel/SSPI); diğer platformlarda GSS-API destekli curl (`SSO_CURL_PATH`) gerekir — GSS-API olmadan derlenmiş curl (ör. Alpine) sessizce token göndermez ve beklenmedik 401 ile sonuçlanır (bu yüzden image Debian tabanlı).
- X.509 modu SNC değil mutual TLS'tir; SAP tarafında ICM port'unun sertifika istemesi (`VCLIENT`), `STRUST`'ta CA güveni ve `CERTRULE` mapping'i gerekir — SNC için zaten çalışan bir sertifika yeniden kullanılabilir ama `SNC0` ACL devre dışı kalır.
- OAuth client credentials modunda yanlış `SAP_OAUTH_CLIENT_SECRET`, `login/fails_to_user_lock` sayacını SU01'deki kullanıcıya karşı işletir; sunucu bu yüzden reddedilen bir token isteğini tekrar denemez.
- HTTP transport modunda her oturum kendi bearer token'ıyla kimliklenir; `ABAP_MCP_HTTP_ALLOWED_ORIGINS` boş bırakılırsa (varsayılan) hiçbir browser origin'i kabul edilmez (DNS-rebinding koruması) — bu unutulursa web tabanlı istemci bağlanamaz.
- Docker image build'i `--recurse-submodules` ile yapılmazsa 35 genel mühendislik skill'i eksik kalır (ABAP skill'leri etkilenmez).
- Üçüncü taraf bir MCP server'a SAP kimlik bilgisi (sertifika/keytab/OAuth secret) vermeden önce depo sahipliği ve bakım sürekliliği değerlendirilmeli; proje görünürde tek geliştiriciye ait ve küçük bir topluluk tarafından kullanılıyor.

## Benzerleri
- `@coaspe/sap-abap-mcp` ([[araclar/sap-abap-mcp]]) — aynı kategori, transport yönetimi/RAP generator/abapGit/kalite kapısına odaklı
- Upstream `mcp-abap-abap-adt-api` (mario-andreschak) — Basic Auth, RFC/JSON-RPC araçları yok
- SAP'nin resmi ADT MCP Server — ADT client içinde host edilir, bağımsız stdio server değil

([[kaynaklar/2026-10-19-ciltress-sap-abap-mcp]])
