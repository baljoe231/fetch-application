with receipts as (
  SELECT id, purchased_item_count, total_spent, points_earned
  FROM
  receipts
  WHERE
  rewardsReceiptStatus = 'FINISHED'
  --I think this is the only status that makes sense
)

, receipt_line_items as (
  SELECT 
  receipt_id 
  , SUM(finalPrice) as total_spent
  , SUM(quantityPurchased) as purchased_item_count
  , SUM(COALESCE(pointsEarned,0)) as points_earned
  FROM 
  receipt_line_items
  GROUP BY 1
)

SELECT receipts.receipt_id
  CASE WHEN receipts.purchased_item_count <> receipt_line_items.purchased_item_count THEN TRUE ELSE FALSE END as purchased_item_count_mismatch
  , CASE WHEN receipts.total_spent <> receipt_line_items.total_spent THEN TRUE ELSE FALSE END as total_spent_mismatch
  , CASE WHEN receipt_line_items.points_earned > 0 AND receipt_line_items.points_earned <> receipts.points_earned THEN TRUE ELSE FALSE END as points_earned_mismatch 
FROM
receipts 
JOIN receipt_line_items on receipt_line_items.receipt_id = receipts.id
  


