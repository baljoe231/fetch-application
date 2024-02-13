/*Which brand has the most spend among users who were created within the past 6 months?
Which brand has the most transactions among users who were created within the past 6 months?*/

SELECT brands.name
  , SUM(receipts.total_spend)
  /*I think transaction could have 1 of 3 meanings: total number individual receipts, total number of line items, or total quantity purchased. 
  For purposes of reporting to the brand, I went with the line item definition as it gives the most context on what individual SKUs are the highest performing */ 
  , COUNT(DISTINCT receipt_line_items.id) as number_items_submitted
FROM
users 
JOIN receipts on receipts.user_id = users.id
JOIN receipt_line_items on receipt_line_items.receipt_id = receipts.id 
-- Noted it elsewhere as well but assumption is that for brand analytics we don't care about instances where a receipt doesn't have an associated brand so I don't use LEFT JOIN here
JOIN cpg on cpg.id = receipt_line_items.rewards_product_partner_id  
JOIN brands on brands.id = cpg.brand_id
WHERE
users.created_date > CURRENT_DATE - INTERVAL '6 months'
ORDER BY 
  2 DESC --First question
  -- 3 DESC Second question
LIMIT 1
