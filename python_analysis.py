import pandas as pd
import matplotlib.pyplot as plt
from prophet import Prophet

# Load data
df = pd.read_csv('data/online_retail.csv', parse_dates=['InvoiceDate'])

# Clean data
df = df[df['Quantity'] > 0]
df['Revenue'] = df['Quantity'] * df['UnitPrice']

# Monthly Revenue Trends
monthly_revenue = df.resample('M', on='InvoiceDate')['Revenue'].sum()
monthly_revenue.plot(title='Monthly Revenue Trends')
plt.savefig('outputs/monthly_revenue.png')

# Customer Cohorts
df['CohortMonth'] = df.groupby('CustomerID')['InvoiceDate'].transform('min').dt.to_period('M')
df['InvoiceMonth'] = df['InvoiceDate'].dt.to_period('M')
cohort_data = df.groupby(['CohortMonth', 'InvoiceMonth'])['CustomerID'].nunique().reset_index()
cohort_data['Period'] = (cohort_data['InvoiceMonth'] - cohort_data['CohortMonth']).apply(lambda x: x.n)
cohort_pivot = cohort_data.pivot_table(index='CohortMonth', columns='Period', values='CustomerID')
cohort_pivot.to_csv('outputs/cohort_analysis.csv')

# AI Forecasting with Prophet
prophet_df = monthly_revenue.reset_index().rename(columns={'InvoiceDate': 'ds', 'Revenue': 'y'})
model = Prophet()
model.fit(prophet_df)
future = model.make_future_dataframe(periods=12, freq='M')
forecast = model.predict(future)
fig = model.plot(forecast)
fig.savefig('outputs/sales_forecast.png')

print("Analysis complete. Check outputs/ folder.")
