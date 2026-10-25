# Pizza Place Sales: SQL Analysis (MySQL)

A SQL project analysing a year of sales (2015) from a fictional pizza restaurant. I built the database in MySQL, imported the raw CSV files, and wrote queries to answer the kind of questions a business analyst would be asked: what sells, when are we busiest, and where does the revenue come from?

**Tools:** MySQL 8.0+, MySQL Workbench
**Dataset:** [Pizza Place Sales on Kaggle](https://www.kaggle.com/datasets/mysarahmadbhat/pizza-place-sales) (uploaded by mysarahmadbhat). The raw CSVs are not included in this repo.

## The data

| Table | Rows | Description |
|---|---|---|
| `orders` | 21,350 | One row per order: date and time |
| `order_details` | 48,620 | One row per pizza line within an order |
| `pizzas` | 96 | One row per pizza type and size, with price |
| `pizza_types` | 32 | Menu items: name, category, ingredients |

The tables are linked by primary and foreign keys (`orders` → `order_details` → `pizzas` → `pizza_types`).

**Data checks:** no missing values, no duplicate IDs, and every order line matches a valid order and pizza. One CSV had a non-UTF-8 character (an apostrophe in 'Nduja salami) that needed re-saving as UTF-8 before import.

## Repo contents

| File | What it covers |
|---|---|
| `01_create_schema.sql` | Database and table creation with primary and foreign keys |
| `Pizza-Place-basics.sql` | `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, `DISTINCT`, `LIKE`, `BETWEEN`, basic aggregates |
| `Pizza-Place-aggregation-and-joins.sql` | `GROUP BY`, `HAVING`, date functions, `JOIN` across up to 3 tables |
| `Analysis.sql` | A reusable view, `CASE WHEN`, CTEs (including a recursive CTE), window functions (`RANK`, `LAG`, running totals) |

## Key findings

**Revenue and orders**
- Total revenue for 2015 was **817,860.05** across **21,350 orders**; the average order was worth **38.31** and contained **2.32 pizzas**.
- Monthly revenue was fairly stable, between about 64,000 (October) and 72,600 (July).
- The busiest days were 27 and 26 November, with over 4,400 revenue each.

**When customers order**
- **Friday** is the busiest weekday (3,538 orders) and **Sunday** the quietest (2,624).
- Orders peak at **lunch (12:00 to 13:59)** and **early evening (17:00 to 18:59)**. The evening (5pm onwards) accounts for about 48% of orders, while mornings are under 6%.

**What sells**
- **Large (L) pizzas bring in about 46% of revenue** (375,318.70), well ahead of medium and small.
- The four menu categories are close: Classic 26.9%, Supreme 25.5%, Chicken 24.0%, Veggie 23.7%.
- **The Classic Deluxe sells the most units (2,453), but The Thai Chicken earns the most revenue (43,434.25)** because it sells at a higher price per pizza.
- **The Brie Carre is the weakest seller by a wide margin** (490 units, about 11,600 revenue). The next lowest sells nearly double that number of units.

**A data oddity**
- There were **no orders on 7 days**: 24 and 25 September, four consecutive Mondays in October (5, 12, 19, 26) and 25 December. The data does not say why, so I have not assumed a reason (closures, missing data, or something else).

## Techniques demonstrated

- Database design: schema, data types, primary and foreign keys
- Importing and validating CSV data
- Filtering, sorting and aggregating (`WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`)
- Multi-table joins
- Date and time functions (`MONTH`, `DAYNAME`, `HOUR`)
- `CASE WHEN` for bucketing
- Views for reusable logic
- CTEs, including a recursive CTE to build a calendar and find missing dates
- Window functions: `RANK() OVER (PARTITION BY ...)`, running totals, `LAG` for month-over-month change

## Limitations

- One year of data from a single restaurant, so seasonality across years can't be assessed.
- There is no customer information, so analysis such as repeat customers or retention isn't possible.
- Revenue is calculated from list prices; discounts, costs and profit aren't in the data.

## How to run it

1. Download the dataset from Kaggle (link above).
2. Run `01_create_schema.sql` in MySQL Workbench.
3. Import the four CSVs in this order: `pizza_types`, `pizzas`, `orders`, `order_details` (Table Data Import Wizard).
4. Run `Pizza-Place-basics.sql`, then `Pizza-Place-aggregation-and-joins.sql`, then `Analysis.sql`.

## Possible next steps

- Connect Power BI to the `v_sales` view (created in `Analysis.sql`) to build a dashboard on top of this analysis.
- Explore the 7 missing days further and test whether they affect the monthly comparisons.
