---
tur: konu
alan: ai
kategori: kavramsal
urun_surumu: ""
tarih: 2026-10-09
guven: topluluk
gozden_gecir: 2027-04-09
---

# MCP lifecycle: tool discovery tool invocation'ın çalışacağını garanti etmez

## Özet
Bir MCP server'ın `initialize` → `notifications/initialized` → `tools/list` adımlarını başarıyla tamamlaması, agent'ın (ör. Joule) `tools/call` ile aracı gerçekten çalıştırabileceği anlamına gelmez. Discovery ve invocation, ayrı doğrulanması gereken iki ayrı milestone'dur.

## Ne zaman kullanılır
- Joule Studio (veya başka bir MCP client) ile custom MCP server entegre ederken "server ayakta, tool listesi görünüyor ama agent tool'u çağırmıyor" durumuyla karşılaşıldığında
- MCP server implementasyonunda hangi lifecycle metodlarının (initialize, notifications/initialized, tools/list, tools/call) eksik olduğunu teşhis ederken

## Tuzaklar
- `notifications/initialized` bildirimini explicit olarak handle etmemek: server teknik olarak erişilebilir olsa da, bu adım handle edilmeden tool discovery (`tools/list`) düzgün ilerlemeyebilir.
- `tools/list`'in çalışmasını "entegrasyon tamam" olarak yorumlamak: discovery başarılı olsa da `tools/call` ayrı bir aşamadır ve ayrıca doğrulanmalıdır.
- Sorunu hemen schema stiline (plain schema vs Zod-based schema, MCP TypeScript/Node SDK) bağlamak: pratikte iki yaklaşım da aynı noktada (tools/list sonrası tools/call öncesi) takılabilir, yani schema stili tek başına kök neden olmayabilir.
- Protokol versiyon uyumsuzluğunu ve paket/runtime mismatch'i gözden kaçırmak: Joule endpoint'e ulaşabiliyorsa bile, sorunun protokol negotiation veya dependency sürümünden kaynaklanıp kaynaklanmadığı ayrıca kontrol edilmeli.

## Çözümler
- MCP server implementasyonunda şu dört lifecycle metodunu açıkça destekle: `initialize`, `notifications/initialized`, `tools/list`, `tools/call`.
- Entegrasyonu katman katman doğrula: önce backend çağrıları (MCP'den bağımsız), sonra MCP lifecycle handling, sonra tool discovery, en son tool invocation. Her katmanı ayrı doğrulamak, sorunun hangi katmanda olduğunu hızlıca izole eder.
- Şüpheli bir schema/SDK farkı varsa, paralel bir ikinci implementasyon (ayrı app, ayrı destination, ayrı schema stili) kurup karşılaştır — bu kök nedeni (schema stili mi, yoksa Joule tarafı invocation path mi) netleştirir.
- `tools/list` sonrası `tools/call`'a ilerlenmiyorsa, sorunun MCP server tarafında değil Joule/agent tarafındaki invocation path'inde olabileceğini göz önünde bulundur; server sağlığını yalnızca discovery ile sınırlı değerlendirme.

## Tarifler
Bu kaynaktan doğrudan bir tarif sayfası türetilmedi.

## Sürüm notu
Topluluk kaynaklı tek implementasyon deneyimine dayanır; Joule Studio'nun MCP TypeScript/Node SDK ve Zod-schema önerisi zamanla değişebilir, güncel resmi dokümantasyonla teyit edin.

([[kaynaklar/2026-10-09-sap-joule-studio-mcp-setup-guide]])
