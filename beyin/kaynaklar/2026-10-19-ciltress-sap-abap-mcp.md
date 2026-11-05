---
tur: kaynak
alan: ai
tarih: 2026-10-19
guven: topluluk
kaynak: https://github.com/Ciltress/sap-abap-mcp
gozden_gecir: 2027-04-19
---

# Ciltress/sap-abap-mcp — SAP ABAP MCP with ADT and JSON RPC

https://github.com/Ciltress/sap-abap-mcp

Yazı türü: arac

Özet:
- AI agent'lara ADT (ABAP Development Tools) üzerinden SAP ABAP sistemine tam okuma/yazma erişimi sağlayan MCP server.
- Üç parolasız kimlik doğrulama modu: SPNEGO/Kerberos SSO, X.509 istemci sertifikası, OAuth 2.0 bearer token; parola yalnız son çare olarak kalıyor.
- ADT'nin kendisinin yapamadığı RFC-enabled function module çağırma özelliğini SAP Gateway JSON-RPC 2.0 üzerinden ekliyor; batch RFC çağrıları tek LUW garantisi sağlıyor (ör. BAPI + BAPI_TRANSACTION_COMMIT).
- 128 araç: object CRUD, kaynak düzenleme/lock/activation/syntax check, code completion, ABAP Unit, ATC, DDIC, abapGit, refactoring, debugger, RFC çağrıları.
- `ABAP_MCP_PROFILE` (core/analyst/rfc/dev/all) ile tool listesi küçültülerek küçük modellerde context/token maliyeti düşürülüyor; sunucu başlarken sistemin desteklediği tool'ları sorup eksikleri (gate) listeden otomatik çıkarıyor.
- Streamable HTTP transport: çok kullanıcılı container'da her MCP istemci kendi SAP OAuth bearer token'ıyla kendi oturumunu açıyor, paylaşılan teknik kullanıcı kullanılmıyor.
- mario-andreschak'ın `mcp-abap-abap-adt-api` projesinin SSO/RFC odaklı fork'u; MIT lisanslı, son push 2026-10-14, yıldız sayısı 3 (erken aşama topluluk projesi, resmi SAP desteği yok).

## Beslediği sayfalar
- [[araclar/sap-abap-mcp-server-kurulum-kimliklendirme]]
