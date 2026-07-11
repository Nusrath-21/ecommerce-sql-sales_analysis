"""
E-commerce Orders Analysis
Loads SQL query outputs (exported as CSV from PostgreSQL) and builds
a summary dashboard using Pandas + Matplotlib.
"""

import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker

# ---------------------------------------------------------
# 1. Load data
# ---------------------------------------------------------
monthly_revenue = pd.read_csv("monthlyrevenue.csv")
payment_breakdown = pd.read_csv("Total_Revenue.csv")
top_customers = pd.read_csv("totalspent.csv")
avg_order_value = pd.read_csv("Average_of_orders.csv")["avg_order_value"][0]
total_orders = pd.read_csv("total_orders.csv")["total_orders"][0]
cod_percentage = pd.read_csv("codpercent.csv")["cod_percentage"][0]

# Clean up monthly revenue: parse dates, sort chronologically
monthly_revenue["month"] = pd.to_datetime(monthly_revenue["month"])
monthly_revenue = monthly_revenue.sort_values("month")
monthly_revenue["month_label"] = monthly_revenue["month"].dt.strftime("%b %Y")

# Derived stats
total_revenue = payment_breakdown["total_revenue"].sum()
best_month = monthly_revenue.loc[monthly_revenue["monthly_revenue"].idxmax()]
worst_month = monthly_revenue.loc[monthly_revenue["monthly_revenue"].idxmin()]
top_payment_method = payment_breakdown.loc[payment_breakdown["total_revenue"].idxmax()]

print("=== SUMMARY STATS ===")
print(f"Total Revenue: ₹{total_revenue:,.0f}")
print(f"Total Orders: {total_orders}")
print(f"Avg Order Value: ₹{avg_order_value:,.2f}")
print(f"COD Percentage: {cod_percentage}%")
print(f"Best Month: {best_month['month_label']} (₹{best_month['monthly_revenue']:,.0f})")
print(f"Weakest Month: {worst_month['month_label']} (₹{worst_month['monthly_revenue']:,.0f})")
print(f"Top Payment Method: {top_payment_method['payment_method']} (₹{top_payment_method['total_revenue']:,.0f})")

# ---------------------------------------------------------
# 2. Build dashboard figure
# ---------------------------------------------------------
plt.rcParams["font.family"] = "DejaVu Sans"
fig = plt.figure(figsize=(14, 10), facecolor="#F7F9FC")
gs = fig.add_gridspec(3, 2, height_ratios=[0.5, 1.3, 1.3], hspace=0.55, wspace=0.35,
                       left=0.1, right=0.95, top=0.88, bottom=0.06)

TEAL = "#0F766E"
AMBER = "#D97706"
SLATE = "#0F172A"
MUTED = "#64748B"
BG = "#F7F9FC"

fig.suptitle("E-commerce Orders Analysis Dashboard", fontsize=20, fontweight="bold",
             color=SLATE, x=0.07, ha="left", y=0.99)
fig.text(0.07, 0.945, "Sales performance, customer, and payment trends",
          fontsize=11, color=MUTED, ha="left")

# --- KPI cards (row 0) ---
kpi_data = [
    ("Total Revenue", f"₹{total_revenue:,.0f}"),
    ("Total Orders", f"{total_orders}"),
    ("Avg Order Value", f"₹{avg_order_value:,.0f}"),
    ("COD Share", f"{cod_percentage:.0f}%"),
]
kpi_ax = fig.add_subplot(gs[0, :])
kpi_ax.axis("off")
n = len(kpi_data)
for i, (label, value) in enumerate(kpi_data):
    x = i / n
    kpi_ax.add_patch(plt.Rectangle((x + 0.01, 0.05), 1/n - 0.03, 0.9,
                                    transform=kpi_ax.transAxes, facecolor="white",
                                    edgecolor="#E2E8F0", linewidth=1))
    kpi_ax.text(x + 0.03, 0.62, value, transform=kpi_ax.transAxes,
                fontsize=17, fontweight="bold", color=TEAL, ha="left", va="center")
    kpi_ax.text(x + 0.03, 0.28, label, transform=kpi_ax.transAxes,
                fontsize=10, color=MUTED, ha="left", va="center")

# --- Monthly revenue trend (row 1, col 0-1) ---
ax1 = fig.add_subplot(gs[1, :])
ax1.plot(monthly_revenue["month_label"], monthly_revenue["monthly_revenue"],
         marker="o", color=TEAL, linewidth=2.5, markersize=7, markerfacecolor="white",
         markeredgewidth=2, markeredgecolor=TEAL)
ax1.fill_between(monthly_revenue["month_label"], monthly_revenue["monthly_revenue"],
                  color=TEAL, alpha=0.08)
ax1.set_ylim(0, monthly_revenue["monthly_revenue"].max() * 1.18)
ax1.set_title("Monthly Revenue Trend", fontsize=13, fontweight="bold", color=SLATE, loc="left", pad=15)
ax1.yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"₹{x/1000:.0f}K"))
ax1.spines[["top", "right"]].set_visible(False)
ax1.grid(axis="y", color="#E2E8F0", linewidth=0.8)
ax1.set_facecolor(BG)
for i, row in monthly_revenue.iterrows():
    ax1.annotate(f"₹{row['monthly_revenue']/1000:.0f}K",
                 (row["month_label"], row["monthly_revenue"]),
                 textcoords="offset points", xytext=(0, 10), ha="center",
                 fontsize=8.5, color=SLATE)

# --- Payment method breakdown (row 2, col 0) ---
ax2 = fig.add_subplot(gs[2, 0])
colors = [TEAL, AMBER, "#7C3AED", "#0EA5E9", "#94A3B8"]
ax2.barh(payment_breakdown["payment_method"], payment_breakdown["total_revenue"],
          color=colors[:len(payment_breakdown)])
ax2.set_title("Revenue by Payment Method", fontsize=13, fontweight="bold", color=SLATE, loc="left")
ax2.xaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"₹{x/1000:.0f}K"))
ax2.spines[["top", "right"]].set_visible(False)
ax2.invert_yaxis()
ax2.grid(axis="x", color="#E2E8F0", linewidth=0.8)
ax2.set_facecolor(BG)
for i, v in enumerate(payment_breakdown["total_revenue"]):
    ax2.text(v + 5000, i, f"₹{v/1000:.0f}K", va="center", fontsize=9, color=SLATE)

# --- Top customers (row 2, col 1) ---
ax3 = fig.add_subplot(gs[2, 1])
top_customers_sorted = top_customers.sort_values("total_spent")
ax3.barh(top_customers_sorted["customer_name"], top_customers_sorted["total_spent"],
          color=AMBER)
ax3.set_title("Top 5 Customers by Spend", fontsize=13, fontweight="bold", color=SLATE, loc="left")
ax3.xaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"₹{x/1000:.0f}K"))
ax3.spines[["top", "right"]].set_visible(False)
ax3.grid(axis="x", color="#E2E8F0", linewidth=0.8)
ax3.set_facecolor(BG)
for i, v in enumerate(top_customers_sorted["total_spent"]):
    ax3.text(v + 3000, i, f"₹{v/1000:.0f}K", va="center", fontsize=9, color=SLATE)

fig.patch.set_facecolor(BG)
plt.savefig("ecommerce_dashboard.png", dpi=180, facecolor=BG)
print("\nDashboard saved as ecommerce_dashboard.png")
