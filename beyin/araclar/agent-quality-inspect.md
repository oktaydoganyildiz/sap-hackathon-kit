---
tur: arac
alan: ai
urun_surumu: ""
tarih: 2026-10-09
guven: resmi
gozden_gecir: 2027-04-09
---

# SAP agent-quality-inspect

GitHub: https://github.com/SAP/agent-quality-inspect

## Ne yapar
Agentic AI sistemlerini (farklı kaynak/framework'lerden) karşılaştırılabilir istatistiksel sonuçlarla benchmark eden açık kaynak değerlendirme paketi (ICLR 2026, "TED — Talk, Evaluate, Diagnose: User-aware Agent Evaluation with Automated Error Analysis"). Değerlendirmenin özü: kullanıcı doğal dilde subgoal'ler tanımlar (ör. "Agent, timestamp aldıktan sonra search_messages çağırmalı" veya "Agent son cevabı ve gerekçesini açıkça belirtmeli"); bunlar `EvaluationSample` içindeki `SubGoal` objeleri olarak ground truth sayılır. Değerlendirme sırasında her turn için LLM-as-a-judge, agent trace'inde (`AgentDialogueTrace`: turn'ler, ara araç çağrıları, agent cevapları) ilgili subgoal'in karşılanıp karşılanmadığına karar verir; bu yargılar ilerleme eğrilerine ve metriklere dönüştürülür.

Ürettiği metrikler:
- **AUC (Area Under the Curve)**: ajan hedefe ne kadar hızlı ilerliyor.
- **PPT (Progress Per Turn)**: turn başına ortalama ilerleme.
- **pass@k / pass^k**: görev başarısı ve güvenilirlik.

Ek özellikler: expert/non-expert kullanıcı persona'larıyla user-proxy simülasyonu; otomatik hata kategorizasyonu (error analysis) ile ajanın nerede/neden başarısız olduğunu gösteren modül; sonuçları görselleştiren leaderboard UI (`demo/agent-eval-dashboard`). Tau2Bench ve ToolSandbox için hazır runner entegrasyonları mevcut; `BaseAdapter`/`BaseSession` sınıflarını genişleterek kendi agent trace'ini bağlayabilirsin.

## Bende durumu
yeni — envanterde agent/ajan kalite değerlendirme veya benchmark amaçlı kurulu bir araç bulunmuyor. Mevcut sap-skills/mcp envanteri geliştirme ve bağlantı odaklı (datasphere, hana, bw, abap, btp, sac); bu araç geliştirme sonrası kalite/performans ölçümü katmanını kapatıyor, mevcut kurulumlarla çakışma yok.

## Agentic BI'a katkısı
Datasphere/SAC/BW üzerine kurulan agentic BI ajanlarının (ör. doğal dil sorgudan subgoal'e dayalı analiz yapan, araç çağıran ajanlar) kalitesini ölçmek için kullanılabilir: subgoal tanımları ("agent get_sales_data çağırmalı, sonra calculate_variance uygulamalı, sonuçları gerekçeli sunmalı") ile gerçek agent trace karşılaştırılıp AUC/PPT skorları ve hata kategorileri (yanlış araç sırası, eksik gerekçe, hatalı sonuç) elde edilebilir. Kendi Claude tabanlı BI ajanını `BaseAdapter` ile entegre edip regresyon/kalite testine sokmak mümkün; expert/non-expert persona ayrımı, ajanın farklı kullanıcı seviyelerinde nasıl davrandığını da test etmeye imkân verir.

## Kurulum
```
pip install git+https://github.com/SAP/agent-quality-inspect.git
```

## Dikkat
- Apache-2.0 lisans, son push 2026-06-26, 79 yıldız — aktif ama yeni/küçük bir proje (ICLR 2026 paper'ıyla birlikte yayınlandı); saha tecrübesi henüz sınırlı olabilir.
- Metrikler ve user-proxy için Azure OpenAI API erişimi (`AZURE_API_VERSION`, `AZURE_API_BASE`, `AZURE_API_KEY`) `.env` dosyasında gerekiyor — agent trace verisi (dolayısıyla potansiyel kurumsal/iş verisi) bu şekilde bulut LLM'e gönderiliyor; kimlik bilgisi ve veri paylaşımı risklerini değerlendir.
- Tau2Bench/ToolSandbox runner'larındaki RapidAPI servisleri üçüncü taraf, kullanıcı aboneliğine dayalı servisler; SAP bunları sağlamıyor, lisanslamıyor veya yetkilendirmiyor.
- README'de "Known Issues: No known issues" yazıyor — ancak bu proje yeni olduğundan dikkatli pilot test önerilir.

## Benzerleri
- Genel amaçlı LLM/agent değerlendirme çerçeveleri (ör. RAGAS, DeepEval, LangSmith Evaluation) — SAP'ye özgü değil, subgoal-tabanlı TED metodolojisini içermiyor.

([[kaynaklar/2026-10-09-sap-agent-quality-inspect]])
