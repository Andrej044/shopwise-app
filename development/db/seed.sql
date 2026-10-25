BEGIN TRANSACTION;

INSERT INTO simulation_metadata(key,value) VALUES
('dataset_label','FICTIONAL DEMO DATA - NOT REAL RETAILER PRICES'),
('environment','simulation_only'),
('prepared_on','2026-10-25'),
('fixture_clock_utc','2026-10-25T12:00:00Z'),
('default_scenario','standard'),
('provenance','Hand-authored synthetic fixtures. No retailer price collection, live feeds, real branch coordinates, or real inventory.'),
('currency','CAD'),
('tax_policy','Comparisons are grocery subtotals before any applicable taxes/deposits. No tax engine supplied.'),
('directions_policy','Never open directions to a fixture branch. All branches are fictional and non-navigable.');

INSERT INTO retailers(id,display_name) VALUES
('no-frills','No Frills'),
('metro','Metro'),
('costco','Costco'),
('loblaws','Loblaws'),
('walmart','Walmart');

INSERT INTO branches(id,retailer_id,display_name) VALUES
('demo-no-frills','no-frills','FICTIONAL No Frills branch A'),
('demo-metro','metro','FICTIONAL Metro branch A'),
('demo-costco','costco','FICTIONAL Costco branch A'),
('demo-loblaws','loblaws','FICTIONAL Loblaws branch A'),
('demo-walmart','walmart','FICTIONAL Walmart branch A');

INSERT INTO products(id,display_name,category,variant,pack_amount,measure_unit,sale_basis,image_path) VALUES
('bananas','Bananas','Produce','Conventional yellow bananas',1000,'g','weight','../shopwise-design-kit/images/products/bananas-generic-v1.png'),
('broccoli','Broccoli','Produce','Whole head',1,'each','pack','../shopwise-design-kit/images/products/broccoli-generic-v1.png'),
('milk','Milk','Dairy','2 percent milk',4000,'mL','pack','../shopwise-design-kit/images/products/milk-generic-v1.png'),
('eggs','Eggs','Dairy','Large brown eggs',12,'each','pack','../shopwise-design-kit/images/products/eggs-generic-v1.png'),
('chicken','Chicken breast','Meat','Boneless skinless; weight estimate',1000,'g','weight','../shopwise-design-kit/images/products/chicken-generic-v1.png'),
('apples','Apples','Produce','Red apples; weight estimate',1000,'g','weight','../shopwise-design-kit/images/products/apples-generic-v1.png'),
('oranges','Oranges','Produce','Navel oranges; weight estimate',1000,'g','weight','../shopwise-design-kit/images/products/oranges-generic-v1.png'),
('strawberries','Strawberries','Produce','Fresh; fixed pack',454,'g','pack','../shopwise-design-kit/images/products/strawberries-generic-v1.png'),
('carrots','Carrots','Produce','Whole carrots; fixed bag',907,'g','pack','../shopwise-design-kit/images/products/carrots-generic-v1.png'),
('tomatoes','Tomatoes','Produce','Vine tomatoes; weight estimate',1000,'g','weight','../shopwise-design-kit/images/products/tomatoes-generic-v1.png'),
('potatoes','Potatoes','Produce','Golden potatoes; fixed bag',2270,'g','pack','../shopwise-design-kit/images/products/potatoes-generic-v1.png'),
('bread','Bread','Bakery','Whole-grain loaf',675,'g','pack','../shopwise-design-kit/images/products/bread-generic-v1.png'),
('cheese','Cheddar cheese','Dairy','Orange cheddar block',400,'g','pack','../shopwise-design-kit/images/products/cheese-generic-v1.png'),
('yogurt','Plain yogurt','Dairy','Plain yogurt tub',750,'g','pack','../shopwise-design-kit/images/products/yogurt-generic-v1.png'),
('salmon','Salmon','Fish','Raw fillet; weight estimate',1000,'g','weight','../shopwise-design-kit/images/products/salmon-generic-v1.png'),
('rice','White rice','Pantry','Uncooked white rice; fixed bag',1000,'g','pack','../shopwise-design-kit/images/products/rice-generic-v1.png'),
('pasta','Penne pasta','Pantry','Dry penne; fixed bag',500,'g','pack','../shopwise-design-kit/images/products/pasta-generic-v1.png');

INSERT INTO products(id,display_name,category,variant,pack_amount,measure_unit,sale_basis,image_path,alternative_to_product_id) VALUES
('rice-bulk','White rice bulk alternative','Pantry','Different demo pack: four kilograms',4000,'g','pack','../shopwise-design-kit/images/products/rice-generic-v1.png','rice'),
('pasta-bulk','Penne pasta bulk alternative','Pantry','Different demo pack: three kilograms',3000,'g','pack','../shopwise-design-kit/images/products/pasta-generic-v1.png','pasta');

INSERT INTO scenarios(id,display_name,description,as_of) VALUES
('standard','Standard comparison','Seventeen exact demo products across all five fictional branches.','2026-10-25T12:00:00Z'),
('ties','Tied lowest prices','Milk has matching lowest member-eligible prices at No Frills and Metro; distance breaks ranking ties.','2026-10-25T12:00:00Z'),
('nearby_vs_cheapest','Nearby versus cheapest','Milk at the distant Costco is cheaper; Metro is closest. Cheapest and Nearest produce different orders.','2026-10-25T12:00:00Z'),
('stale_missing','Stale and missing prices','Milk includes an expired offer, missing price, out-of-stock row, and an overly old but not expired observation.','2026-10-25T12:00:00Z'),
('bulk_membership','Membership and bulk alternatives','Costco eligibility and larger rice/pasta packs test cash outlay versus unit price. One Metro bread promotion needs two packs.','2026-10-25T12:00:00Z'),
('no_location','Location unavailable','Every distance is unknown while price comparison remains usable.','2026-10-25T12:00:00Z'),
('price_change','Price changes before adding','Metro milk rises after the initial observation; confirmation must use the newer observation.','2026-10-25T12:00:00Z'),
('partial_basket','Incomplete basket coverage','Salmon has no known price at any branch; no complete full-basket total is valid.','2026-10-25T12:00:00Z');

INSERT INTO distance_fixtures(scenario_id,branch_id,distance_metres) VALUES
('standard','demo-no-frills',3400),
('standard','demo-metro',800),
('standard','demo-costco',12000),
('standard','demo-loblaws',2100),
('standard','demo-walmart',5500),
('ties','demo-no-frills',3400),
('ties','demo-metro',800),
('ties','demo-costco',12000),
('ties','demo-loblaws',2100),
('ties','demo-walmart',5500),
('nearby_vs_cheapest','demo-no-frills',3400),
('nearby_vs_cheapest','demo-metro',800),
('nearby_vs_cheapest','demo-costco',12000),
('nearby_vs_cheapest','demo-loblaws',2100),
('nearby_vs_cheapest','demo-walmart',5500),
('stale_missing','demo-no-frills',3400),
('stale_missing','demo-metro',800),
('stale_missing','demo-costco',12000),
('stale_missing','demo-loblaws',2100),
('stale_missing','demo-walmart',5500),
('bulk_membership','demo-no-frills',3400),
('bulk_membership','demo-metro',800),
('bulk_membership','demo-costco',12000),
('bulk_membership','demo-loblaws',2100),
('bulk_membership','demo-walmart',5500),
('no_location','demo-no-frills',NULL),
('no_location','demo-metro',NULL),
('no_location','demo-costco',NULL),
('no_location','demo-loblaws',NULL),
('no_location','demo-walmart',NULL),
('price_change','demo-no-frills',3400),
('price_change','demo-metro',800),
('price_change','demo-costco',12000),
('price_change','demo-loblaws',2100),
('price_change','demo-walmart',5500),
('partial_basket','demo-no-frills',3400),
('partial_basket','demo-metro',800),
('partial_basket','demo-costco',12000),
('partial_basket','demo-loblaws',2100),
('partial_basket','demo-walmart',5500);

INSERT INTO price_observations(scenario_id,branch_id,product_id,price_cents,price_basis_amount,price_state,membership_required,price_channel,observed_at,valid_until,conditions) VALUES
('standard','demo-no-frills','bananas',179,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','bananas',219,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','bananas',169,1000,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','bananas',229,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','bananas',189,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','broccoli',249,1,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','broccoli',329,1,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','broccoli',279,1,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','broccoli',349,1,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','broccoli',269,1,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','milk',479,4000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','milk',499,4000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','milk',459,4000,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','milk',529,4000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','milk',489,4000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','eggs',399,12,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','eggs',449,12,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','eggs',379,12,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','eggs',469,12,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','eggs',409,12,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','chicken',1099,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','chicken',1249,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','chicken',1049,1000,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','chicken',1349,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','chicken',1149,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','apples',349,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','apples',399,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','apples',329,1000,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','apples',449,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','apples',359,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','oranges',299,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','oranges',349,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','oranges',279,1000,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','oranges',379,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','oranges',319,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','strawberries',399,454,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','strawberries',449,454,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','strawberries',379,454,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','strawberries',499,454,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','strawberries',349,454,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','carrots',229,907,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','carrots',279,907,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','carrots',249,907,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','carrots',299,907,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','carrots',219,907,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','tomatoes',349,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','tomatoes',429,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','tomatoes',329,1000,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','tomatoes',449,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','tomatoes',379,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','potatoes',449,2270,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','potatoes',499,2270,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','potatoes',429,2270,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','potatoes',549,2270,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','potatoes',399,2270,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','bread',299,675,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','bread',349,675,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','bread',279,675,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','bread',379,675,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','bread',289,675,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','cheese',549,400,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','cheese',599,400,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','cheese',529,400,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','cheese',649,400,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','cheese',579,400,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','yogurt',349,750,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','yogurt',399,750,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','yogurt',329,750,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','yogurt',429,750,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','yogurt',379,750,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','salmon',2299,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','salmon',2499,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','salmon',2199,1000,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','salmon',2699,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','salmon',2399,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','rice',349,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','rice',399,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','rice',329,1000,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','rice',429,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','rice',299,1000,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-no-frills','pasta',179,500,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-metro','pasta',219,500,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-costco','pasta',169,500,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Simulated membership requirement; no actual retailer offer'),
('standard','demo-loblaws','pasta',249,500,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only'),
('standard','demo-walmart','pasta',189,500,'known',0,'in_store','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional price for interface testing only');

INSERT INTO price_observations(scenario_id,branch_id,product_id,price_cents,price_basis_amount,price_state,availability,membership_required,minimum_packs,price_channel,observed_at,valid_until,conditions)
SELECT 'ties',branch_id,product_id,price_cents,price_basis_amount,price_state,availability,membership_required,minimum_packs,price_channel,observed_at,valid_until,conditions FROM price_observations WHERE scenario_id='standard';

INSERT INTO price_observations(scenario_id,branch_id,product_id,price_cents,price_basis_amount,price_state,availability,membership_required,minimum_packs,price_channel,observed_at,valid_until,conditions)
SELECT 'nearby_vs_cheapest',branch_id,product_id,price_cents,price_basis_amount,price_state,availability,membership_required,minimum_packs,price_channel,observed_at,valid_until,conditions FROM price_observations WHERE scenario_id='standard';

INSERT INTO price_observations(scenario_id,branch_id,product_id,price_cents,price_basis_amount,price_state,availability,membership_required,minimum_packs,price_channel,observed_at,valid_until,conditions)
SELECT 'stale_missing',branch_id,product_id,price_cents,price_basis_amount,price_state,availability,membership_required,minimum_packs,price_channel,observed_at,valid_until,conditions FROM price_observations WHERE scenario_id='standard';

INSERT INTO price_observations(scenario_id,branch_id,product_id,price_cents,price_basis_amount,price_state,availability,membership_required,minimum_packs,price_channel,observed_at,valid_until,conditions)
SELECT 'bulk_membership',branch_id,product_id,price_cents,price_basis_amount,price_state,availability,membership_required,minimum_packs,price_channel,observed_at,valid_until,conditions FROM price_observations WHERE scenario_id='standard';

INSERT INTO price_observations(scenario_id,branch_id,product_id,price_cents,price_basis_amount,price_state,availability,membership_required,minimum_packs,price_channel,observed_at,valid_until,conditions)
SELECT 'no_location',branch_id,product_id,price_cents,price_basis_amount,price_state,availability,membership_required,minimum_packs,price_channel,observed_at,valid_until,conditions FROM price_observations WHERE scenario_id='standard';

INSERT INTO price_observations(scenario_id,branch_id,product_id,price_cents,price_basis_amount,price_state,availability,membership_required,minimum_packs,price_channel,observed_at,valid_until,conditions)
SELECT 'price_change',branch_id,product_id,price_cents,price_basis_amount,price_state,availability,membership_required,minimum_packs,price_channel,observed_at,valid_until,conditions FROM price_observations WHERE scenario_id='standard';

INSERT INTO price_observations(scenario_id,branch_id,product_id,price_cents,price_basis_amount,price_state,availability,membership_required,minimum_packs,price_channel,observed_at,valid_until,conditions)
SELECT 'partial_basket',branch_id,product_id,price_cents,price_basis_amount,price_state,availability,membership_required,minimum_packs,price_channel,observed_at,valid_until,conditions FROM price_observations WHERE scenario_id='standard';

UPDATE price_observations SET price_cents=439 WHERE scenario_id='ties' AND product_id='milk' AND branch_id IN ('demo-no-frills','demo-metro');

UPDATE price_observations SET price_cents=399 WHERE scenario_id='nearby_vs_cheapest' AND product_id='milk' AND branch_id='demo-costco';

UPDATE price_observations SET observed_at='2026-10-23T10:00:00Z',valid_until='2026-10-24T10:00:00Z' WHERE scenario_id='stale_missing' AND product_id='milk' AND branch_id='demo-no-frills';

UPDATE price_observations SET price_cents=NULL,price_state='unknown' WHERE scenario_id='stale_missing' AND product_id='milk' AND branch_id='demo-metro';

UPDATE price_observations SET availability='out_of_stock' WHERE scenario_id='stale_missing' AND product_id='milk' AND branch_id='demo-costco';

UPDATE price_observations SET observed_at='2026-10-23T10:00:00Z',valid_until='2026-10-27T10:00:00Z' WHERE scenario_id='stale_missing' AND product_id='milk' AND branch_id='demo-walmart';

UPDATE price_observations SET price_cents=NULL,price_state='unknown' WHERE scenario_id='partial_basket' AND product_id='salmon';

UPDATE price_observations SET price_cents=249,minimum_packs=2,conditions='Fictional offer: per-pack price only when buying at least two packs; otherwise exclude this offer' WHERE scenario_id='bulk_membership' AND product_id='bread' AND branch_id='demo-metro';

INSERT INTO price_observations(scenario_id,branch_id,product_id,price_cents,price_basis_amount,price_state,membership_required,price_channel,observed_at,valid_until,conditions) VALUES
('bulk_membership','demo-costco','rice-bulk',999,4000,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional bulk alternative; different pack; user consent required'),
('bulk_membership','demo-costco','pasta-bulk',799,3000,'known',1,'warehouse','2026-10-25T10:00:00Z','2026-10-26T10:00:00Z','Fictional bulk alternative; different pack; user consent required');

INSERT INTO price_observations(scenario_id,branch_id,product_id,price_cents,price_basis_amount,price_state,membership_required,price_channel,observed_at,valid_until,conditions)
SELECT 'standard',branch_id,product_id,price_cents+20,price_basis_amount,'known',membership_required,price_channel,'2026-10-24T10:00:00Z','2026-10-25T10:00:00Z','Fictional historical observation; not a regular-price savings baseline' FROM price_observations WHERE scenario_id='standard' AND product_id='milk';

INSERT INTO price_observations(scenario_id,branch_id,product_id,price_cents,price_basis_amount,price_state,observed_at,valid_until,conditions) VALUES ('price_change','demo-metro','milk',529,4000,'known','2026-10-25T11:45:00Z','2026-10-26T11:45:00Z','Fictional changed price; confirm before adding');

INSERT INTO shopping_lists(id,scenario_id,title) VALUES ('demo-weekly-list','standard','FICTIONAL demo weekly list');

INSERT INTO shopping_list_items(id,list_id,product_id,selected_branch_id,selected_observation_id,quantity_amount,quantity_unit)
SELECT 'demo-item-milk','demo-weekly-list',product_id,branch_id,id,1,'pack' FROM price_observations WHERE scenario_id='standard' AND product_id='milk' AND branch_id='demo-metro' AND observed_at='2026-10-25T10:00:00Z';

INSERT INTO shopping_list_items(id,list_id,product_id,selected_branch_id,selected_observation_id,quantity_amount,quantity_unit)
SELECT 'demo-item-bananas','demo-weekly-list',product_id,branch_id,id,750,'g' FROM price_observations WHERE scenario_id='standard' AND product_id='bananas' AND branch_id='demo-no-frills' AND observed_at='2026-10-25T10:00:00Z';

INSERT INTO shopping_list_items(id,list_id,product_id,selected_branch_id,selected_observation_id,quantity_amount,quantity_unit)
SELECT 'demo-item-eggs','demo-weekly-list',product_id,branch_id,id,1,'pack' FROM price_observations WHERE scenario_id='standard' AND product_id='eggs' AND branch_id='demo-walmart' AND observed_at='2026-10-25T10:00:00Z';

INSERT INTO shopping_list_items(id,list_id,product_id,selected_branch_id,selected_observation_id,quantity_amount,quantity_unit)
SELECT 'demo-item-bread','demo-weekly-list',product_id,branch_id,id,1,'pack' FROM price_observations WHERE scenario_id='standard' AND product_id='bread' AND branch_id='demo-loblaws' AND observed_at='2026-10-25T10:00:00Z';

COMMIT;
