---
tur: kaynak
alan: btp
tarih: 2026-10-26
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/part-2-of-2-securing-ai-powered-sap-apps-on-sap-btp-single-sign-on-and-role/ba-p/14507365
gozden_gecir: 2027-04-26
---

# Part 2 of 2 – Securing AI-Powered SAP Apps on SAP BTP: Single Sign-On and Role-Based Access with XSUAA

Link: https://community.sap.com/t5/technology-blog-posts-by-members/part-2-of-2-securing-ai-powered-sap-apps-on-sap-btp-single-sign-on-and-role/ba-p/14507365

Yazı türü: tarif

## Özet
Part 1'de anlatılan, S/4HANA verisini AI client'lara açan MCP server'ın SAP BTP üzerinde Application Router ve XSUAA ile nasıl güvenli hale getirileceğini adım adım anlatan bir devam yazısı. xs-security.json ile scope/role-template/role-collection tanımlama, Application Router'ın xs-app.json ve manifest.yml konfigürasyonu, cf create-service/update-service komutları, trust configuration ve role collection ataması, Node.js tarafında @sap/xssec ve @sap/xsenv ile token doğrulama ve scope kontrolü örnek kodla gösteriliyor. Ayrıca session expiry'de arka plan isteklerinin reload ile ele alınması, role değişikliğinde re-login gerekliliği, backend bağlantısında teknik user (Cloud Connector/destination) ile principal propagation arasındaki fark ve production için önerilen yaklaşım anlatılıyor.

## Beslediği sayfalar
- [[btp/guvenlik/mcp-server-application-router-xsuaa]]
