---
tur: arac
alan: ai
urun_surumu: ""
tarih: 2026-10-09
guven: resmi
gozden_gecir: 2027-04-09
---

# Joule A2A Agent Toolkit (Claude Code plugin)

## Ne yapar
Claude Code plugin'i olarak çalışır; SAP Joule'a A2A (Agent-to-Agent, JSON-RPC 2.0 üzerinden v0.3.0 protokolü) ile bağlanan özel agent'lar inşa eder, test eder ve BTP Cloud Foundry'ye deploy eder. 4 skill içerir:
- **joule-a2a-agent**: "build an agent for Joule" gibi tetikleyicilerle LangGraph tabanlı A2A agent'ı (Express veya CAP, TS/Python), CF manifest/MTA ve Joule capability YAML'ını scaffold eder.
- **btp-cli**: BTP subaccount/entitlement/servis/güvenlik yönetimi için `btp` komutları üretir.
- **cf-cli**: `cf push`, servis binding, route yönetimi için `cf` komutları üretir.
- **joule-cli**: Joule capability derleme/deploy için `joule` CLI komutları üretir.

Komutlar: `/sap-a2a-agent-toolkit:create-agent`, `/sap-a2a-agent-toolkit:create-destination`, `/sap-a2a-agent-toolkit:deploy-agent` (tek komutla CF push/MTA deploy + BTP destination + Joule capability).

LLM tarafı SAP GenAI Hub (AI Core) üzerinden `@sap-ai-sdk/langchain` OrchestrationClient ile sağlanır.

## Bende durumu
yeni — ENVANTER'da bu plugin kurulu değil. Dikkat: ENVANTER'da kullanıcı tanımlı (sap-skills-yonetim/skill) olarak zaten **btp-cli** ve **cf-cli** adlı skill'ler mevcut; bu plugin kurulursa aynı isimde ikinci bir btp-cli/cf-cli skill kaynağı oluşur — ENVANTER'daki "aynı server adı birden fazla kaynakta" uyarısına benzer bir çakışma riski doğar, hangisinin tetikleneceği test edilmeden netleşmez. **joule-a2a-agent** ve **joule-cli** skilleri ise envanterde karşılığı olmayan tamamen yeni yetenekler.

## Agentic BI'a katkısı
S/4HANA, BW veya Datasphere verisine dayalı özel iş mantığını (ör. sipariş durumu sorgulama) LangGraph agent olarak paketleyip Joule'un doğal dil arayüzüne A2A protokolüyle bağlamayı sağlar — agentic BI zincirinin "Joule ile konuşma" ucunu kapatır. BTP destination + capability deploy adımları otomatikleştiği için kurulum süresi kısalır.

## Kurulum
```bash
claude --plugin-dir <path-to-sap-a2a-agent-toolkit>
```
(Ardından `cf login` ve `joule login` gerekir.)

## Dikkat
- Lisans: Apache-2.0. Son push: 2026-04-21. 38 yıldız — küçük ölçekli, resmi ama "samples" etiketli depo; üretim desteği sınırlı olabilir, güncellik takip edilmeli (gözden geçirme: 2027-04-09).
- Ön koşullar ağır: cf CLI v8, Joule CLI (`@sap/joule-studio-cli`), Joule App2App IAS rol ataması, AI Core + Destination servisli BTP subaccount, Node.js 24.x, CAP agent'lar için `mbt` ve `multiapps` CF plugin'i.
- Namespace zorunluluğu: Joule deploy için capability namespace **mutlaka `joule.ext`** olmalı — aksi halde deploy edilen capability Joule tarafından tanınmaz.
- Üçüncü taraf/örnek bir toolkit'in `cf`/`joule`/BTP kimlik bilgilerine erişimi olacağından, kurulum öncesi kod/komut üretimini inceleyip hangi credential'ların nereye gittiğini doğrulamak gerekir.
- Aynı isimli btp-cli/cf-cli skill çakışması riski (bkz. Bende durumu).

## Benzerleri
- Kullanıcıda zaten kurulu kullanıcı tanımlı `btp-cli` ve `cf-cli` skilleri (sap-skills-yonetim/skill) — bu plugin'in btp-cli/cf-cli bileşenleriyle örtüşüyor.

([[kaynaklar/2026-10-09-joule-a2a-agent-toolkit]])
