# Project Overview 

## First: Review Existing Unstructured Data and Diagram a New Structured Relational Data Model
I made an entity relationship in Miro to visualize a proposed relational db. 
<img width="1190" alt="Screenshot 2024-02-13 at 12 08 24 AM" src="https://github.com/baljoe231/fetch-application/assets/39926481/9a3d12a8-16af-4bcf-81c8-507b8bf070c1">
Some general notes 
+ In a perfect world, I would have liked to extract receipts.json using something like the snippet below in python (jupyter notebook) to extract all of the keys to ensure I was capturing all data but I got stuck at an Extra data error since this is multiple jsons and not a single json. 
  > with open("receipts.json") as file:
  > data = json.load(file)
  >keys = data.keys()
  >for i in data: print(i.keys())
+ I was able to use the below snippet to get everything into a list but then was spending too much time trying to navigate back to a dict type so I could use .keys. I wanted to hold true to the few hours for the assignment as much as possible but with more time, I probably would have done more research on latest python packages to see if they have better ways of handling these multiple jsons. Given the questions that followed, I didn't think identifying every potential datapoint was absolutely essential for this assignment
  > import json
  > data = []
  > with open("receipts.json") as f:
  > for line in f:
        > data.append(json.loads(line))
  > print(data)
+ Outside of mapping the 3 files provided at the start to their own corresponding tables I also decided to
  * Make a receipt_line_items table that would be a unique row for each receipt + SKU combo to make this a clean table to investigate
  * As a note, there were a lot of different use cases represented in the line items- user flagged attributes, needing a review, attribution related fields. In a full data warehouse, it would probably be valuable at a model layer to break these up for end users but I didn't think that was necessary here so left it in one table 
  * Reviewing the data, I saw the way to connect brands to receipts was via the receipt_line_items (makes sense, 1 receipt could have multiple brands) to a nested cpg value in brands. Given the nesting style, I opted for a separate table in case there could ever be multiple values here
  * Both rewards_product_partner_id and points_payer_id will join with the cpg brand process outlined above but you'll see me use rewards_product_partner_id as the reference because it has a higher availablity (I believe points_payer_id is a subcase of the overall brand association)
  * I saw a few other opportunities for additional tables (earned reasons seem to have scheduleds that should connect to a schedule table) but left them off to keep this cleanish
 
## Second: Write a query that directly answers a predetermined question from a business stakeholder
+ I used Postgres SQL to answer all questions
+ I answered all 6 questions using 3 files in sets of 2
  * top_brands answers the first 2
  * receiptstatus the second 2
  * usermetrics the final 2
 
## Third: Evaluate Data Quality Issues in the Data Provided
+ The most obvious one that jumped out to me was identifying any instances where the total attributes on the receipts (purchased items, total amount, earned points) would ever not match what you would get when summing the line items
+ Some other areas interesting to explore here are how the user attributes match to what is expected and monitoring that rejected receipts have the correct flow for points collection

## Fourth: Communicate with Stakeholders
I'm going to list my sample email below

Hello! I'm reaching out to learn a little bit more about how point totals are calculated for receipts. I noticed in a data monitor that we have instances where the sum of points for all items on a receipt don't match what the receipt lists as the point total. There are also some instances where we don't have points associated to items at all so I want to confirm flow for each of our use cases to ensure we are capturing all totals correctly and providing all correct information back to our brand partners. It'd also be valuable to get similar context for the bonus point structure to make sure we have robust monitors in place for each step and use case in this calculation.

