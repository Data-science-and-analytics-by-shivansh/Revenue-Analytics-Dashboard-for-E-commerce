// Similar to Excel, paste into Power BI Advanced Editor
let
    Source = Csv.Document(Web.Contents("https://your-hosted-csv-url-or-local-path"),[Delimiter=",", Columns=8, Encoding=1252, QuoteStyle=QuoteStyle.None]),  // Or use Excel connector for QuickBooks sim
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"InvoiceNo", type text}, {"StockCode", type text}, {"Description", type text}, {"Quantity", Int64.Type}, {"InvoiceDate", type datetime}, {"UnitPrice", type number}, {"CustomerID", Int64.Type}, {"Country", type text}}),
    #"Filtered Positive Quantity" = Table.SelectRows(#"Changed Type", each [Quantity] > 0),
    #"Added Revenue" = Table.AddColumn(#"Filtered Positive Quantity", "Revenue", each [Quantity] * [UnitPrice], type number),
    #"Added Cohort Month" = Table.AddColumn(#"Added Revenue", "Cohort Month", each Date.ToText(Date.StartOfMonth(List.Min(Table.SelectRows(#"Added Revenue", (r) => r[CustomerID] = [CustomerID])[InvoiceDate])), "yyyy-MM"), type text),
    #"Added Estimated Profit" = Table.AddColumn(#"Added Cohort Month", "Estimated Profit", each [Revenue] * 0.70, type number)  // Placeholder margin
in
    #"Added Estimated Profit"
