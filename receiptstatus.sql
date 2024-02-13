/*When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?*/
/*Which brand has the most spend among users who were created within the past 6 months?
Which brand has the most transactions among users who were created within the past 6 months?*/

SELECT rewardsReceiptStatus
  , AVG(totalSpent) as average_receipt_spend
  , AVG(purchasedItemCount) as total_number_items_purchased --I can see interpretations to use a SUM here (comparing total items of each_ but the business question seems more geared towards identifying trends in fraudulent receipts to better to understand average across all receipts
FROM
receipts
WHERE
--Please note, prompt notes status of Accepted or Rejected but the data does not include rewardsReceiptStatus of Accepted, but does have SUBMITTED and FINISHED- I'm using FINISHED as my proxy since that is a termination state
rewardsReceiptStatus in ('FINISHED', 'REJECTED') 
GROUP BY 1
