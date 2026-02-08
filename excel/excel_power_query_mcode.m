// Paste this into Excel Power Query Editor (Data > Get Data > Blank Query)
let
    Source = Csv.Document(File.Contents("C:\path\to\data\online_retail.csv"),[Delimiter=",", Columns=8, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"InvoiceNo", type text}, {"StockCode", type text}, {"Description", type text}, {"Quantity", Int64.Type}, {"InvoiceDate", type datetime}, {"UnitPrice", type number}, {"CustomerID", Int64.Type}, {"Country", type text}}),
    #"Filtered Rows" = Table.SelectRows(#"Changed Type", each [Quantity] > 0),
    #"Added Revenue" = Table.AddColumn(#"Filtered Rows", "Revenue", each [Quantity] * [UnitPrice], type number),
    #"Grouped by Month" = Table.Group(#"Added Revenue", {"Month" = Date.ToText([InvoiceDate], "yyyy-MM")}, {{"Monthly Revenue", each List.Sum([Revenue]), type number}})
in
    #"Grouped by Month"

// Use this to load data, then create charts in Excel for basic trends.
