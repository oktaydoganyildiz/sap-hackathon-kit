---
tur: arac
alan: ai
kategori: ajan-araci
urun_surumu: ""
tarih: 2026-10-19
guven: topluluk
gozden_gecir: 2027-04-19
---

# BTP OData Catalogue — MCP'siz Doğrudan Agent Binding

## Ne yapar
BTP üzerindeki agentic AI uygulamasında (btp-dynamic-multiagent-app), ajanların SAP OData servislerine MCP server olmadan, uygulama içinde in-process çalışan bir "builtin:odata" toolset üzerinden doğrudan erişmesini sağlar. Admin, admin UI'de bir katalog tanımlar: hangi OData servisleri ($metadata'dan import edilir), hangi entity set'ler, hangi alanlar ve hangi operasyonlar (list/get/create/update/delete) ajanlara açık olacağını seçer. Her servis kendi kimliğine sahiptir — BTP destination ve kim olarak çalışacağı: signed-in user (principal propagation) veya technical user. Ajana sadece iki sabit tool verilir: search_operations (neyi okuyabileceğini/yapabileceğini bulmak için) ve execute_operation (ismiyle bir operasyonu çalıştırmak için) — URL, destination adı veya serbest path hiçbir zaman görünmez; kataloğun tanımadığı bir isim model için yok sayılır.

## Bende durumu
yeni — envanterde bu desende (MCP'siz, katalog tabanlı, alan düzeyinde RBAC'li doğrudan OData binding) bir araç yok. Kurulu `odata-mcp-proxy` (aynı yazarın başka bir projesi) ve `joule-desktop-mcp-odata-connector` (RAP/OData V4 için) OData'ya MCP server üzerinden erişiyor; bu araç ise bilinçli olarak MCP server'ı devre dışı bırakıp OData'yı uygulama içinde toolset olarak sunuyor — kurulu olanların alternatifi, farklı bir mimari.

## Agentic BI'a katkısı
Oktay'ın agent tool binding mimarisine, tek tüketicili (yalnız bu uygulamanın ajanları) senaryolarda MCP server kurmadan iş verisine (purchase requisition, planlama kaydı vb.) erişim sağlayan daha hafif bir alternatif sunuyor. Kurallar prompt'ta değil kodda uygulanıyor:
- $select her zaman gönderiliyor, yalnız katalogda "readable" işaretli alanlar modele ulaşıyor; filtre yalnız izinli alanlarla kurulabiliyor (gizli değer sorgulanamıyor).
- Kimlik servis bazında kararlaştırılıyor (ajan bazında değil): admin, SAP'nin kullanıcıyı mı (principal propagation) yoksa teknik kullanıcıyı mı göreceğine karar veriyor; OnPremise sistemler yine connectivity service + Cloud Connector üzerinden gidiyor.
- Yazma işlemi için iki ayrı anahtar gerekiyor: operasyon katalogda etkin olmalı VE ajanda "Allow writes" açık olmalı; function import/action'lar da (release/approve gibi) aksi belirtilmedikçe yazma sayılıyor.
- Her yazımdan önce niyet (intent), sonra sonuç satırı audit log'a yazılıyor; audit log'a yazılamazsa işlem SAP'ye hiç gönderilmiyor.
- Model ETag'i hiç görmüyor; opak bir handle alıyor, gerçek ETag sunucuda kalıp If-Match olarak gidiyor.

SAP API Policy (Nisan 2026) açısından, bu ajanlar BTP alt hesabında, SAP'nin kendi platformunda pro-code çalıştığı için (SAP Architecture Center referans mimarisiyle uyumlu — Pydantic AI + A2A to Joule) endorsed mimari kapsamında görülüyor; müşteri namespace'indeki (Z) servisler serbest kalıyor. Yazar "ben avukat değilim" notuyla kendi senaryonuzu SAP API Policy'ye karşı doğrulamanızı öneriyor.

## Kurulum
GitHub reposunu (github.com/lemaiwo/btp-dynamic-multiagent-app) kurup admin UI'de bir OData servisini $metadata'dan import ederek entity set/alan/operasyon bazında kataloğa ekleyin, ardından ilgili ajana "OData services" toolset'ini atayıp hangi katalog servislerini ve yazma iznini (Allow writes) vereceğinizi seçin.

## Dikkat
- Topluluk/üçüncü taraf bir uygulama örneği; lisans, bakım sürekliliği ve son push tarihi bu yazıda belirtilmemiş — kullanmadan önce repo kontrol edilmeli.
- SAP API Policy'ye göre ajanların SAP API'lerine yalnız "endorsed SAP architecture" üzerinden erişmesi gerekiyor; bu desen BTP alt hesabında pro-code ajan olarak çalıştığı için uygun görünüyor ama bu hukuki bir görüş değil — kendi senaryonuzu doğrulayın (SAP API Policy overview, Architecture Center referans mimarisi).
- Bu yaklaşım yalnız tek tüketicili (bu uygulamanın ajanları) senaryo için önerilir; aynı API'yi Joule, Copilot, Claude gibi birden fazla AI istemcisinin paylaşması gerekiyorsa MCP server (ör. odata-mcp-proxy) daha doğru seçim — yazar bu ayrımı bilinçli yapıyor.
- "Nothing arrives enabled" ilkesi: yeni bir servis katalogda hiçbir izin olmadan import ediliyor, her entity set/alan/operasyon tek tek elle açılmalı; kişisel veri alanları da elle işaretleniyor.

## Benzerleri
- [[araclar/odata-mcp-proxy|odata-mcp-proxy]] (kurulu, topluluk) — aynı yazarın (lemaiwo) önceki projesi; OData'yı MCP server üzerinden expose eder, çok istemcili senaryo için uygundur.
- [[araclar/joule-desktop-mcp-odata-connector|Joule Desktop + Custom MCP Server]] — Joule Desktop'ı MCP server üzerinden RAP/OData V4'e bağlar; bu yazıdaki desenin tam tersi (MCP'li) yaklaşımı temsil eder.

([[kaynaklar/2026-10-19-btp-odata-catalogue-direct-binding]])
