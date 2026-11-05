---
tur: arac
alan: ai
urun_surumu: ""
tarih: 2026-10-08
guven: resmi
gozden_gecir: 2027-04-08
---

# Context7 MCP Server (Remote)

## Ne yapar
Context7, LLM tabanlı kod ajanlarına (ör. Cline) güncel kütüphane/paket dokümantasyonunu (ör. Python `hana_ml` paketi) canlı olarak sağlayan bir MCP (Model Context Protocol) server'dır. Hem lokal kurulum hem de remote URL olarak eklenebilir. Ajana doğrudan "Context7 için remote URL ile MCP server ekle" denilerek kurulum ajanın kendisine yaptırılabilir.

## Bende durumu
yeni

## Agentic BI'a katkısı
LLM'in eğitim verisinde bulunmayan veya güncel olmayan SAP Python paket API'lerini (ör. hana_ml'deki AdditiveModelForecast çağrısı) doğru kullanmasını sağlayarak, ajanın ürettiği kodun ilk denemede çalışma ihtimalini artırır; agentic geliştirmede "güncel/doğru API kullanımı" güven sorununu azaltan tamamlayıcı bir MCP katmanıdır.

## Kurulum
Cline "Plan" modundayken ajana şu istemi ver: "Add an MCP server for Context7, use the remote URL" → planı onaylayıp "Act" moduna geç → istekleri onayla; kurulum Cline Ayarları > MCP Servers altında ve prompt altındaki etkin MCP server listesinde görünür.

## Dikkat
- Lokal (BAS içi) kurulum yazıda başarısız olmuş, yalnızca remote URL versiyonu sorunsuz çalışmış — ortam bağımlı bir sorun olabilir.
- Üçüncü taraf, SAP dışı bir MCP server'dır; hangi istek/verinin bu servise gittiği değerlendirilmeli, hassas kimlik bilgisi veya veri paylaşılmamalı.
- Lisans/bakım/son güncelleme bilgisi YAZI'da verilmemiş.

## Benzerleri
[[araclar/cline-bas-sap-ai-core|Cline (BAS) + SAP AI Core ile Vibe Coding]] (Context7'yi doküman kaynağı olarak kullanan ana ajan).

([[kaynaklar/2026-10-08-vibe-coding-hana-ml-bas-cline-claude]])
