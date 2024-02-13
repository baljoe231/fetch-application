with receipts as (
  SELECT id, purchasedItemCount, totalSpent
  FROM
  receipts
  WHERE
  rewardsReceiptStatus = 'FINISHED'
  --I think this is the only status that makes sense
)

, receipt_line_items as (
  SELECT 
  receipt_id 
  , SUM(finalPrice) as totalSpent
  , SUM(quantityPurchased) as purchasedItemCount
  FROM 
  receipt_line_items
  GROUP BY 1
)

SELECT receipts.receipt_id
  CASE WHEN receipts.purchasedItemCount <> receipt_line_items.purchasedItemCount THEN TRUE ELSE FALSE END as purchasedItemCount_mismatch
  , CASE WHEN receipts.totalSpent <> receipt_line_items.totalSpent THEN TRUE ELSE FALSE END as totalSpent_mismatch
FROM
receipts 
JOIN receipt_line_items on receipt_line_items.receipt_id = receipts.id
  


