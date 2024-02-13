/*What are the top 5 brands by receipts scanned for most recent month?
How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?*/


with receipt_counts as (
  SELECT 
  TO_CHAR(receipts.date_scanned, 'YYYY-MM') as scanned_month
  , brands.name as brand_name
  , COUNT(DISTINCT receipts.id) as receipt_count
  FROM 
  receipts
  JOIN receipt_line_items on receipts.id = receipt_line_items.receipt_id
  /*Assumption- receipts that do not have receipt_line_items with associated rewardsProductPartnerId are not needed because those receipts are not associated with a partner brand. 
  If that assumption is incorrect, a left join could be swapped in to allow you to see the receipt count for a NULL brand. I've defaulted to not having it for performance*/
  JOIN cpg on receipt_line_items.rewards_product_partner_id = cpg.id
  JOIN brands on brands.id = cpg.brand_id
  GROUP BY 1, 2
)

, month_totals as (
SELECT scanned_month, receipt_count, brand_name
  , lag(receipt_count, 1) OVER (PARTITION BY brand_name ORDER BY scanned_month||'-01'::date) as receipt_scans_previous_month
FROM
receipt_counts 
ORDER BY brand_name
)

  
SELECT brand_name
, receipt_count as receipt_scans_most_recent_month
, receipt_scans_previous_month 
FROM 
month_totals
WHERE
scanned_month = TO_CHAR(CURRENT_DATE - interval '1 month', 'YYYY-MM') 
/*Assumption- I'm interpreting "most recent" as the last full month prior to the current month vs the current month which is a partial. 
If that is incorrect, I included a commented line showing a version that would use current month*/
-- scanned_month = TO_CHAR(CURRENT_DATE, 'YYYY-MM') 
ORDER BY 
receipt_count DESC 
LIMIT 5
