---
tur: kaynak
alan: ai
urun_surumu: ""
tarih: 2026-10-09
guven: resmi
kaynak: https://github.com/SAP/agent-quality-inspect
gozden_gecir: 2027-04-09
---

# SAP/agent-quality-inspect

Link: https://github.com/SAP/agent-quality-inspect

Yazı türü: arac

## Özet
- SAP'nin ICLR 2026 bildirisine dayanan açık kaynak (Apache-2.0) agentic AI değerlendirme paketi ("TED: Talk, Evaluate, Diagnose").
- Değerlendirme, kullanıcının doğal dilde tanımladığı subgoal'leri agent trace'ine karşı LLM-as-a-judge ile kontrol eder.
- Ürettiği metrikler: AUC (Area Under the Curve), PPT (Progress Per Turn), pass@k, pass^k.
- Expert/non-expert kullanıcı persona'larıyla user-proxy simülasyonu destekler.
- Otomatik hata kategorizasyonu (error analysis) ve sonuçları görselleştiren leaderboard UI (demo/agent-eval-dashboard) içerir.
- Tau2Bench ve ToolSandbox için hazır runner entegrasyonu var; kendi ajanını BaseAdapter/BaseSession ile bağlayabilirsin.
- Metrikler ve user-proxy için Azure OpenAI API kimlik bilgisi (.env) gerekiyor.
- Bazı runner'lar (RapidAPI) üçüncü taraf, SAP tarafından sağlanmayan/lisanslanmayan servisler.
- 79 yıldız, son push 2026-06-26, "Known Issues: No known issues".

## Beslediği sayfalar
- [[araclar/agent-quality-inspect]]
