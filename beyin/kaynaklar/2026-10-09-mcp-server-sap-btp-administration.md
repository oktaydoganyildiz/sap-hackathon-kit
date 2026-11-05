---
tur: kaynak
alan: btp
tarih: 2026-10-09
guven: resmi
kaynak: https://community.sap.com/t5/technology-blog-posts-by-sap/public-release-of-the-mcp-server-for-sap-btp-administration/ba-p/14471692
gozden_gecir: 2027-04-09
---

# Public Release of the MCP server for SAP BTP administration

Link: https://community.sap.com/t5/technology-blog-posts-by-sap/public-release-of-the-mcp-server-for-sap-btp-administration/ba-p/14471692

Yazı türü: arac

## Özet

SAP, BTP altyapısını (Cockpit/CLI yerine) doğal dille sorgulamak, denetlemek ve provizyonlamak için resmi, uzak (remote) bir MCP server yayınladı. Claude Desktop/Claude Code gibi MCP istemcileri `https://sso.mcp.btp.cloud.sap/mcp` endpoint'ine bağlanarak entitlement keşfi, kullanıcı/rol audit'i ve subaccount provisioning gibi deklaratif görevleri doğal dil ile yaptırabiliyor. Kurulum tek satır `claude mcp add --transport http` komutu; kaynak derleme, host etme, destination veya proxy app gerekmiyor (zero platform setup). Kimlik doğrulama SAP Default Identity Provider üzerinden Authentication Code Flow ile principal propagation yapıyor; yani ajan, bağlanan kullanıcının IAM/role collection yetkisinin ötesine asla geçemiyor. Tek bağlantı ile tüm bölgelere (cross-region) erişim sağlanıyor, bölge endpoint'i ayrı ayrı yönetilmiyor. Resmi dokümantasyonda tam bağlantı parametreleri ve desteklenen istemciler kontrol edilmeli.

## Beslediği sayfalar

- [[araclar/mcp-server-btp-administration]]
