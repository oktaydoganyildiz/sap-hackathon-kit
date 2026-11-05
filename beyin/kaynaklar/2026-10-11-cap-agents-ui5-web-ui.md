---
tur: kaynak
alan: btp
urun_surumu: ""
tarih: 2026-10-11
guven: topluluk
kaynak: https://community.sap.com/t5/technology-blog-posts-by-members/cap-agents-ui5-web-ui/ba-p/14465443
gozden_gecir: 2027-04-11
---

# CAP Agents UI5 Web UI

Link: https://community.sap.com/t5/technology-blog-posts-by-members/cap-agents-ui5-web-ui/ba-p/14465443

Yazı türü: arac

## Özet
- Topluluk üyesi blogu. SAP'nin `@cap-js/agents` plugin'i bir CAP servisini A2A konuşan ajana çevirir; ama kullanıcıya verilebilir bir arayüz yoktur.
- `cap-agent-ui5-webui` npm plugin'i bu boşluğu doldurur: tek `npm add` ile SAPUI5 chat istemcisi `/chat/index.html` altında servis edilir.
- Chat istemcisi ajanla doğrudan A2A üzerinden konuşur, proxy yoktur. Yanıtlar stream edilir.
- Projede birden fazla ajan varsa ajan seçici çıkar. Liste, runtime'da üretilen `/chat/agents.json` ile dolar.
- Human-in-the-loop: ajan `input-required` durumuna geçince Approve ve Reject butonları görünür. Onaydan sonra action çalışır.
- `@cap-js/agents` içindeki yerleşik `/a2a/<ajan>/preview/` sayfası yalnızca yerel geliştirme içindir. Authorization header'ı okuduğu için approuter + XSUAA arkasında çalışmaz.
- BTP'de UI varsayılan olarak CAP servisinden gelir, HTML5 Application Repository gerekmez. Yalnızca login için approuter gerekir.
- Önemli tuzak: ajan servisinde hem agent annotation'ı hem `@protocol` gerekir.
- Örnek proje yerel, hybrid (SAP AI Core) ve BTP kurulumlarını gösterir.

## Beslediği sayfalar
- [[araclar/cap-agent-ui5-webui]]
