---
tur: tarif
alan: btp
kategori: baglanti
urun_surumu: ""
tarih: 2026-10-10
guven: resmi
gozden_gecir: 2027-04-10
---

# S/4HANA veya ECC RFC/BAPI'lerini MCP Server ile AI ajanlarına expose etme

## Use case
Mevcut S/4HANA on-premise veya ECC sistemindeki RFC-enabled BAPI'leri (örn. müşteri/sipariş/stok sorguları) yeniden yazmadan, SAP Integration Suite'in MCP Server artifact'i üzerinden AI ajanlarına (Claude, Cline vb.) tool olarak sunmak.

## Varyantlar

### SAP Integration Suite MCP Server + Cloud Connector
Adımlar:
1. Cloud Connector ile SAP backend'e (ECC/S4HANA) RFC bağlantısı yapılandır.
2. BTP subaccount'unda bu RFC bağlantısına işaret eden bir Destination oluştur.
3. Integration Package içinde yeni bir MCP Server artifact'i oluştur, önceki adımdaki Destination'ı referansla.
4. Expose edilecek RFC/BAPI'leri MCP tool olarak ekle. Güvenlik için öncelikle read-oriented (GET) BAPI'lerle başla.
5. Policy'leri ayarla: Authentication (zorunlu), Quota; isteğe bağlı Spike Arrest, IP Filtering.
6. MCP Server'ı kaydet ve deploy et — Integration cell runtime'da aktif olur.
7. Developer Portal'da bir API Product olarak publish et; ajan geliştiricileri subscribe olup API key alır.
8. AI ajanı (örn. VS Code'da Cline extension) deploy edilen MCP endpoint + API key ile yapılandır.
9. Doğal dil promptlarıyla test et: ajan ilgili tool'ları discover edip, kullanıcı niyetine göre birden fazla BAPI çağrısını dinamik olarak orkestre eder (geleneksel yaklaşımda her senaryo için ayrı custom interface yazmak gerekirdi).
10. MCP transaction'larını Integration Suite monitoring menüsünden izle.

Ne zaman seçilir: ERP modernizasyonu tamamlanmadan, mevcut BAPI yatırımını koruyarak AI ajanlarına operasyonel erişim açmak istendiğinde (API/OData alternatifi henüz yoksa).

([[kaynaklar/2026-10-10-sap-integration-suite-mcp-server-rfc-bapi]])

## Tuzaklar
- RFC/BAPI expose etmek SAP'nin önerdiği uzun vadeli yön değil; API/OData alternatifi varsa onu tercih et. Bunu yeni entegrasyon kurmak için değil, sadece modernizasyon köprüsü olarak kullan.
- Demo'da sadece read-oriented (GET) BAPI'ler expose edilmiş; yazma/değişiklik yapan BAPI'leri ajana açarken ek onay/guardrail mekanizması olmadan risklidir.
- Ajana verilen API key/credential yönetimi kritik — governance policy'lerini (auth, quota, spike arrest, IP filtering) atlamadan uygula.

## İlgili
- [[araclar/sap-integration-suite-mcp-server|SAP Integration Suite MCP Server]]
