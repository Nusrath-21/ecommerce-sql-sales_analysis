"""
E-commerce Orders Analysis — Extended (raw tables)
Joins orders, order_items, products, customers to derive:
product-level, category-level, city-level, and order-status insights.
"""

import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker

# ---------------------------------------------------------
# 1. Load raw tables
# ---------------------------------------------------------
orders = pd.read_csv("orders.csv", parse_dates=["order_date"])
order_items = pd.read_csv("order_items.csv")
products = pd.read_csv("products.csv")
customers = pd.read_csv("customers.csv", parse_dates=["signup_date"])

# ---------------------------------------------------------
# 2. Build a single joined "line items" table
# ---------------------------------------------------------
df = (
    order_items
    .merge(orders, on="order_id", how="left")
    .merge(products, on="product_id", how="left")
    .merge(customers, on="customer_id", how="left")
)
df["line_revenue"] = df["quantity"] * df["unit_price"]

delivered = df[df["order_status"] == "Delivered"]

# ---------------------------------------------------------
# 3. Order status / cancellation analysis
# ---------------------------------------------------------
status_counts = orders["order_status"].value_counts()
cancellation_rate = round(100 * status_counts.get("Cancelled", 0) / len(orders), 1)

# ---------------------------------------------------------
# 4. Best-selling products (by revenue, delivered only)
# ---------------------------------------------------------
product_revenue = (
    delivered.groupby("product_name")["line_revenue"]
    .sum().sort_values(ascending=False).head(8)
)
product_units = (
    delivered.groupby("product_name")["quantity"]
    .sum().sort_values(ascending=False).head(8)
)

# ---------------------------------------------------------
# 5. Category revenue split
# ---------------------------------------------------------
category_revenue = (
    delivered.groupby("category")["line_revenue"]
    .sum().sort_values(ascending=False)
)

# ---------------------------------------------------------
# 6. City-wise revenue (delivered orders)
# ---------------------------------------------------------
city_revenue = (
    delivered.groupby("city")["line_revenue"]
    .sum().sort_values(ascending=False)
)

# ---------------------------------------------------------
# 7. Repeat customers
# ---------------------------------------------------------
orders_per_customer = orders[orders["order_status"] == "Delivered"].groupby("customer_id").size()
repeat_customers = (orders_per_customer > 1).sum()
one_time_customers = (orders_per_customer == 1).sum()

print("=== ORDER STATUS ===")
print(status_counts)
print(f"Cancellation rate: {cancellation_rate}%\n")

print("=== TOP PRODUCTS BY REVENUE ===")
print(product_revenue)

print("\n=== CATEGORY REVENUE ===")
print(category_revenue)

print("\n=== CITY REVENUE (top 5) ===")
print(city_revenue.head())

print(f"\n=== CUSTOMER LOYALTY ===")
print(f"Repeat customers: {repeat_customers}")
print(f"One-time customers: {one_time_customers}")

# ---------------------------------------------------------
# 8. Build extended dashboard figure
# ---------------------------------------------------------
plt.rcParams["font.family"] = "DejaVu Sans"
TEAL = "#0F766E"
AMBER = "#D97706"
SLATE = "#0F172A"
MUTED = "#64748B"
BG = "#F7F9FC"
PALETTE = ["#0F766E", "#D97706", "#7C3AED", "#0EA5E9", "#94A3B8", "#DB2777", "#65A30D", "#0891B2"]

fig = plt.figure(figsize=(14, 11), facecolor=BG)
gs = fig.add_gridspec(3, 2, height_ratios=[1, 1, 1], hspace=0.55, wspace=0.32,
                       left=0.09, right=0.96, top=0.90, bottom=0.06)

fig.suptitle("E-commerce Orders Analysis — Product & Customer Deep Dive",
             fontsize=18, fontweight="bold", color=SLATE, x=0.09, ha="left", y=0.98)
fig.text(0.09, 0.945, f"Based on {len(orders)} orders · {cancellation_rate}% cancelled · "
          f"{repeat_customers} repeat customers", fontsize=11, color=MUTED, ha="left")

# --- Top products by revenue ---
ax1 = fig.add_subplot(gs[0, 0])
pr = product_revenue.sort_values()
ax1.barh(pr.index, pr.values, color=TEAL)
ax1.set_title("Top Products by Revenue", fontsize=12.5, fontweight="bold", color=SLATE, loc="left")
ax1.xaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"₹{x/1000:.0f}K"))
ax1.spines[["top", "right"]].set_visible(False)
ax1.grid(axis="x", color="#E2E8F0", linewidth=0.8)
ax1.set_facecolor(BG)
ax1.tick_params(labelsize=9)

# --- Category revenue split (donut) ---
ax2 = fig.add_subplot(gs[0, 1])
wedges, _ = ax2.pie(category_revenue.values, colors=PALETTE[:len(category_revenue)],
                     startangle=90, wedgeprops={"width": 0.42, "edgecolor": BG, "linewidth": 2})
ax2.set_title("Revenue by Category", fontsize=12.5, fontweight="bold", color=SLATE, loc="left")
ax2.legend(wedges, [f"{c} ({v/category_revenue.sum()*100:.0f}%)" for c, v in category_revenue.items()],
           loc="center left", bbox_to_anchor=(1.0, 0.5), fontsize=8.5, frameon=False)

# --- Order status breakdown ---
ax3 = fig.add_subplot(gs[1, 0])
colors_status = [TEAL if s == "Delivered" else "#DC2626" for s in status_counts.index]
bars = ax3.bar(status_counts.index, status_counts.values, color=colors_status, width=0.5)
ax3.set_title("Order Status Breakdown", fontsize=12.5, fontweight="bold", color=SLATE, loc="left")
ax3.spines[["top", "right"]].set_visible(False)
ax3.grid(axis="y", color="#E2E8F0", linewidth=0.8)
ax3.set_facecolor(BG)
for b in bars:
    ax3.text(b.get_x() + b.get_width()/2, b.get_height() + 1, f"{int(b.get_height())}",
              ha="center", fontsize=10, color=SLATE, fontweight="bold")

# --- City-wise revenue ---
ax4 = fig.add_subplot(gs[1, 1])
cr = city_revenue.head(6).sort_values()
ax4.barh(cr.index, cr.values, color=AMBER)
ax4.set_title("Top Cities by Revenue", fontsize=12.5, fontweight="bold", color=SLATE, loc="left")
ax4.xaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"₹{x/1000:.0f}K"))
ax4.spines[["top", "right"]].set_visible(False)
ax4.grid(axis="x", color="#E2E8F0", linewidth=0.8)
ax4.set_facecolor(BG)
ax4.tick_params(labelsize=9)

# --- Repeat vs one-time customers ---
ax5 = fig.add_subplot(gs[2, :])
ax5.axis("off")
loyalty_data = [("One-time customers", one_time_customers, MUTED),
                 ("Repeat customers", repeat_customers, TEAL)]
total_cust = one_time_customers + repeat_customers
x_start = 0.15
for label, val, color in loyalty_data:
    width = (val / total_cust) * 0.7
    ax5.add_patch(plt.Rectangle((x_start, 0.35), width, 0.3, facecolor=color,
                                  transform=ax5.transAxes))
    ax5.text(x_start + width/2, 0.5, f"{val}", transform=ax5.transAxes,
              ha="center", va="center", fontsize=13, fontweight="bold", color="white")
    ax5.text(x_start + width/2, 0.2, label, transform=ax5.transAxes,
              ha="center", va="center", fontsize=10, color=SLATE)
    x_start += width
ax5.text(0.15, 0.85, "Customer Loyalty: Repeat vs One-Time Buyers", transform=ax5.transAxes,
          fontsize=12.5, fontweight="bold", color=SLATE)

plt.savefig("ecommerce_dashboard_extended.png", dpi=180, facecolor=BG)
print("\nExtended dashboard saved as ecommerce_dashboard_extended.png")
