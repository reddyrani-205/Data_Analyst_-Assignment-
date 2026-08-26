
# 🍫 Chocolate Sales — Statistics, Visualization & EDA (Week 4 Assignment)

## 📌 Objective
This project applies core statistics, data visualization, and exploratory data
analysis (EDA) techniques to a real-world chocolate sales dataset using Python,
Pandas, Matplotlib, and Seaborn.

## 📊 Dataset
- **File:** `chocolate_cleaned.csv`
- **Records:** 3,282 sales transactions
- **Columns:** Sales Person, Country, Product, Date, Amount, Boxes Shipped
- **Countries covered:** 6 (Australia, UK, India, USA, Canada, New Zealand)
- **Data quality:** 0 missing values, 0 duplicate rows found on inspection

## 🧮 Key Statistical Findings
| Metric | Value |
|---|---|
| Mean Sales Amount | 6,030.34 |
| Median Sales Amount | 5,225.50 |
| Mode Sales Amount | 2,303 |
| Variance | 19,307,109.64 |
| Standard Deviation | 4,393.99 |
| Correlation (Amount vs Boxes Shipped) | -0.0132 (negligible) |
| Outliers detected (IQR method) | 50 transactions |
| P(random sale is from India) | 16.82% |

## 🏆 Top Performers
- **Top-selling product:** Smooth Sliky Salty
- **Top-selling country:** Australia (₹3.65M total revenue)
- **Top sales person:** Ches Bonnell

## 📈 Visualizations Included
**Matplotlib:** Line Chart · Bar Chart · Pie Chart · Histogram · Scatter Plot
**Seaborn:** Count Plot · Box Plot · Heatmap · Pair Plot

9 charts total, each with a title, labeled axes, and a written explanation.

## 🔍 Key Insights
1. Boxes shipped and sales amount show almost no correlation — pricing varies
   by product, not by shipment volume.
2. Revenue is fairly balanced across 6 countries but Australia leads at ~3.65M,
   ~600K ahead of the lowest (New Zealand at ~3.04M).
3. A small group of top products and sales people drive a disproportionate
   share of the 3,282 total transactions — a classic 80/20 pattern.

## 💡 Business Recommendations
1. Prioritize inventory and marketing spend on the top product ("Smooth Sliky
   Salty") and top market (Australia), since they drive the largest revenue share.
2. Since box volume doesn't correlate with revenue (r = -0.01), focus sales
   strategy on higher-value products rather than pushing bulk box quantities.
3. Review the 50 flagged outlier transactions to confirm they're genuine large
   orders and not data-entry errors, before using them in forecasting.

## 🛠️ Tools Used
Python 3 · Pandas · NumPy · Matplotlib · Seaborn

## 📂 Files in This Repository
| File | Description |
|---|---|
| `week4_chocolate_eda.ipynb` | Full notebook: code, outputs, charts, and explanations |
| `chocolate_cleaned.csv` | Source dataset (3,282 rows) |
| `README.md` | Project overview (this file) |

## ▶️ How to Run
1. Install dependencies: `pip install pandas numpy matplotlib seaborn`
2. Open `week4_chocolate_eda.ipynb` in Jupyter Notebook / JupyterLab
3. Run all cells top to bottom
