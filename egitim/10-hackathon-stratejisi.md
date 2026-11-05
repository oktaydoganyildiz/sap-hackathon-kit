# 10 · Hackathon Stratejisi

> **Tek cümle:** Gerçek bir sektör problemini, veri + karar + aksiyon döngüsüyle çözen, Joule'den çalışan bir agent göster ve tek bir sağlam sayıyla anlat.

Görev Pazartesi açıklanacak. Bu dosya hazırlıklı gitmek için, fikirler göreve göre uyarlanacak. Araştırma: `11-hackathon-arastirma.md`.

---

## 1. Jüri neye bakacak (geçmiş SAP hackathonlarından)

1. **Çalışan prototip.** Slayt değil. Organizatör ekip FDE (Forward Deployed Engineer) kültüründen geliyor.
2. **Ölçülebilir iş değeri.** "X'ten Y'ye" diye tek bir sayı.
3. **Standart SAP'de olmayan.** "Joule bunu zaten yapıyor" denmesin.
4. **Teknik bütünlük.** Doğru mimari: A2A, destination, IAS, AI Core.
5. **Human-in-the-loop.** Agent önemli kararda insana sorar (`input-required`).

---

## 2. Senaryo fikirleri

SAP'nin 7 Industry AI alanına ve bizim veri tarafındaki gücümüze göre:

| # | Fikir | Sektör | Neden güçlü |
|---|---|---|---|
| 1 | **KPI Bekçisi:** Datasphere/BDC verisinde KPI'ı izler, sapma olunca kök neden bulur, aksiyon önerir, onaylanınca tetikler | Herhangi biri | Japonya kazananına benzer, ama bizim veri bilgimizle daha derin |
| 2 | **Talep sapma agent'ı:** Satış tahmini ile gerçekleşen farkını açıklar (SAP-RPT-1), yeniden planlama önerir | Consumer goods (RGM) | Tabular AI, SAP'nin yeni gözdesi |
| 3 | **Batch release asistanı:** Kalite verisini kontrol eder, eksikleri sorar, release önerisi hazırlar | Life sciences | SAP'nin keynote örneği, HITL doğal |
| 4 | **Varlık arıza agent'ı:** Bakım geçmişi + sensör verisinden arıza riski, iş emri önerisi | Enerji (Asset Mgmt) | Somut sayı kolay (duruş saati) |
| 5 | **Mağaza stok dengeleyici:** Mağazalar arası transfer önerisi | Retail (Unified Commerce) | Kolay anlaşılır demo |

**Önerim: #1 KPI Bekçisi**, görev hangi sektöre çıkarsa ona uyarlanabilir. Datasphere/BW tarafı bizim güçlü yanımız, kimse bizim kadar hızlı veri katmanı kuramaz.

```
Kullanıcı ──► Joule ──A2A──► KPI Agent (LangGraph, CF)
                               │
                 ┌─────────────┼──────────────┐
                 ▼             ▼              ▼
          Datasphere SQL   AI Core LLM    Aksiyon (mail,
          (MCP/SQL)        (kök neden)    workflow) ← onay sonrası
```

---

## 3. Dört günlük plan

| Gün | Hedef |
|---|---|
| **Pzt** | Brifing. Öğleden sonra fikir seçimi, ekip rolleri. Akşam: BTP, IAS, AI Core erişimleri çalışıyor mu kontrol et |
| **Sal** | Öğlene kadar **"Merhaba Joule"**: Boş agent Joule'den çağrılıp cevap dönüyor. Bu çalışmadan özellik yazma. Öğleden sonra veri bağlantısı |
| **Çar** | Asıl mantık, HITL, sonucu güzel gösterme. Akşam **özellik dondurma**, demo videosu çek |
| **Per** | Prova, sunum |

**Altın kural:** Önce uçtan uca ince bir hat, sonra kalınlaştır. En çok zaman kaybettiren şey kimlik ve deploy (`04`, `08` dosyaları).

---

## 4. Ekip rolleri (5–6 kişi)

| Rol | İş |
|---|---|
| Agent geliştirici (2) | LangGraph + a2a-sdk, AI Core (`07`, `05`) |
| Joule/BTP entegrasyonu (1) | Capability YAML, destination, IAS, deploy (`08`, `03`, `04`) |
| Veri (1, Oktay) | Datasphere/BW verisi, MCP veya SQL erişimi (`06`) |
| Ürün ve sunum (1) | Hikaye, iş değeri sayısı, demo senaryosu, slaytlar |

---

## 5. Demo ve sunum

- **Hikaye:** Problem (kim acı çekiyor, ne kadar) → canlı demo → sayı → vizyon (Agent Gateway, `09`).
- **Yedek video:** Canlı demo patlarsa oynat. Çarşamba akşamı çek.
- **60 saniye kuralı:** Joule cevabı en fazla 60 saniye bekler. Demo sorusunu buna göre seç.
- **Hazır veri:** Demo verisini önceden yükle, canlıda veri yükleme yapma.

---

## 6. Pazartesiden önce hazır olsun

- [ ] Checklist araçları kurulu (`../NOTLAR.md`)
- [ ] BTP Trial hesabı açık
- [ ] `btp-joule-a2a-pro-code-agent` reposu okundu, mimarisi anlaşıldı
- [ ] 01–09 eğitim dosyaları okundu
- [ ] Datasphere'de demo için kullanılabilecek örnek veri seti fikri
- [ ] Ekiple rol dağılımı konuşuldu

---

## Kaynaklar

- `11-hackathon-arastirma.md` (jüri kriterleri ve kazanan örnekleri, kaynak linkleriyle)
- SAP News (JP), SAP BTP Hackathon 2026. https://news.sap.com/japan/?p=29072
- SAP News (DE), KI-Hackathons als Innovationsmotor. https://news.sap.com/germany/?p=187513
- Techzine, Sapphire 2026 Industry AI. https://www.techzine.eu/blogs/applications/141310/sap-launches-the-autonomous-enterprise-at-sapphire-2026/
- GitHub: https://github.com/SAP-samples/btp-joule-a2a-pro-code-agent
