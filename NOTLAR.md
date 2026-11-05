# SAP Industry AI Hackathon: Notlar (temiz kopya)

Kaynak: SAP'den gelen mail ve ön hazırlık PDF'i. Kişisel ID, e-posta ve SAP iç dokümanları bu kopyada yok.

## Etkinlik

- **Ad:** SAP Industry AI Hackathon (Partner Hackathon)
- **Tarih:** Pzt 9.11. – Per 12.11.2026
- **Yer:** SAP Labs Munich Campus, MUE03
- **Organizasyon:** Industry AI CTO ekibi. Görev brifingi Pazartesi.
- **Biz:** Fairconsult24-7, dış partner, 5 kişi.
- Binada bir SAP rehberi hep eşlik ediyor.

## Program

| Gün | Ne |
|---|---|
| Pzt 9.11. | Resepsiyonda 10:00 buluşma. Onboarding ve görev brifingi. |
| Sal 10.11. | Hacking günü. Kısa sabah check-in. |
| Çar 11.11. | Hacking günü. Kısa sabah check-in. |
| Per 12.11. | Sonuçların sunumu. |

- Her gün check-in, badge. Fotoğraflı kimlik şart.
- Öğle yemeği SAP kafeteryada.

## Cihaz kuralı

- Geçerli **VDI** erişimi olan kendi cihazını getirir. VDI yoksa SAP IT odada laptop verir.
- VDI = SAP sunucusunda uzak Windows masaüstü. Kod büyük ihtimalle orada yazılır; araçlar orada kurulu olmalı.

## Hesap türleri

- **S-User:** SAP Support Portal kullanıcısı.
- **P-User:** SAP ID, EWA aktivasyonuyla açılır.
- **C-User:** Dış çalışana verilen SAP iç kullanıcısı. İç ağ, VDI, `github.tools.sap` için gerekli.
- P-User kaydında "email already linked to SAP Universal ID" hatası çıkarsa: account.sap.com → kimlik → unlink. **Hata gelmeden yapma**, S-User'ı ayırır.

## Ön hazırlık listesi (SAP'nin PDF'inden)

| Araç | Kontrol |
|---|---|
| SAP mail + IAS "Activate User Profile" | Outlook |
| `github.tools.sap` erişimi | tarayıcı |
| Git, GitHub CLI | `git --version`, `gh --version` |
| Hyperspace LLM proxy (`hai`) | `hai --version` (SAP iç ağı/VPN) |
| Claude Code (Hyperspace üzerinden) | `claude --version` |
| VS Code (telemetry kapalı) | — |
| Python 3, pip | `python3 --version`, `python3 -m pip --version` |
| Podman Desktop | `podman --version` |
| BTP CLI | `btp --version` |
| CF CLI | `cf version` |
| Joule Studio CLI (classic) | `joule -V` |
| kubectl | `kubectl version --client` |
| Kyma CLI (opsiyonel) | `kyma version` |
| BTP Trial hesabı | https://account.hanatrial.ondemand.com, Tour of SAP BTP Trial |

**Ek (araştırmadan):** PDF'teki "Joule Studio CLI" linki `@sap/joule-studio-cli` paketine gidiyor. Bu paket iki komut kurar: `joule` (legacy, classic) ve `jl` (Joule Work CLI, yeni Joule Studio). Kontrol: `joule -V` ve `jl version`. Node 20.12–24. Eski `@sap/joule-work-dev-cli-early-adopters` kuruluysa önce kaldır. Bkz. `katalog/01-joule-studio.md`.

## Hackathon konusu (tahmin)

İpuçları SAP'de AI agent geliştirmeyi gösteriyor: "Foundations & First Agent", "FDE Enablement for AI Agents", Joule Studio CLI, BTP/CF/Kyma, Claude Code, Python, Podman. Gerçek görev Pazartesi brifingte.

## Brifingte sorulacaklar

1. Görev ne, ne teslim ediliyor (demo, kod, sunum)?
2. Ortam: BTP tenant, AI Core, Joule Studio hazır mı? Yeni `jl` mi classic `joule` mı?
3. Jüri kriterleri.
4. Kod ve fikir (IP) kime ait?
5. Takım düzeni.
6. Sunum formatı ve süresi.
7. VDI'dan github.com erişimi var mı? Üçüncü taraf skill/MCP kurulabilir mi?
