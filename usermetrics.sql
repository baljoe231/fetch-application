/*Which brand has the most spend among users who were created within the past 6 months?
Which brand has the most transactions among users who were created within the past 6 months?*/

SELECT brands.name, 
FROM
users 
JOIN receipts on receipts.userID = users.id
JOIN receipt_line_items on receipt_line_items.receipt_id = receipts.id 
JOIN cpg on cpg.id = receipt_line_items.rewardsProductPartnerId 
JOIN brands on brands.id = cpg.brand_id
WHERE
users.createdDate > CURRENT_DATE - INTERVAL '6 months'
