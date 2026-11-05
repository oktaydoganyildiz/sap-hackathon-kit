---
tur: tarif
alan: ai
kategori: diger
urun_surumu: ""
tarih: 2026-10-11
guven: topluluk
gozden_gecir: 2027-04-11
---

# Joule Studio agent builder ile text-to-SQL agent

## Use case
Satış temsilcisi, Joule Studio agent builder üzerinde kurulu bir agent'a doğal dille soru soruyor (ör. "Müşterim için satın alma davranışında anormallik var mı?"). Agent soruyu SAP HANA Cloud'daki (BDIH) veriye SQL'e çevirip çalıştırıyor, sonucu ürün dokümanı bilgisiyle zenginleştirip özetliyor.

## Varyantlar

### Document grounding + custom SQL skill (text-to-SQL hattı)
Yazıda kod veya SQL örneği verilmiyor; aşağıdaki adımlar yazıda anlatılan mimarinin özetidir.

1. Agent builder'da agent'ı oluştur.
2. Document grounding ile agent'a şu dokümanları ver:
   - ilgili tüm tabloların veritabanı şeması,
   - örnek SQL sorguları,
   - veritabanı yapısı ve iş bağlamı hakkında genel dokümantasyon.
   Bu dokümanlar agent'ın doğal dil sorusunu gerçek tablo/kolonlara eşlemesini sağlıyor.
3. SQL'i çalıştırmak için custom Joule Skill yaz: girdi olarak SQL sorgusunu alır, veriyi veritabanına giden bir proxy endpoint üzerinden çeker.
4. Skill'i SAP Build Actions ile kurarken dinamik çıktı sınırına dikkat et (bkz. Tuzaklar).
5. Akış: kullanıcı soru sorar → agent niyeti yorumlar ve veri kaynağını seçer → şema ve örnek sorgulardan yararlanıp SQL'i üretir → skill sorguyu çalıştırır → sonuç düz dille özetlenir, takip soruları sorulabilir.

Ne zaman seçilir: agent'ın veritabanına serbest, geniş soru yelpazesiyle erişmesi gerekiyorsa (sadece sabit bir anomali sorgusu değil). Yazarlara göre bu yaklaşım anomali tespitinin ötesinde ek içgörülere (ör. order stop'a giren ürünün halef ürününü bulma) de izin veriyor.

([[kaynaklar/2026-10-11-joule-studio-text-to-sql-agent-satin-alma-anomalisi]])

### Ayrı skill ile ürün bilgi tabanı (RAG) ekleme
1. Dahili RAG sistemindeki ürün dokümantasyonuna erişen ikinci bir Joule Skill oluştur ve agent'a bağla.
2. Agent soru tipine göre SQL skill'ini, bilgi tabanı skill'ini veya ikisini birlikte çağırır.
3. Örnek kullanım: SQL ile bulunan sipariş edilmiş ürünü halefiyle karşılaştırıp neyin değiştiğini ürün dokümanından açıklatmak.

Ne zaman seçilir: veri sorgusu sonucunun doküman bilgisiyle yorumlanması gerekiyorsa. Veri ve doküman kaynakları ayrı skill'lerde tutulduğu için birbirinden bağımsız değiştirilebilir.

([[kaynaklar/2026-10-11-joule-studio-text-to-sql-agent-satin-alma-anomalisi]])

## Tuzaklar
- SAP Build Actions dinamik çıktıları tam desteklemiyor; veritabanından gelen, her sorguda değişen sonuç yapısı için workaround gerekiyor. Yazı workaround'un nasıl yapıldığını anlatmıyor, bu yüzden bu kısım için ayrıca çözüm aranmalı. ([[kaynaklar/2026-10-11-joule-studio-text-to-sql-agent-satin-alma-anomalisi]])
- Agent veritabanına proxy endpoint üzerinden SQL gönderiyor; yazıda yetkilendirme veya salt-okunur kısıtlamasından söz edilmiyor. Proxy'nin yalnızca okuma yapacak şekilde sınırlanması kendi sorumluluğundadır (yazıdan çıkarım, doğrulanmamış).
- Native bir database tool'u yazıda ileride gelebilecek bir özellik olarak geçiyor; bugün mevcut sayılmamalı, text-to-SQL hattı şimdilik elle kuruluyor. ([[kaynaklar/2026-10-11-joule-studio-text-to-sql-agent-satin-alma-anomalisi]])
- Üretilen SQL'in kalitesi grounding dokümanlarına (şema, örnek sorgu, iş bağlamı) bağlı; bu dokümanlar eksikse doğal dil-tablo eşlemesi bozulur. ([[kaynaklar/2026-10-11-joule-studio-text-to-sql-agent-satin-alma-anomalisi]])

## Cevapladığı sorular
- Joule Studio agent builder'da doğal dilden SQL üreten (text-to-SQL) agent, HANA Cloud veritabanına nasıl bağlanır ve grounding ile skill nasıl kurulur?

## İlgili
- [[araclar/joule-pro-code-a2a|Joule Pro-Code Extensibility + A2A]] (kod tabanlı ajanları Joule'a bağlama alternatifi)
- [[ai/baglanti/joule-cli-login-sorunlari|Joule CLI login sorunları]]
