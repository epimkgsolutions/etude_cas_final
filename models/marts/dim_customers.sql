total_orders       = COUNT(DISTINCT order_id)     -- Loyauté
lifetime_revenue   = SUM(net_revenue)             -- Valeur client ⭐
days_since_last_order = DATE_DIFF(today, max(order_date))  -- Récence

customer_segment = CASE
  WHEN total_orders >= 5 THEN 'Loyal'    -- VIP
  WHEN total_orders >= 2 THEN 'Regular'  -- Engagés
  ELSE 'One-Time'                         -- À relancer
END
```

**Cas d'usage** :
```
Analyse : "Qui sont nos clients à risque de partir ?"
Réponse : customer_segment='Regular' ET recency_segment='At Risk'
```

---

### **6. mart_monthly_sales** (Agrégat pour Dashboard)

**Définition** : **1 ligne = 1 mois × 1 magasin × 1 catégorie**

**Grain** : Pré-agrégé au niveau mensuel
```
sales_month=2016-01-01, store_id=2, category_id=1
  → num_orders=5, total_net_revenue=$4999.50, discount_rate=0.08