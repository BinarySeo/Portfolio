# Wonsuk Seo — Data Analyst

I turn messy business data into decisions: cleaning and modeling it in **SQL** and **Python**,
summarizing it in **Excel** and **Tableau** dashboards, and writing up what the numbers mean
for the people who have to act on them. Lately I've been building small automated pipelines
that pull data from APIs, analyze it, and deliver a weekly answer instead of a one-off report.

**Tools:** SQL (MySQL — CTEs, window functions) · Python (pandas, NumPy, SciPy, seaborn, Plotly, scikit-learn) ·
Excel (pivot tables, slicers, dashboards) · Tableau · Streamlit · Google Analytics 4 API · SQLite · Google Sheets / Apps Script ·
Data quality & testing (SQL checks, pytest, GitHub Actions CI) · Git

---

## Projects at a glance

| Project | Question it answers | Skills shown |
|---|---|---|
| [ShopSignal — Etsy market & traffic analytics](#shopsignal--etsy-market--traffic-analytics) | What should a small shop change this week to get more traffic? | Python, GA4 API, SQLite, TF-IDF, Streamlit, LLM summaries |
| [RFM Customer Segmentation](#rfm-customer-segmentation-sql) | Which customers should marketing target before the November peak? | SQL, CTEs, `NTILE` window functions, segmentation |
| [E-Commerce Sales Dashboard](#e-commerce-sales-dashboard-excel) | How are sales, channels, returns and cancellations trending? | Excel data cleaning, pivot tables, slicers, dashboard design |
| [World Happiness Report 2021](#world-happiness-report-2021-python) | Which factors move national happiness, and does it differ by region? | pandas, correlation & p-values, seaborn, choropleth maps |
| [Survey Sampling & Campaign Analysis](#survey-sampling--email-campaign-analysis-sql--tableau) | Who should receive a pilot survey, and why did one email campaign outperform? | SQL sampling with `DENSE_RANK`, Tableau, CTR/conversion analysis |
| [Case studies: production tools](#case-studies-production-data-tools) | Two internal tools in daily use (private code) | Data modeling, automation, testing |

---

## ShopSignal — Etsy market & traffic analytics
**Python · GA4 Data API · SQLite · scikit-learn · Streamlit · OpenAI** — [View repo →](https://github.com/BinarySeo/etsy-seo-optimizer)

A weekly analytics pipeline for a real handmade greeting-card shop. It collects Etsy search
listings and a full year of Google Analytics 4 traffic, stores each run in SQLite so trends can be
compared week over week, and produces a plain-English action list.

- **Keyword trends:** TF-IDF and tag-frequency deltas flag rising and falling search terms (e.g. graduation cards rising, novelty tags fading).
- **Traffic analysis:** sessions by listing, source, device, weekday, and new vs. returning visitors, with weekly → yearly views.
- **Gap analysis:** groups every listing into card categories, scores each category's traffic, and identifies categories the shop is missing.
- **Delivery:** a five-page Streamlit dashboard plus an automated weekly briefing.

---

## RFM Customer Segmentation (SQL)
**MySQL · CTEs · Window functions** — [View repo →](https://github.com/BinarySeo/Rfm_Analysis)

EDA and Recency / Frequency / Monetary segmentation of 2,823 order lines from 92 customers (2003 – May 2005).

- **Classic Cars** is the top product line at about **$3.9M of $10.0M** total revenue; **Medium** deals bring in over 60% of revenue.
- **November** is by far the strongest month (≈ $2.1M across 2003–04, nearly double October), so segments were designed around a pre-November campaign.
- Customers are scored 1–4 on each dimension with `NTILE(4)` and grouped into **Regular / Target / Inactive** segments, each with a recommended action.

---

## E-Commerce Sales Dashboard (Excel)
**Excel · Pivot tables · Slicers · Dashboard design** — [View repo →](https://github.com/BinarySeo/Excel_TheSelected)

<img src="https://raw.githubusercontent.com/BinarySeo/Excel_TheSelected/main/DashBoard.png" alt="Excel sales dashboard" width="720">

Cleaned and translated 10,000+ Korean-language transaction records for an apparel seller (2019 – May 2020),
added KRW → USD conversion, and built seven pivot analyses feeding one interactive dashboard.

- **$561K** in sales; Shopify drives **63%**, Instagram 19%.
- **17%** returning customers vs. a 20% goal; **5%** cancellations vs. a 3% goal; average rating **4.12 / 5** vs. 4.3.
- Search ads produce the most revenue ($193K); T-shirts are the top category ($120K).

---

## World Happiness Report 2021 (Python)
**pandas · SciPy · seaborn · Plotly** — [View repo →](https://github.com/BinarySeo/Happiness-report)

<img src="https://raw.githubusercontent.com/BinarySeo/Happiness-report/main/img/Correlation.png" alt="Correlation and p-values of happiness factors" width="420">

Which of the six factors behind the World Happiness Report's ladder score (149 countries) matter most, and do they differ by region and income?

- GDP (r = 0.79), life expectancy (0.77) and social support (0.76) are the strongest correlates; generosity shows no significant relationship (p = 0.83).
- Among the 20 happiest countries, **freedom** (0.73) and **perceived corruption** (−0.65) matter more than GDP.
- Region-by-region heatmaps: social support stands out in Asia, healthy life expectancy in the Americas.

---

## Survey Sampling & Email Campaign Analysis (SQL + Tableau)
**MySQL · DENSE_RANK · Tableau** — [View files →](AirBNB/)

<img src="AirBNB/Campaign%20Dashboard.png" alt="Campaign analysis dashboard" width="520">

A two-part analytics take-home on a short-term-rental host dataset.

1. **Survey sampling (SQL):** selected eligible hosts across 11 countries (opted in to policy email, listing in their home country, active or booked since 2022), then capped the pilot at 200 recipients and 50 per region with `DENSE_RANK` window functions — 175 hosts qualified. [SQL script](AirBNB/AirBnB.sql)
2. **Campaign analysis (Tableau):** compared three email campaigns on users, actions, click-through and conversion. Victoria Stories led CTR at **39%** vs. 13% and 10% for the others; the write-up separates campaign type, timing (tourist season) and email content as possible drivers. [Write-up (PDF)](AirBNB/Answers%20%28Wonsuk%20Seo%29.pdf)

---

## Case studies: production data tools
These are in daily use, so their code is private. Details are summarized here.

**AI-assisted collaboration inbox** — *Python · Gmail & Google Sheets APIs · SQLite · OpenAI / Anthropic · Railway*
An inbox for a two-person content-creator business that reads incoming email on a schedule,
filters out non-opportunities, and classifies the rest (type, sender, offer, budget, deliverables)
into structured records. Every email, decision and action is logged to a Google Sheet, which doubles as a
deal-tracking dataset. The team reviews AI-drafted replies from a phone web app. 75 automated tests cover the workflow.

**Staff document compliance tracker** — *Google Apps Script · Google Sheets as a database · Drive · Gmail · GitHub Actions*
Tracks required staff documents for a multi-program organization: staff upload, managers verify against a
checklist, and reminders go out before anything expires. Built around a normalized data model (people,
programs, assignments, document types, submissions, audit log) where compliance status is always *derived*
from verified dates rather than stored, plus a manager dashboard of counts by status.
76 unit tests run in CI before every deploy.

---

*More on GitHub: [github.com/BinarySeo](https://github.com/BinarySeo)*
