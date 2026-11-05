# 09 · Agent Gateway (Inbound A2A)

> **Tek cümle:** Agent Gateway, dışarıdaki bir agent'ın (Copilot, Amazon Quick, kendi yazdığın bir şey) SAP'nin Joule agent'larını güvenli şekilde çağırdığı tek giriş kapısıdır.

---

## 1. Ne işe yarar?

`01-a2a.md`'de iki yön vardı. Bu dosya **ters yön**:

| | Outbound (BYOA) | Inbound (Agent Gateway) |
|---|---|---|
| Kim çağırıyor | Joule | Dışarıdaki agent |
| Kim cevap veriyor | Bizim agent | SAP'nin Joule agent'ı |
| Nasıl bağlanıyor | Joule capability + `agent-request` + destination | Agent Gateway |
| Hackathonda | **Asıl iş bu** | Vizyon olarak bahset |

**Benzetme:** Agent Gateway, SAP binasının resepsiyonu. Dışarıdan gelen kim olursa olsun önce kimliğini gösterir, listede adı varsa ilgili odaya yönlendirilir.

---

## 2. Durum (Kasım 2026)

- **Inbound A2A, Ekim 2026'da GA oldu.** Dış agent'lar Agent Gateway üzerinden SAP Agent'larını çağırabiliyor.
- **Agent Gateway üzerinden outbound** (SAP agent'larının dış agent'lara iş devretmesi, dış MCP tool'larını çağırması) henüz **yol haritasında**, GA değil.
- Karıştırma: Joule'nin capability üzerinden bizim agent'ı çağırması (BYOA, `01-a2a.md` §4.1) **ayrı bir mekanizma**, Joule Development Guide'da anlatılıyor. Gateway'in outbound tarafının GA olmaması, BYOA'yı etkilemiyor.

---

## 3. Akış

```
Dış agent (örn. Copilot)
   │ 1. ARD ile keşif: "Hangi SAP agent'ları var?"
   │    (Agentic Resource Discovery, teknik token yeter)
   │ 2. AgentCard'dan A2A endpoint'i al
   │ 3. A2A isteği + KULLANICI token'ı
   ▼
┌──────────────────────────┐
│ Agent Gateway            │  token doğrula → tenant bul →
│ (SAP yönetir)            │  ACL kontrol: bu client bu agent'ı çağırabilir mi?
└────────────┬─────────────┘
             ▼
     Joule Agent (low-code veya pro-code)
             │
             ▼
     SAP sistemleri (kullanıcının yetkisiyle)
```

- Taşıma: A2A 0.3.0, HTTP+JSON.
- Cevap: senkron, ya da uzun işlerde verilen callback URL'ye asenkron.
- Tüm çağrılar SAP Cloud ALM'de loglanır.
- İstersen önüne **Integration Suite** konur: rate limiting, monitoring, governance.

---

## 4. Kurulum sırası (müşteri admin'i yapar)

Sıra önemli, her adım bir öncekine bağlı:

1. **Kayıt:** Dış client, SAP for Me'de "Agent Gateway Consumer" olarak kaydedilir. Kayıt tek başına yetki vermez.
2. **Kimlik:** SAP Cloud Identity Services'ta client için bir OIDC "Agent Identity" oluşur.
3. **Trust:** IAS App2App trust kurulur.
4. **Yetki (ACL):** Bu client'ın hangi SAP agent'larını çağırabileceği listelenir.

**Önemli kural:** Keşfetmek, çağırma izni vermez. Dış agent da kullanıcının yetkisinden fazlasına erişemez.

---

## 5. Hackathonda nasıl kullanırız?

Muhtemelen kurmayacağız, çünkü SAP for Me kaydı ve admin işi gerekiyor. Ama sunumda bir vizyon cümlesi olarak işe yarar:

> "Agent'ımızı Joule'ye bağladık. İleride aynı agent, Agent Gateway üzerinden Microsoft Copilot'tan da güvenle çağrılabilir."

---

## 6. Takılma noktaları

| Belirti | Sebep |
|---|---|
| Agent keşfediliyor ama çağrı reddediliyor | ACL'de bu client'a izin verilmemiş |
| 401 | Token IAS'tan değil ya da `aud` yanlış (bkz. `04-kimlik-ias.md`) |
| Kullanıcı bazı verileri göremiyor | Normal: yetki, kullanıcı ile agent yetkisinin kesişimi |
| Gateway üzerinden dış agent'a iş devredilemiyor | Outbound henüz GA değil |

---

## 7. Neleri bilmen lazım

- [ ] Agent Gateway inbound mu outbound mu?
- [ ] Ekim 2026 GA'sı neyi kapsıyor, neyi kapsamıyor?
- [ ] BYOA ile Agent Gateway outbound'u farkı ne?
- [ ] Kurulumun dört adımı ne, sırası neden önemli?
- [ ] Keşif neden izin anlamına gelmiyor?

---

## Kaynaklar

- SAP Architecture Center News, Inbound A2A interoperability via Agent Gateway (27.10.2026). https://architecture.learning.sap.com/news/2026/10/27/a2a-agent-gateway-interoperability
- SAP Architecture Center, Integrating Joule Agents into Your Ecosystem (Inbound A2A). https://architecture.learning.sap.com/docs/ref-arch/fe0d1d
- SAP Architecture Center, A2A and MCP for Interoperability. https://architecture.learning.sap.com/docs/ref-arch/76ec36
- SAP Architecture Center, Third-Party A2A & Token Exchange. https://architecture.learning.sap.com/docs/ref-arch/f4a2c8
- SAP Developers, Agent Gateway konsept sayfası. https://developers.sap.com/concepts/agent-gateway
- Techzine, TechEd 2026 Joule güncellemesi. https://www.techzine.eu/blogs/applications/145290/major-sap-joule-update-prepares-agents-for-complex-processes/
