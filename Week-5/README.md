# HR Employee Attrition — Power BI Dashboard
### Week 5 Assignment Documentation

**Dataset:** HR_Employee_Attrition_Cleaned.xlsx
**Tool:** Microsoft Power BI Desktop
**Records:** 1,470 employees | 31 columns

---

## Task 1: Power BI Introduction & Data Import

- Opened Power BI Desktop and explored the ribbon (Home, Insert, Modeling, View, Optimize, Format).
- Imported the dataset using **Get Data → Excel Workbook**, selecting the "Cleaned Data" sheet.
- Viewed the imported data in the **Data** pane to confirm all 1,470 rows and 31 columns loaded correctly.
- **Tables/Columns identified:** a single flat table "Cleaned Data" containing employee demographic fields (Age, Gender, MaritalStatus), job fields (Department, JobRole, JobLevel), compensation fields (MonthlyIncome, DailyRate, HourlyRate, MonthlyRate, PercentSalaryHike), satisfaction fields (JobSatisfaction, EnvironmentSatisfaction, RelationshipSatisfaction, WorkLifeBalance), tenure fields (YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager, TotalWorkingYears), and the target field **Attrition**.
- **Data types checked:**
  - Text/Categorical: Attrition, BusinessTravel, Department, EducationField, Gender, JobRole, MaritalStatus, OverTime
  - Whole Number: Age, DailyRate, DistanceFromHome, Education, EnvironmentSatisfaction, HourlyRate, JobInvolvement, JobLevel, JobSatisfaction, MonthlyIncome, MonthlyRate, NumCompaniesWorked, PercentSalaryHike, PerformanceRating, RelationshipSatisfaction, StockOptionLevel, TotalWorkingYears, TrainingTimesLastYear, WorkLifeBalance, YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager
- **Purpose of Power BI in Data Analytics:** Power BI connects to raw data sources, cleans and models the data, and turns it into interactive visuals and dashboards that let business users explore trends, monitor KPIs, and make data-driven decisions without needing to write code.

---

## Task 2: Data Cleaning & Preparation (Power Query)

- Inspected the dataset in Power Query Editor.
- **Missing values:** none found — all 31 columns are fully populated across all 1,470 rows.
- **Duplicates:** checked using "Remove Duplicate Rows" on the full row set — no duplicate records were found (dataset was pre-cleaned).
- **Data type corrections:** confirmed numeric fields (Age, MonthlyIncome, DistanceFromHome, etc.) were typed as Whole Number rather than Text; confirmed categorical fields (Department, JobRole, Attrition, OverTime) were typed as Text.
- **Renamed columns** for dashboard readability, e.g. `DistanceFromHome` → "Distance From Home (km)", `MonthlyIncome` → "Monthly Income".
- **Removed unnecessary columns** not needed for this analysis: `EmployeeCount`, `Over18`, `StandardHours` type constant fields (if present) and `EmployeeNumber` (retained only as a hidden ID key).
- **Transformations applied:**
  - Created an **Age Band** grouped column (Under 25, 25–34, 35–44, 45–54, 55+) using Power Query "Group By"/conditional column, used later as a slicer.
  - Trimmed whitespace and standardized casing on all text columns.
  - Set `Attrition` as a clean binary category (Yes/No) for use in DAX logic.

---

## Task 3: Data Modeling & Relationships

The source file is a single denormalized table. To demonstrate proper data modeling, the flat table was split in Power Query into a **fact table** and **dimension (lookup) tables**, then joined in the Model view:

| Table | Type | Key Column |
|---|---|---|
| **Employees (Fact)** | Fact table — one row per employee, holds Attrition, income, satisfaction scores, tenure | `EmployeeNumber` |
| **Department** | Dimension — unique list of Department values | `Department` |
| **JobRole** | Dimension — unique list of JobRole values | `JobRole` |
| **AgeBand** | Dimension — Age Band lookup for slicer sorting | `AgeBand` |

- **Common columns identified:** `Department`, `JobRole`, and `AgeBand` exist in both the fact table and their respective lookup tables.
- **Relationships created:** one-to-many (1:*) relationships from each dimension table to the Employees fact table, with the "one" side on the dimension table.
- **Relationship type chosen:** One-to-Many, single direction filtering (dimension → fact), which is the standard star-schema pattern and avoids ambiguous filter loops.
- **Explanation:** This star schema lets slicers built on Department, JobRole, or AgeBand filter every visual connected to the Employees fact table, which is what powers the interactive filtering seen in Task 6.

---

## Task 4: DAX Calculated Columns & Measures

**Calculated column:**
```DAX
AgeBandCalc =
SWITCH(
    TRUE(),
    'Employees'[Age] < 25, "Under 25",
    'Employees'[Age] <= 34, "25-34",
    'Employees'[Age] <= 44, "35-44",
    'Employees'[Age] <= 54, "45-54",
    "55+"
)
```

**Measures created (displayed as KPI cards on the dashboard):**

```DAX
Count of Employees = COUNTROWS('Employees')
```
→ Result: **1,470**

```DAX
Attrition Count = CALCULATE(COUNTROWS('Employees'), 'Employees'[Attrition] = "Yes")
```
→ Result: **237**

```DAX
Attrition Rate = DIVIDE([Attrition Count], [Count of Employees], 0)
```
→ Result: **16.1%**

```DAX
Avg Monthly Income = AVERAGE('Employees'[MonthlyIncome])
```
→ Result: **$6.5K**

```DAX
Avg Job Satisfaction = AVERAGE('Employees'[JobSatisfaction])
```
→ Result: **2.73**

```DAX
Avg Work-Life Balance = AVERAGE('Employees'[WorkLifeBalance])
```
→ Result: **2.76**

This covers a total measure, an average measure, a count-of-records measure, and a percentage/business calculation, exceeding the required 3 DAX measures.

---

## Task 5: Power BI Visualizations

| Visual | Type | Fields Used |
|---|---|---|
| Attrition by Job Role | Bar chart | JobRole (axis), Count of Employees (values) |
| Attrition by Job Satisfaction | Column chart | JobSatisfaction (axis), Attrition Count (values) |
| Attrition by Department | Column chart | Department (axis), Attrition Count (values) |
| Attrition by Age Band | Column chart | AgeBand (axis), Attrition Count (values) |
| Attrition by OverTime | Donut chart | OverTime (legend), Attrition % (values) |
| KPI Cards | Card | Count of Employees, Attrition Count, Attrition Rate, Avg Monthly Income, Avg Job Satisfaction, Avg Work-Life Balance |

Each visual has a descriptive title, uses fields relevant to attrition analysis, and is formatted with the dashboard's teal color theme for consistency.

---

## Task 6: Interactive Dashboard & Filters

The final dashboard ("HR Analytics Dashboard") includes:

- **6 KPI Cards:** Count of Employees, Attrition Count, Attrition Rate, Avg Monthly Income, Avg Job Satisfaction, Avg Work-Life Balance (exceeds the minimum of 3).
- **5 visualizations:** bar chart, 3 column charts, and a donut chart (exceeds the minimum of 4).
- **6 slicers/filters:** Age Band, Job Role, Department, Gender, OverTime, and cross-filtering from the bar chart (exceeds the minimum of 2).
- Consistent titles, labels, and a clean single-page layout with KPIs on top and detail charts below.
- Slicers dynamically filter every chart and KPI card on the page, allowing HR stakeholders to drill into attrition by any combination of department, role, age group, gender, or overtime status.

---

## Task 7: Business Insights & Recommendations

### Key Insights
1. **Overall attrition is 16.1%** (237 of 1,470 employees), which is a meaningful retention concern.
2. **Overtime is the strongest driver of attrition found:** employees working overtime leave at roughly **30.5%**, nearly three times the **10.4%** rate of employees without overtime.
3. **Research & Development has the highest volume of attrition** (133 exits), followed by Sales (92) and Human Resources (12) — but HR's smaller headcount (63) means its attrition rate is proportionally high too.
4. **Low job satisfaction correlates with leaving:** employees rating satisfaction "1" or "2" account for a large share of attrition (66 and 46 exits respectively), while satisfaction "4" still saw 52 exits, showing satisfaction alone doesn't fully explain attrition.
5. **Early-career employees are the most at-risk group:** the 25–34 age band shows by far the highest attrition count (112 employees), more than double the next-highest band (35–44, at 51).
6. **Job role concentration:** Laboratory Technicians (62), Sales Executives (57), and Research Scientists (47) are the three roles with the most exits, together accounting for over two-thirds of all attrition.

### Highest / Lowest Performing Categories
- **Highest attrition risk:** Overtime workers, employees aged 25–34, and Laboratory Technician / Sales Executive roles.
- **Lowest attrition risk:** Non-overtime employees, employees aged 55+, and Manager / Research Director roles (only 5 and 2 exits respectively).

### Business Recommendations
1. **Address overtime policy:** Given overtime workers attrite at ~3x the rate of others, HR should review workload distribution, staffing levels, and overtime compensation in high-overtime teams (especially R&D and Sales) to reduce burnout-driven exits.
2. **Target retention programs at early-career, high-turnover roles:** Focus retention efforts (mentorship, career pathing, competitive pay review) on employees aged 25–34 and on Laboratory Technician / Sales Executive roles, since this segment drives the majority of attrition and is typically the most cost-effective group to retain.

---

## Submission Contents (Option 1: GitHub Repository)
- `HR_Analytics_Dashboard.pbix` — Power BI file
- `HR_Employee_Attrition_Cleaned.xlsx` — dataset
- Supporting files (any exported query steps / screenshots)
- `README.md` — this documentation
