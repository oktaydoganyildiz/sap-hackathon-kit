---
tur: arac
alan: btp
urun_surumu: ""
tarih: 2026-10-11
guven: topluluk
gozden_gecir: 2027-04-11
---

# cap-agent-ui5-webui (CAP ajanları için SAPUI5 chat arayüzü)

## Ne yapar
`@cap-js/agents` bir CAP servisini A2A protokolü konuşan ajana çevirir. Bu plugin o ajan için hazır SAPUI5 (TypeScript, freestyle) chat istemcisi sunar. `cds-plugin.js` kuralıyla otomatik yüklenir ve `http://localhost:4004/chat/index.html` adresinden servis edilir. CDS welcome page'deki "Web Applications" listesine de eklenir. ([[kaynaklar/2026-10-11-cap-agents-ui5-web-ui]])

- Yanıtlar stream edilir (A2A `message/stream`). Arayüz ajanla doğrudan konuşur, araya proxy veya backend-for-frontend girmez. ([[kaynaklar/2026-10-11-cap-agents-ui5-web-ui]])
- Ajan seçici: plugin `/chat/agents.json` dosyasını runtime'da üretir. Dosya, agent annotation'lı servisleri tarayıp listeler. İkinci bir ajan servisi eklenince kendiliğinden görünür, ayar gerekmez. ([[kaynaklar/2026-10-11-cap-agents-ui5-web-ui]])
- Human-in-the-loop: action'a HITL annotation'ı (yazıda `@agent.hitl`) konursa ajan action'ı çalıştırmak yerine A2A `input-required` durumunda bekler. Chat'te Approve ve Reject butonları çıkar, action ancak onaydan sonra çalışır. ([[kaynaklar/2026-10-11-cap-agents-ui5-web-ui]])
- Ajan servisi iki annotation ister: servis üstünde `@agent` ve `@protocol: ['odata', 'agent']`. ([[kaynaklar/2026-10-11-cap-agents-ui5-web-ui]])
- Ayarlar `package.json` içinde `cds["cap-agent-ui5-webui"]` altındadır, hepsi opsiyoneldir: `mountPath` (varsayılan `/chat`), `enabled` (profilde kapatmak için `false`), `bootstrapUrl` (varsayılan SAPUI5 CDN; air-gapped veya CSP kısıtlı ortamda kendi SAPUI5 kopyan), `serveUi` (UI'ı HTML5 Application Repository'ye koyarsan `false`), `agents` (izin listesi ve sıra). `"cap-agent-ui5-webui": false` plugin'i tamamen kapatır. ([[kaynaklar/2026-10-11-cap-agents-ui5-web-ui]])
- BTP'de varsayılan olarak UI CAP servisinden gelir. HTML5 Application Repository, content deployer veya ek `mta.yaml` modülü gerekmez. Approuter yine gerekir, ama yalnızca login için: CAP'in auth middleware'i 401 döner, tarayıcıyı identity provider'a yönlendiremez. ([[kaynaklar/2026-10-11-cap-agents-ui5-web-ui]])
- UI'ı HTML5 Application Repository'ye (ör. SAP Build Work Zone için) koymak istersen `npx cap-agent-ui5-webui html5 app/chat-ui/dist` komutu hazır UI, `xs-app.json` ve deploy edilebilir zip üretir ve eklenecek approuter route'larını yazdırır. Production profilinde `serveUi: false` ile birleştirilir. `agents.json` runtime'da üretildiği için CDS sunucusunda kalmak zorundadır. `dist` klasörü üretilmiş çıktıdır, git'e koyma. ([[kaynaklar/2026-10-11-cap-agents-ui5-web-ui]])

## Bende durumu
yeni. Envanterde `@cap-js/agents` için chat arayüzü sağlayan bir araç yok. Kurulu `sap-cds-mcp` (`cds-mcp`, `@cap-js/mcp-server`) CAP kodu üretimine yardım eder, bu plugin ise çalışan ajanın kullanıcı arayüzüdür; ikisi birbirinin yerine geçmez. Benzer konu: [[araclar/a2a-cap-agent-sablonu]] (ajan tarafı).

## Agentic BI'a katkısı
Doğrudan BI aracı değil. CAP üzerinde yazdığın bir ajanı (ör. analitik veriyi sorgulayan veya onay isteyen action'lar çağıran ajan) iş kullanıcısına göstermek için hazır, BTP'ye deploy edilebilir bir önyüz sağlar. HITL onay butonları, yazma yapan ajan action'larında insan onayı akışını görünür kılar. ([[kaynaklar/2026-10-11-cap-agents-ui5-web-ui]])

## Kurulum
```bash
npm add cap-agent-ui5-webui
```
Ardından `cds watch` ile `http://localhost:4004/chat/index.html` açılır. Çalışan referans: https://github.com/lemaiwo/cap-agent-ui5-webui-sample (`npm install && npm run dev`). ([[kaynaklar/2026-10-11-cap-agents-ui5-web-ui]])

## Dikkat
- Tek annotation yetmez. Yalnız `@agent` ile ajan çalışır ama OData artık servis edilmez. Yalnız `@protocol` ile A2A endpoint'i ve geçerli agent card gelir, ama handler kaydedilmediği için her mesaj runtime'da `buildGraph handler ... undefined` hatasıyla düşer. İkisini birlikte ver. ([[kaynaklar/2026-10-11-cap-agents-ui5-web-ui]])
- `@cap-js/agents` içindeki `/a2a/<ajan>/preview/` sayfası yalnızca yerel geliştirme içindir. Tarayıcının Authorization header'ını yeniden kullanır. Basic auth ile yerelde çalışır, approuter + XSUAA arkasında tarayıcıda session cookie olduğu için header yoktur ve çalışmaz. Son kullanıcıya BTP'de bu plugin'in UI'ı verilir. ([[kaynaklar/2026-10-11-cap-agents-ui5-web-ui]])
- Yazarın notu: bu plugin henüz markdown render etmez, preview sayfası eder. ([[kaynaklar/2026-10-11-cap-agents-ui5-web-ui]])
- UI varsayılan olarak SAPUI5 CDN'den yüklenir. Kapalı ağ veya katı CSP varsa `bootstrapUrl` ile kendi SAPUI5 kopyanı göster. ([[kaynaklar/2026-10-11-cap-agents-ui5-web-ui]])
- Üçüncü taraf topluluk plugin'i (SAP ürünü değil). Yazıda lisans, son push tarihi ve bakım sözü verilmemiş; kurmadan önce npm ve GitHub sayfasından kontrol et. Plugin kimlik bilgisi istemez, kimlik doğrulama CAP ve approuter tarafında kalır.
- `@cap-js/agents` yeni çıkmış bir SAP plugin'i; ajan davranışı (HITL, A2A) o paketin sürümüne bağlıdır.

## Benzerleri
- [[araclar/a2a-cap-agent-sablonu]]: ajan tarafı. A2A sunucusunu `@a2a-js/sdk` ile CAP'e monte eden şablon; arayüz sağlamaz.
- [[araclar/cap-agentic-engineered]]: CAP + Fiori geliştirmesinde MCP destekli kodlama ajanı metodolojisi; kullanıcıya dönük ajan arayüzü değildir.
- `@cap-js/agents` yerleşik `/a2a/<ajan>/preview/` sayfası: yerel geliştirme önizlemesi, BTP'de uygun değil.
