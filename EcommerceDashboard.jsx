import React from "react";
import {
  AreaChart, Area, BarChart, Bar, PieChart, Pie, XAxis, YAxis,
  CartesianGrid, Tooltip, ResponsiveContainer, Cell, Legend,
} from "recharts";

const monthlyRevenue = [
  { month: "Jan", revenue: 341000 },
  { month: "Feb", revenue: 89300 },
  { month: "Mar", revenue: 243400 },
  { month: "Apr", revenue: 89800 },
  { month: "May", revenue: 276500 },
  { month: "Jun", revenue: 205400 },
  { month: "Jul", revenue: 73900 },
];

const paymentMethods = [
  { method: "Cash on Delivery", revenue: 471000 },
  { method: "Debit Card", revenue: 361100 },
  { method: "Credit Card", revenue: 235400 },
  { method: "UPI", revenue: 181900 },
  { method: "Net Banking", revenue: 69900 },
];

const topProducts = [
  { name: "Laptop", revenue: 455000 },
  { name: "Office Chair", revenue: 154000 },
  { name: "Bookshelf", revenue: 148800 },
  { name: "Study Table", revenue: 104500 },
  { name: "Smartwatch", revenue: 90000 },
  { name: "Bluetooth Speaker", revenue: 81200 },
  { name: "Headphones", revenue: 70000 },
  { name: "Running Shoes", revenue: 51200 },
];

const categoryRevenue = [
  { name: "Electronics", value: 756800 },
  { name: "Furniture", value: 407300 },
  { name: "Sports", value: 85300 },
  { name: "Home", value: 41400 },
  { name: "Accessories", value: 28500 },
];

const cityRevenue = [
  { city: "Delhi", revenue: 347000 },
  { city: "Kolkata", revenue: 269400 },
  { city: "Hyderabad", revenue: 173700 },
  { city: "Bangalore", revenue: 166200 },
  { city: "Pune", revenue: 96300 },
  { city: "Mumbai", revenue: 66900 },
];

const orderStatus = [
  { status: "Delivered", count: 81 },
  { status: "Cancelled", count: 19 },
];

const loyalty = { repeat: 22, oneTime: 6 };

const TEAL = "#0F766E";
const AMBER = "#D97706";
const SLATE = "#0F172A";
const MUTED = "#64748B";
const RED = "#DC2626";
const PALETTE = ["#0F766E", "#D97706", "#7C3AED", "#0EA5E9", "#94A3B8", "#DB2777"];

const totalRevenue = paymentMethods.reduce((s, p) => s + p.revenue, 0);
const totalOrders = orderStatus.reduce((s, o) => s + o.count, 0);
const avgOrderValue = 16287.65;
const cancellationRate = ((19 / totalOrders) * 100).toFixed(0);
const bestMonth = monthlyRevenue.reduce((a, b) => (b.revenue > a.revenue ? b : a));

function formatINR(n) {
  if (n >= 100000) return `₹${(n / 100000).toFixed(2)}L`;
  if (n >= 1000) return `₹${(n / 1000).toFixed(0)}K`;
  return `₹${n}`;
}

function Card({ children, style }) {
  return (
    <div style={{ background: "#FFFFFF", border: "1px solid #E2E8F0", borderRadius: 10, padding: 20, ...style }}>
      {children}
    </div>
  );
}

function SectionTitle({ title, sub }) {
  return (
    <>
      <div style={{ fontFamily: "'Space Grotesk', sans-serif", fontWeight: 700, fontSize: 15, color: SLATE, marginBottom: 4 }}>
        {title}
      </div>
      {sub && <div style={{ fontSize: 12, color: MUTED, marginBottom: 10 }}>{sub}</div>}
    </>
  );
}

function KpiCard({ label, value, sub, accent }) {
  return (
    <div style={{ background: "#FFFFFF", border: "1px solid #E2E8F0", borderRadius: 10, padding: "16px 18px", flex: 1, minWidth: 140 }}>
      <div style={{ fontFamily: "'JetBrains Mono', monospace", fontSize: 23, fontWeight: 700, color: accent || SLATE, letterSpacing: "-0.02em" }}>
        {value}
      </div>
      <div style={{ fontSize: 12, color: MUTED, marginTop: 5, fontWeight: 500 }}>{label}</div>
      {sub && <div style={{ fontSize: 10.5, color: "#94A3B8", marginTop: 2 }}>{sub}</div>}
    </div>
  );
}

function CustomTooltip({ active, payload, label }) {
  if (!active || !payload || !payload.length) return null;
  return (
    <div style={{ background: SLATE, color: "white", padding: "8px 12px", borderRadius: 6, fontSize: 12.5, fontFamily: "'JetBrains Mono', monospace" }}>
      {label && <div style={{ opacity: 0.7, marginBottom: 2 }}>{label}</div>}
      <div style={{ fontWeight: 700 }}>{formatINR(payload[0].value)}</div>
    </div>
  );
}

export default function EcommerceDashboard() {
  return (
    <div style={{ fontFamily: "'Inter', system-ui, sans-serif", background: "#F7F9FC", minHeight: "100vh", padding: "32px 28px" }}>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@500;700&display=swap');
      `}</style>

      <div style={{ marginBottom: 24 }}>
        <div style={{ fontFamily: "'Space Grotesk', sans-serif", fontSize: 26, fontWeight: 700, color: SLATE }}>
          E-commerce Orders Analysis
        </div>
        <div style={{ fontSize: 13.5, color: MUTED, marginTop: 4 }}>
          Sales, product, customer, and order-status insights — Jan–Jul 2026
        </div>
      </div>

      <div style={{ display: "flex", gap: 12, marginBottom: 24, flexWrap: "wrap" }}>
        <KpiCard label="Total Revenue" value={formatINR(totalRevenue)} accent={TEAL} />
        <KpiCard label="Total Orders" value={totalOrders} accent={SLATE} />
        <KpiCard label="Avg Order Value" value={formatINR(avgOrderValue)} accent={AMBER} />
        <KpiCard label="Cancellation Rate" value={`${cancellationRate}%`} accent={RED} />
        <KpiCard label="Repeat Customers" value={loyalty.repeat} sub={`of ${loyalty.repeat + loyalty.oneTime} buyers`} accent={TEAL} />
        <KpiCard label="Best Month" value={bestMonth.month} sub={formatINR(bestMonth.revenue)} accent={TEAL} />
      </div>

      <Card style={{ marginBottom: 20 }}>
        <SectionTitle title="Monthly Revenue Trend" sub="Peaked in January, dipped mid-quarter, recovered in May" />
        <ResponsiveContainer width="100%" height={230}>
          <AreaChart data={monthlyRevenue} margin={{ top: 10, right: 10, left: -10, bottom: 0 }}>
            <defs>
              <linearGradient id="revFill" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor={TEAL} stopOpacity={0.22} />
                <stop offset="100%" stopColor={TEAL} stopOpacity={0} />
              </linearGradient>
            </defs>
            <CartesianGrid strokeDasharray="3 3" stroke="#EEF2F7" vertical={false} />
            <XAxis dataKey="month" tick={{ fontSize: 12, fill: MUTED }} axisLine={{ stroke: "#E2E8F0" }} tickLine={false} />
            <YAxis tickFormatter={formatINR} tick={{ fontSize: 11, fill: MUTED }} axisLine={false} tickLine={false} width={55} />
            <Tooltip content={<CustomTooltip />} />
            <Area type="monotone" dataKey="revenue" stroke={TEAL} strokeWidth={2.5} fill="url(#revFill)"
                  dot={{ r: 4, fill: "white", stroke: TEAL, strokeWidth: 2 }} activeDot={{ r: 6 }} />
          </AreaChart>
        </ResponsiveContainer>
      </Card>

      <div style={{ display: "flex", gap: 20, flexWrap: "wrap", marginBottom: 20 }}>
        <Card style={{ flex: 1.3, minWidth: 340 }}>
          <SectionTitle title="Top Products by Revenue" sub="Laptop alone drives over a third of delivered revenue" />
          <ResponsiveContainer width="100%" height={260}>
            <BarChart data={[...topProducts].reverse()} layout="vertical" margin={{ top: 0, right: 30, left: 10, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#EEF2F7" horizontal={false} />
              <XAxis type="number" tickFormatter={formatINR} tick={{ fontSize: 11, fill: MUTED }} axisLine={false} tickLine={false} />
              <YAxis type="category" dataKey="name" tick={{ fontSize: 11.5, fill: SLATE }} axisLine={false} tickLine={false} width={100} />
              <Tooltip content={<CustomTooltip />} />
              <Bar dataKey="revenue" fill={TEAL} radius={[0, 4, 4, 0]} barSize={14} />
            </BarChart>
          </ResponsiveContainer>
        </Card>

        <Card style={{ flex: 1, minWidth: 280 }}>
          <SectionTitle title="Revenue by Category" sub="Electronics dominates at 57% of revenue" />
          <ResponsiveContainer width="100%" height={260}>
            <PieChart>
              <Pie data={categoryRevenue} dataKey="value" nameKey="name" innerRadius={55} outerRadius={90} paddingAngle={2}>
                {categoryRevenue.map((_, i) => <Cell key={i} fill={PALETTE[i % PALETTE.length]} />)}
              </Pie>
              <Tooltip content={<CustomTooltip />} />
              <Legend verticalAlign="middle" align="right" layout="vertical" wrapperStyle={{ fontSize: 11.5 }} />
            </PieChart>
          </ResponsiveContainer>
        </Card>
      </div>

      <div style={{ display: "flex", gap: 20, flexWrap: "wrap", marginBottom: 20 }}>
        <Card style={{ flex: 1, minWidth: 280 }}>
          <SectionTitle title="Order Status Breakdown" sub={`${cancellationRate}% of orders were cancelled`} />
          <ResponsiveContainer width="100%" height={220}>
            <BarChart data={orderStatus} margin={{ top: 10, right: 10, left: -10, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#EEF2F7" vertical={false} />
              <XAxis dataKey="status" tick={{ fontSize: 12, fill: MUTED }} axisLine={{ stroke: "#E2E8F0" }} tickLine={false} />
              <YAxis tick={{ fontSize: 11, fill: MUTED }} axisLine={false} tickLine={false} />
              <Tooltip
                content={({ active, payload, label }) =>
                  active && payload && payload.length ? (
                    <div style={{ background: SLATE, color: "white", padding: "8px 12px", borderRadius: 6, fontSize: 12.5 }}>
                      <div style={{ opacity: 0.7 }}>{label}</div>
                      <div style={{ fontWeight: 700 }}>{payload[0].value} orders</div>
                    </div>
                  ) : null
                }
              />
              <Bar dataKey="count" radius={[4, 4, 0, 0]} barSize={70}>
                {orderStatus.map((entry, i) => (
                  <Cell key={i} fill={entry.status === "Delivered" ? TEAL : RED} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </Card>

        <Card style={{ flex: 1.3, minWidth: 340 }}>
          <SectionTitle title="Top Cities by Revenue" sub="Delhi leads, but Kolkata spends more per customer" />
          <ResponsiveContainer width="100%" height={220}>
            <BarChart data={[...cityRevenue].reverse()} layout="vertical" margin={{ top: 0, right: 30, left: 10, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#EEF2F7" horizontal={false} />
              <XAxis type="number" tickFormatter={formatINR} tick={{ fontSize: 11, fill: MUTED }} axisLine={false} tickLine={false} />
              <YAxis type="category" dataKey="city" tick={{ fontSize: 12, fill: SLATE }} axisLine={false} tickLine={false} width={80} />
              <Tooltip content={<CustomTooltip />} />
              <Bar dataKey="revenue" fill={AMBER} radius={[0, 4, 4, 0]} barSize={16} />
            </BarChart>
          </ResponsiveContainer>
        </Card>
      </div>

      <Card style={{ marginBottom: 8 }}>
        <SectionTitle title="Customer Loyalty: Repeat vs One-Time Buyers" />
        <div style={{ display: "flex", height: 44, borderRadius: 8, overflow: "hidden", marginTop: 6 }}>
          <div style={{ width: `${(loyalty.oneTime / (loyalty.oneTime + loyalty.repeat)) * 100}%`, background: "#94A3B8", display: "flex", alignItems: "center", justifyContent: "center", color: "white", fontWeight: 700, fontSize: 14 }}>
            {loyalty.oneTime}
          </div>
          <div style={{ width: `${(loyalty.repeat / (loyalty.oneTime + loyalty.repeat)) * 100}%`, background: TEAL, display: "flex", alignItems: "center", justifyContent: "center", color: "white", fontWeight: 700, fontSize: 14 }}>
            {loyalty.repeat}
          </div>
        </div>
        <div style={{ display: "flex", justifyContent: "space-between", marginTop: 8, fontSize: 12, color: MUTED }}>
          <span>One-time customers</span>
          <span>Repeat customers</span>
        </div>
      </Card>

      <div style={{ fontSize: 11, color: "#94A3B8", marginTop: 20, textAlign: "center" }}>
        Data source: PostgreSQL — orders, order_items, products, customers · Analysis by Nusrath
      </div>
    </div>
  );
}
