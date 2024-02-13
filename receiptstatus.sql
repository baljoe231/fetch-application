/*When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?*/

SELECT rewardsReceiptStatus
  , AVG(total_spent) as average_receipt_spend
  , AVG(purchased_item_count) as total_number_items_purchased 
  /*I can see interpretations to use a SUM here (comparing total items of each) but the business question seems more geared towards identifying trends in fraudulent receipts so it is better to understand average across all receipts*/
FROM
receipts
WHERE
/*Please note, prompt notes status of Accepted or Rejected but the data does not include rewardsReceiptStatus of Accepted, but does have SUBMITTED and FINISHED- I'm using FINISHED as my proxy since that is a termination state*/
rewardsReceiptStatus in ('FINISHED', 'REJECTED') 
GROUP BY 1

/* I could do an Order By and limit to just pull back the receipt status that was greater for these two categories 
but for this type of business question I like showing the values of both so there is some relativity to "greater"*/
