# Sorun giderme kartı (belirti → olası neden → komut)

Hackathonda en çok zaman giriş, deploy ve log okumaya gider. Önce `kurulum\kontrol.ps1` çalıştır; araç eksikse burası değil, kurulum sorunu.

Komutlardaki `<...>` yerleri ortamdan doldur. Emin değilsen `<araç> <komut> --help`. "doğrulanmadı" işaretli satırlar sahada kontrol edilecek.

## 1. Giriş (login)

| Belirti | Olası neden | Ne yap |
|---|---|---|
| `btp login --sso` "CLI server URL" sorusunda takılıyor, `Reading input failed: EOF` | Claude'un içinden (etkileşimsiz) çalıştırıldı | URL'yi ver: `btp login --sso --url https://cli.btp.cloud.sap --subdomain <global-account-subdomain>`; çıkan linki tarayıcıda tamamla. Ya da komutu kendi terminalinde çalıştır. (SAP Beyni dersi, btp CLI 2.116) |
| `btp` "Unknown session" | Oturum düştü | Aynı `btp login --sso --url ... --subdomain ...` |
| `cf login --sso` "Unable to authenticate" (Claude içinden) | Passcode etkileşimli soruluyor | Tarayıcıda `https://login.cf.<region>.hana.ondemand.com/passcode` → kodu al → `cf login -a https://api.cf.<region>.hana.ondemand.com --sso-passcode <KOD>`. Kod tek kullanımlık. (SAP Beyni dersi) |
| `cf target` org/space yok | Doğru subaccount'a / space'e yetki yok | `cf orgs`, `cf spaces`; yoksa kaptana / SAP mentora space rolü sor |
| `jl` komutları "not logged in" | Backend oturumu yok | `jl login <url>` (URL SAP'den gelir, ya da `JL_URL`); kontrol `jl info` |
| `joule deploy` yetki hatası | IAS'ta `Cli2Joule` client / App2App rolü eksik | `egitim/08-joule-cli-capability.md`, `beyin/ai/baglanti/joule-cli-login-sorunlari.md` |
| `gh` github.tools.sap'ta "not logged in" | Enterprise host ayrı oturum ister | `gh auth login --hostname github.tools.sap`; PowerShell: `$env:GH_HOST='github.tools.sap'` |
| `git push` 403 | Repoya yazma yetkin yok / yanlış hesap | `gh auth status --hostname github.tools.sap`; kaptana collaborator eklet |

## 2. Deploy

| Belirti | Olası neden | Ne yap |
|---|---|---|
| Yol A: `jl solution deploy` hata veriyor | `solution.yaml` / asset tanımı geçersiz | Önce `jl solution validate` (otomatik düzeltme seçeneği var); sonra deploy |
| Yol A: hangi solution'lar var bilinmiyor | — | `jl solution list`; takım reposu solution'ın Git reposuysa `jl solution clone <ad>` |
| Yol B: `cf push` / `cf deploy` "staging failed" | Buildpack, Node/Python sürümü, eksik bağımlılık | `cf logs <app> --recent`; manifest'te `buildpacks` ve `memory`; Node 20.12–24 |
| Yol B: `.mtar` deploy edilmiyor | MTA plugin yok | `cf install-plugin multiapps`; build: `mbt build` |
| Servis bağlanmıyor (AI Core, destination) | Entitlement subaccount'a atanmamış | `btp list accounts/entitlement --subaccount <id>`; global account'ta olup subaccount'ta olmayan kullanılamaz (SAP Beyni dersi) |
| AI Core'da model / kota görünmüyor | Service key yok | AI Core instance'ına service key oluştur; Generative AI Hub sadece `extended` planda (SAP Beyni dersi) |

## 3. Çalışma zamanı ve loglar

| Belirti | Olası neden | Ne yap |
|---|---|---|
| Yol A: agent cevap vermiyor / yanlış tool çağırıyor | Talimat ya da tool tanımı | `jl solution traces` (son çalıştırmalar, span detayı), `jl solution observe` (özet metrikler) |
| Yol B: agent 500 dönüyor | Uygulama hatası | `cf logs <app> --recent`; canlı izleme `cf logs <app>` |
| Kyma'da çalışan parça hata veriyor | Pod çöküyor | `kubectl get pods -n <ns>`, `kubectl logs <pod> -n <ns> --tail=200`, `kubectl describe pod <pod> -n <ns>` |
| Joule "zaman aşımı" / cevap gelmiyor | Agent 60 sn'yi aşıyor (Joule beklemiyor) | Demo sorusunu küçült, tool sayısını azalt, LLM adımlarını kısalt (`egitim/10` §5) |
| Joule agent'ı hiç çağırmıyor | Capability / destination / A2A kartı | Yol A: deploy sonrası Joule'a kayıt otomatik — `jl a2a card` ile kart dönüyor mu bak. Yol B: destination adı + `joule deploy` capability, `a2a-inspector` ile kart kontrolü |
| Agent'ın Agent Card'ı | — | `jl a2a card`; mesaj testi `jl a2a message "<metin>"` |
| 401/403 tool çağrısında | Kullanıcı yetkisi ∩ agent yetkisi; principal propagation / teknik kullanıcı | Hangi kimlikle çağrıldığını logla; `egitim/04-kimlik-ias.md`, `beyin/btp/kavramsal/mcp-agent-auth-modlari.md` |
| AI Core kotası bitti / demo provası | — | Yol B: `btp-joule-a2a-pro-code-agent` mock-response extension (`egitim/07`) |

## 4. Takım ve Git

| Belirti | Olası neden | Ne yap |
|---|---|---|
| Merge çakışması | İki kişi aynı dosyaya dokundu | `git pull --rebase origin main`, çakışan dosyanın sahibine sor; sahiplik ihlali ise `takip` skill'i raporlar |
| main bozuldu | Son merge entegrasyonu kırdı | `git log --oneline -5` → sorumlu commit'i `git revert <sha>`; entegrasyon issue'suna yaz |
| `gh issue create --assignee` hata | Kişi repoya collaborator değil | Kaptan ekler; ya da `TASKS.md` yedeği |
| Claude başka klasöre yazmak istiyor | Görev sınırı belirsiz | Dur, issue aç, sahibine ata (`gorevim` kuralı) |

## 5. Hâlâ çözülmediyse

30 dk kuralı: takıma söyle. 60 dk: SAP mentoruna git — hata mesajının **tam metni**, çalıştırdığın komut ve hangi yol (A/B) ile.
