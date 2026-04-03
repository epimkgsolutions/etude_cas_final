price_segment = CASE
  WHEN list_price < 500 THEN 'Budget'
  WHEN list_price < 1500 THEN 'Mid-Range'
  WHEN list_price < 3000 THEN 'Premium'
  ELSE 'Ultra-Premium'
END
```

**Pourquoi** : Permet à Power BI de répondre = *"Quel segment génère le plus de CA ?"*

---

### **4. dim_stores** (Dimension magasin)

**Définition** : **1 ligne = 1 magasin** (3 stores)

**Simple & immutable** : Les attributs ne changent pas → **SCD Type 0**
```
store_id=1 → Santa Cruz, CA (West Coast)
store_id=2 → Baldwin, NY (Northeast)  ← 68% du CA total
store_id=3 → Rowlett, TX (South)