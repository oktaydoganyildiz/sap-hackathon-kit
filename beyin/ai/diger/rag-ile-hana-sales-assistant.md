---
tur: tarif
alan: ai
kategori: diger
urun_surumu: ""
tarih: 2026-10-10
guven: topluluk
gozden_gecir: 2027-04-10
---

# RAG ile HANA Cloud Üzerinde Sales Assistant Kurulumu

## Use case
HANA calculation view'daki satış verilerine dayanarak doğal dilde soru sorup ("Q2'de en çok satan ürün kategorisi hangisiydi?") RAG (Retrieval-Augmented Generation) ile bağlamsal, veriye dayalı cevap üreten bir AI asistanı kurmak; veri HANA dışına taşınmaz.

## Varyantlar

### HANA Vector Engine + Flask + OpenAI + Streamlit (RAG)
Adımlar:
1. Ön koşullar: Python 3.9+, SAP Business Application Studio (BAS), CF CLI, HANA Cloud instance, OpenAI API key. **BAS dev space, HANA Cloud instance ile aynı region'da olmalı**, aksi halde bağlantı hatası alınır.
2. HANA Cloud'da embedding tablosu oluştur (HANA Cloud Vector Engine, `REAL_VECTOR` tipi ile harici vector DB gerekmiyor):
```sql
CREATE TABLE SALES_EMBEDDINGS (
    TRANSACTION_ID NVARCHAR(50),
    TEXT NVARCHAR(5000),
    EMBEDDING REAL_VECTOR(1536)
);
```
3. Calculation view verisini satır satır metne çevirip (`"Transaction {id} in {region} sold {product} for {amount} on {date}"`) OpenAI `text-embedding-3-small` ile vektörleştir, HANA tablosuna yaz:
```python
cursor.execute('SELECT TRANSACTION_ID, REGION, PRODUCT, SALES_AMOUNT, SALE_DATE FROM "schema"."cv_sales_test"')
for row in cursor.fetchall():
    text = f"Transaction {row[0]} in {row[1]} sold {row[2]} for {row[3]} on {row[4]}"
    embedding = client.embeddings.create(model="text-embedding-3-small", input=text).data[0].embedding
    cursor.execute('INSERT INTO "schema"."SALES_EMBEDDINGS" (TRANSACTION_ID, TEXT, EMBEDDING) VALUES (?, ?, ?)',
                   (row[0], text, embedding))
conn.commit()
```
4. RAG query fonksiyonu: kullanıcı sorusunu embedding'e çevir, HANA'dan tüm embedding'leri çek, uygulama tarafında (sklearn) cosine similarity ile en alakalı top-k transaction'ı bul, bunları context olarak prompt'a ekleyip `gpt-4o-mini` ile cevap üret:
```python
query_embedding = openai_client.embeddings.create(model="text-embedding-3-small", input=user_query).data[0].embedding
# HANA'dan SALES_EMBEDDINGS satırlarını çek, blob'u unpack et, cosine_similarity ile sırala, top_k context oluştur
prompt = f"Based on the following transactions:\n{context}\nAnswer: {user_query}"
response = openai_client.chat.completions.create(model="gpt-4o-mini", messages=[{"role":"user","content":prompt}])
```
5. Flask API (`/query` POST endpoint) RAG fonksiyonunu çağırır; HANA credential'larını Cloud Foundry'de `VCAP_SERVICES`'ten, lokalde `.env`'den okur (service adı HANA içeren anahtar aranarak bulunur).
6. Flask app'i Cloud Foundry'ye push et, HANA service instance'a bind et (credential'lar `VCAP_SERVICES`'e otomatik enjekte edilir):
```bash
cf services
cf push "app-adi" -f manifest.yml
cf bind-service "app-adi" "hana-service-adi"
cf restage "app-adi"
cf env "app-adi"
cf logs "app-adi" --recent
```
7. Frontend için Streamlit ile basit chat arayüzü (lokal) — SAP Fiori veya başka bir web frontend ile değiştirilebilir:
```bash
pip install streamlit requests
# streamlit run app.py -> http://localhost:8501, /query endpoint'ine POST atar
```

Ne zaman seçilir: Mevcut HANA calculation view'ları değiştirmeden/veriyi HANA dışına taşımadan doğal dil sorgusu + LLM tabanlı özetleme eklemek istendiğinde; harici vector DB kurmadan HANA Cloud Vector Engine'i kullanmak istendiğinde; hızlı prototip (Flask+Streamlit) yeterli olduğunda.

([[kaynaklar/2026-10-10-generative-ai-hana-cloud-rag-sales-assistant]])

## Tuzaklar
- BAS dev space ile HANA Cloud instance farklı region'daysa bağlantı başarısız olur; ikisinin aynı region'da olması gerekiyor.
- Örnekteki cosine similarity hesaplaması HANA içinde değil, Python/sklearn tarafında yapılıyor — her sorguda tüm embedding'ler belleğe çekiliyor; büyük veri setlerinde performans sorunu oluşur. HANA'nın native vector arama/`COSINE_SIMILARITY` fonksiyonları değerlendirilmeli.
- `VCAP_SERVICES`'ten credential okurken servis adı (ör. `hdi_db`) kod içinde sabit kodlanmış olabilir; CF'deki gerçek service instance adıyla eşleşmezse fallback'e düşüp bağlantı hatası verir.
- OpenAI gibi harici bir LLM'e kurumsal veri/embedding gönderiliyor — veri güvenliği/uyumluluk (data residency) açısından değerlendirilmeli; SAP içi alternatifler (SAP AI Core/Joule) düşünülebilir.
- Her transaction ayrı ayrı embedding API çağrısıyla işleniyor (batch yok) — büyük veri setlerinde maliyet ve süre artar.

## İlgili
(yok)
